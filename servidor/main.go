package main

//each and every file in go must have a package name
import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"math/rand"
	"net/http"
	"sort"
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

type UserList []User

func (l UserList) Len() int      { return len(l) }
func (l UserList) Swap(i, j int) { l[i], l[j] = l[j], l[i] }
func (l UserList) Less(i, j int) bool {
	return l[i].GamesWon < l[j].GamesWon
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
	Winner    int       `json:"winner"`
}

type Play struct {
	GameID    int    `json:"id"`
	Play      string `json:"play"`
	SessionID string `json:"session_id"`
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
				Passwd:   hashItUp(user.Passwd),
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
			if usr.Passwd != hashItUp(user.Passwd) {
				http.Error(w, "wrong password"+usr.Passwd+"  "+hashItUp(user.Passwd)+"  "+user.Passwd, http.StatusUnauthorized)
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
		for _, g := range games {
			if g.Players[0] == player.Email || g.Players[1] == player.Email {
				gameJson, err := json.Marshal(g)
				if err != nil {
					http.Error(w, "could not marshal game", http.StatusInternalServerError)
					return
				}
				fmt.Fprint(w, string(gameJson))
				return
			}
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

	handler.HandleFunc("/play", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "gimme in POST", http.StatusMethodNotAllowed)
			return
		}
		body, err := io.ReadAll(r.Body)
		if err != nil {
			http.Error(w, "could not read body", http.StatusBadRequest)
			return
		}
		play := Play{}
		err = json.Unmarshal(body, &play)
		if err != nil {
			http.Error(w, "could not unmarshal play", http.StatusBadRequest)
			return
		}
		if player, ok := sesh[play.SessionID]; !ok {
			http.Error(w, "no such session", http.StatusBadRequest)
			return
		} else {
			for i, g := range games {
				if g.ID == play.GameID {
					if g.Players[0] == player.Email {
						if g.Plays[0] != "" {
							http.Error(w, "already played", http.StatusBadRequest)
							return
						}
						g.Plays[0] = play.Play
						fmt.Fprintf(w, "played %s", play.Play)
					} else if g.Players[1] == player.Email {
						if g.Plays[1] != "" {
							http.Error(w, "already played", http.StatusBadRequest)
							return
						}
						g.Plays[1] = play.Play
						fmt.Fprintf(w, "played %s", play.Play)
					}
					games[i] = g
					return
				}
			}
			fmt.Fprintf(w, "no game with you innit")
		}
	})

	handler.HandleFunc("/get-user", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "gimme in POST", http.StatusMethodNotAllowed)
			return
		}
		body, err := io.ReadAll(r.Body)
		if err != nil {
			http.Error(w, "could not read body", http.StatusBadRequest)
			return
		}
		fmt.Println(string(body))
		player := getUser(db, string(body))
		player.Passwd = "niceTryFBI"
		playerJson, err := json.Marshal(player)
		if err != nil {
			fmt.Fprintf(w, "player %s not found", body)
			return
		}
		fmt.Fprint(w, string(playerJson))
	})

	handler.HandleFunc("/query-game", func(w http.ResponseWriter, r *http.Request) {
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
			for _, g := range games {
				if g.Players[0] == player.Email || g.Players[1] == player.Email {
					p1, p2 := getUser(db, g.Players[0]), getUser(db, g.Players[1])
					g.Winner = WhoWon(g.Plays[0], g.Plays[1])
					switch g.Winner {
					case 0:
						// empatado
						p1.GamesTied++
						p2.GamesTied++
					case 1:
						// p1
						p1.GamesWon++
						p2.GamesLost++
					case 2:
						// p2
						p1.GamesLost++
						p2.GamesWon++
					}
					check := func(e error) {
						if e != nil {
							fmt.Println("oops", e)
						}
					}
					err = saveUser(db, p1)
					check(err)
					err = saveUser(db, p2)
					check(err)
					gameJson, err := json.Marshal(g)
					if err != nil {
						http.Error(w, "could not marshal game", http.StatusInternalServerError)
						return
					}
					fmt.Fprintf(w, string(gameJson))
				}
			}
		}
	})

	handler.HandleFunc("/get-leaderboard", func(w http.ResponseWriter, r *http.Request) {
		userByte := []byte("user.")
		users := UserList{}
		db.View(func(tx *bd.Txn) error {
			it := tx.NewIterator(bd.DefaultIteratorOptions)
			defer it.Close()
			for it.Seek(userByte); it.ValidForPrefix(userByte); it.Next() {
				item := it.Item()
				key := item.Key()
				if len(key) == len("user.") {
					continue
				}
				dst := []byte{}
				dst, err := item.ValueCopy(dst)
				if err != nil {
					return err
				}
				user := User{}
				err = json.Unmarshal(dst, &user)
				if err != nil {
					fmt.Println("oops", err)
					continue
				}
				user.Passwd = "niceTryFBI"
				users = append(users, user)
			}
			return nil
		})
		sort.Sort(users)
		leaderboardJson, err := json.Marshal(users)
		if err != nil {
			http.Error(w, "could not marshal leaderboard", http.StatusInternalServerError)
			return
		}
		fmt.Fprint(w, string(leaderboardJson))
	})
	http.ListenAndServe("0.0.0.0:8080", handler)
}

var (
	resultados = map[string]map[string]int{
		"papel":   {"papel": 0, "pedra": 1, "tesoura": 2},
		"pedra":   {"papel": 2, "pedra": 0, "tesoura": 1},
		"tesoura": {"papel": 1, "tesoura": 0, "pedra": 2},
	}
)

func WhoWon(p1 string, p2 string) int {
	return resultados[p1][p2]
}

func getUser(db *bd.DB, email string) User {
	user := User{}
	err := db.View(func(txn *bd.Txn) error {
		item, err := txn.Get([]byte("user." + email))
		if err != nil {
			return err
		}
		dst := []byte{}
		dst = item.KeyCopy(dst)
		json.Unmarshal(dst, &user)
		return nil
	})
	if err != nil {
		fmt.Println("quem é esse cara? ", email)
		return User{}
	}
	return user
}

func saveUser(db *bd.DB, user User) error {
	return db.Update(func(txn *bd.Txn) error {
		userJson, err := json.Marshal(user)
		if err != nil {
			return err
		}
		err = txn.Set([]byte("user."+user.Email), userJson)
		return err
	})
}

func hashItUp(password string) string {
	hashed := sha256.Sum256([]byte(password))
	return hex.EncodeToString(hashed[:])
}
