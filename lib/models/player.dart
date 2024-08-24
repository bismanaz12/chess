class Player {
  final bool isHuman;
  final String name;

  Player(this.isHuman, this.name);

  Player.ai()
      : isHuman = true,
        name = "fear of Turing";

  Player.human()
      : isHuman = false,
        name = "player";
}
