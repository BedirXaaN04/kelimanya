class WordPosition {
  final String word;
  final int x;
  final int y;
  final String direction; // 'H' for horizontal, 'V' for vertical

  WordPosition({
    required this.word,
    required this.x,
    required this.y,
    required this.direction,
  });

  factory WordPosition.fromJson(Map<String, dynamic> json) {
    return WordPosition(
      word: json['w'],
      x: json['x'],
      y: json['y'],
      direction: json['d'],
    );
  }
}

class LevelModel {
  final int id;
  final List<String> letters;
  final List<WordPosition> words;
  final List<String> extras;

  LevelModel({
    required this.id,
    required this.letters,
    required this.words,
    required this.extras,
  });
}

final List<LevelModel> gameLevels = [
  LevelModel(
    id: 1,
    letters: ["A", "K", "Ş"],
    words: [
      WordPosition(word: "AŞK", x: 0, y: 0, direction: "H"),
      WordPosition(word: "KAŞ", x: 2, y: 0, direction: "V"),
    ],
    extras: ["AK", "AŞ"],
  ),
  LevelModel(
    id: 2,
    letters: ["O", "P", "T"],
    words: [
      WordPosition(word: "TOP", x: 0, y: 0, direction: "H"),
      WordPosition(word: "POT", x: 2, y: 0, direction: "V"),
    ],
    extras: ["OT"],
  ),
  LevelModel(
    id: 3,
    letters: ["K", "A", "L", "E"],
    words: [
      WordPosition(word: "KALE", x: 0, y: 1, direction: "H"),
      WordPosition(word: "KEL", x: 0, y: 1, direction: "V"),
      WordPosition(word: "ELA", x: 3, y: 1, direction: "V"),
    ],
    extras: ["EL", "AL", "AK"],
  ),
  LevelModel(
    id: 4,
    letters: ["K", "İ", "T", "A", "P"],
    words: [
      WordPosition(word: "KİTAP", x: 0, y: 2, direction: "H"),
      WordPosition(word: "PATİ", x: 2, y: 0, direction: "V"),
      WordPosition(word: "İP", x: 2, y: 3, direction: "H"),
    ],
    extras: ["KAT", "AT", "İT"],
  ),
];
