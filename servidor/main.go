package main

//each and every file in go must have a package name
import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"math/rand"
	"net/http"
	"time"

	bd "github.com/dgraph-io/badger/v3"
)

type User struct {
	Email     string `json:"email"`
	Passwd    string `json:"password"`
	Nickname  string `json:"nickname"`
	GamesWon  int    `json:"games_won"`
	GamesLost int    `json:"games_lost"`
	GamesTied int    `json:"games_tied"`
}
type UserRegister struct {
	Email    string `json:"email"`
	Passwd   string `json:"password"`
	Nickname string `json:"nickname"`
	// GamesWon  int    `json:"games_won"`
	// GamesLost int    `json:"games_lost"`
	// GamesTied int    `json:"games_tied"`
}
type Login struct {
	Email  string `json:"email"`
	Passwd string `json:"password"`
}

type Game struct {
	ID        int       `json:"id"`
	Timestamp time.Time `json:"date"`
	Players   [2]string `json:"players"`
	Plays     [2]string `json:"plays"`
	Winner    string    `json:"winner"`
}

var (
	sesh      = map[string]User{}
	lobby     = []User{}
	games     = []Game{}
	gameCount = 0
)

func RandomString(n int) string {
	var letters = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")

	s := make([]rune, n)
	for i := range s {
		s[i] = letters[rand.Intn(len(letters))]
	}
	return string(s)
}

// TODO:
// - Persist games, sessions, lobby
// - Add a way to get the game history
// - leaderboard

func main() {
	db, err := bd.Open(bd.DefaultOptions("./db").WithZSTDCompressionLevel(2))
	if err != nil {
		panic(err)
	}
	defer db.Close()

	handler := http.NewServeMux()
	handler.HandleFunc("/register", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "gimme in POST", http.StatusMethodNotAllowed)
			return
		}
		body, err := io.ReadAll(r.Body)
		if err != nil {
			http.Error(w, "could not read body", http.StatusBadRequest)
			return
		}
		user := UserRegister{}
		err = json.Unmarshal(body, &user)
		if err != nil {
			http.Error(w, "could not parse body "+string(body), http.StatusBadRequest)
			return
		}
		err = db.View(func(txn *bd.Txn) error {
			_, err := txn.Get([]byte("user." + user.Email))
			if err != nil {
				return nil
			}
			return errors.New("dude already there")
		})
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}
		err = db.Update(func(txn *bd.Txn) error {
			usr := User{
				Email:    user.Email,
				Passwd:   user.Passwd,
				Nickname: user.Nickname,
			}
			userJson, err := json.Marshal(usr)
			if err != nil {
				return err
			}
			err = txn.Set([]byte("user."+user.Email), userJson)
			return err
		})
		if err != nil {
			http.Error(w, "could not write to db", http.StatusInternalServerError)
			return
		}
		fmt.Fprintf(w, "registered %s", user.Email)
	})

	handler.HandleFunc("/login", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "gimme in POST", http.StatusMethodNotAllowed)
			return
		}
		body, err := io.ReadAll(r.Body)
		if err != nil {
			http.Error(w, "could not read body", http.StatusBadRequest)
			return
		}
		user := Login{}
		err = json.Unmarshal(body, &user)
		if err != nil {
			http.Error(w, "could not parse body", http.StatusBadRequest)
			return
		}
		db.View(func(txn *bd.Txn) error {
			val, err := txn.Get([]byte("user." + user.Email))
			if err != nil {
				http.Error(w, "0 could not read from db, do you even exist?", http.StatusInternalServerError)
				return err
			}
			dst := []byte{}
			if dst, err = val.ValueCopy(dst); err != nil {
				http.Error(w, "1 could not read from db, do you even exist?", http.StatusInternalServerError)
				return err
			}
			usr := User{}
			err = json.Unmarshal(dst, &usr)
			if err != nil {
				fmt.Println(string(dst))
				http.Error(w, "2 could not read from db, do you even exist?", http.StatusInternalServerError)
				return err
			}
			if usr.Passwd != user.Passwd {
				http.Error(w, "wrong password", http.StatusUnauthorized)
				return nil
			}
			sess := RandomString(32)
			sesh[sess] = usr
			fmt.Fprint(w, sess)
			return nil
		})
	})

	handler.HandleFunc("/logout", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "gimme in POST", http.StatusMethodNotAllowed)
			return
		}
		body, err := io.ReadAll(r.Body)
		if err != nil {
			http.Error(w, "could not read body", http.StatusBadRequest)
			return
		}
		if _, ok := sesh[string(body)]; !ok {
			http.Error(w, "no such session", http.StatusBadRequest)
			return
		}
		sess := string(body)
		delete(sesh, sess)
		fmt.Fprint(w, "logged out")
	})
	posJson := func(pos int) []byte {
		ret := struct {
			Position int `json:"position"`
		}{pos}
		retJson, _ := json.Marshal(ret)
		return retJson
	}
	handler.HandleFunc("/join-lobby", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "gimme in POST", http.StatusMethodNotAllowed)
			return
		}
		body, err := io.ReadAll(r.Body)
		if err != nil {
			http.Error(w, "could not read body", http.StatusBadRequest)
			return
		}
		if player, ok := sesh[string(body)]; !ok {
			http.Error(w, "no such session", http.StatusBadRequest)
			return
		} else {
			for i, p := range lobby {
				if p.Email == player.Email {
					fmt.Fprint(w, string(posJson(i)))
					return
				}
			}
			lobby = append(lobby, player)
			fmt.Fprint(w, string(posJson(len(lobby)-1)))
		}
	})

	handler.HandleFunc("/query-lobby", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "gimme in POST", http.StatusMethodNotAllowed)
			return
		}
		body, err := io.ReadAll(r.Body)
		if err != nil {
			http.Error(w, "could not read body", http.StatusBadRequest)
			return
		}
		player, ok := sesh[string(body)]
		if !ok {
			http.Error(w, "no such session", http.StatusBadRequest)
			return
		}
		if len(lobby) <= 1 {
			fmt.Fprint(w, string(posJson(0)))
			return
		}
		for i, p := range lobby {
			if p.Email == player.Email {
				lobby = append(lobby[:i], lobby[i+1:]...)
				break
			}
		}
		ip2 := rand.Intn(len(lobby))
		p2 := lobby[ip2]
		lobby = append(lobby[:ip2], lobby[ip2+1:]...)
		game := Game{
			Players:   [2]string{player.Email, p2.Email},
			Timestamp: time.Now(),
			ID:        gameCount,
		}
		games = append(games, game)
		gameCount++
		gameJson, err := json.Marshal(game)
		if err != nil {
			http.Error(w, "could not marshal game", http.StatusInternalServerError)
			return
		}
		fmt.Fprint(w, string(gameJson))
	})

	handler.HandleFunc("/leave-lobby", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "gimme in POST", http.StatusMethodNotAllowed)
			return
		}
		body, err := io.ReadAll(r.Body)
		if err != nil {
			http.Error(w, "could not read body", http.StatusBadRequest)
			return
		}
		if player, ok := sesh[string(body)]; !ok {
			http.Error(w, "no such session", http.StatusBadRequest)
			return
		} else {
			for i, p := range lobby {
				if p.Email == player.Email {
					lobby = append(lobby[:i], lobby[i+1:]...)
					fmt.Fprint(w, "left lobby at position ", i)
					return
				}
			}
		}
	})

	http.ListenAndServe("0.0.0.0:8080", handler)
}
