class Helper {
  static String generateId(int length) {
    String value = "";
    var characters = [
      "0",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "a",
      "s",
      "d",
      "f",
      "g",
      "h",
      "j",
      "k",
      "l",
      "q",
      "w",
      "e",
      "r",
      "t",
      "y",
      "u",
      "i",
      "o",
      "p",
      "z",
      "x",
      "c",
      "v",
      "b",
      "n",
      "m",
    ];
    for (var c = 0; c < length; c++) {
      characters.shuffle();
      value = value + characters[0];
    }
    return value;
  }
}
