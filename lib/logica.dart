const Map<String, Map<String, String>> resultados = {
  "papel": {"papel": "ninguém", "pedra": "papel", "tesoura": "tesoura"},
  "pedra": {"papel": "pedra", "pedra": "ninguém", "tesoura": "pedra"},
  "tesoura": {"papel": "tesoura", "tesoura": "ninguém", "pedra": "pedra"}
};

jogar(String jogador1, String jogador2) {
  if (jogador1 == jogador2) {
    return "ninguém";
  }
  var out = resultados[jogador1]![jogador2];
  return out == jogador1 ? jogador1 : jogador2;
}
