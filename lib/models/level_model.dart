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
  // Level 1
  LevelModel(
    id: 1, letters: ["E", "L", "M", "A", "S"],
    words: [WordPosition(word: "ELMAS", x: 3, y: 3, direction: "H"), WordPosition(word: "SELAM", x: 3, y: 2, direction: "V"), WordPosition(word: "ALEM", x: 5, y: 0, direction: "V"), WordPosition(word: "AMEL", x: 6, y: 3, direction: "V"), WordPosition(word: "ELMA", x: 0, y: 5, direction: "H"), WordPosition(word: "MESA", x: 2, y: 0, direction: "H")],
    extras: ["SEL", "SAL", "MAS", "LAM", "ELA", "MAL", "ASL"],
  ),
  // Level 2
  LevelModel(
    id: 2, letters: ["K", "A", "L", "E", "M"],
    words: [WordPosition(word: "KALEM", x: 3, y: 4, direction: "H"), WordPosition(word: "KEMAL", x: 3, y: 4, direction: "V"), WordPosition(word: "EMLAK", x: 5, y: 2, direction: "V"), WordPosition(word: "KELAM", x: 7, y: 0, direction: "V"), WordPosition(word: "ALEM", x: 0, y: 6, direction: "H"), WordPosition(word: "KALE", x: 1, y: 8, direction: "H")],
    extras: ["ELA", "KEM", "KAL", "LAK", "LAM", "MAL"],
  ),
  // Level 3
  LevelModel(
    id: 3, letters: ["O", "R", "M", "A", "N"],
    words: [WordPosition(word: "ORMAN", x: 3, y: 2, direction: "H"), WordPosition(word: "ROMAN", x: 3, y: 1, direction: "V"), WordPosition(word: "ONAR", x: 6, y: 0, direction: "V"), WordPosition(word: "NORM", x: 0, y: 3, direction: "H"), WordPosition(word: "ORAN", x: 0, y: 5, direction: "H"), WordPosition(word: "ROM", x: 5, y: 0, direction: "H")],
    extras: ["OMA", "NAM", "NAR", "MOR", "RAM"],
  ),
  // Level 4
  LevelModel(
    id: 4, letters: ["H", "A", "B", "E", "R"],
    words: [WordPosition(word: "HABER", x: 2, y: 3, direction: "H"), WordPosition(word: "BAHAR", x: 2, y: 1, direction: "V"), WordPosition(word: "HARE", x: 5, y: 0, direction: "V"), WordPosition(word: "HEBA", x: 0, y: 1, direction: "H"), WordPosition(word: "REHA", x: 6, y: 3, direction: "V")],
    extras: ["RAB", "HER", "BAR", "BRE", "HAR", "BAH", "ABE", "BER"],
  ),
  // Level 5
  LevelModel(
    id: 5, letters: ["K", "Ä°", "T", "A", "P"],
    words: [WordPosition(word: "KÄ°TAP", x: 4, y: 4, direction: "H"), WordPosition(word: "PATÄ°K", x: 4, y: 0, direction: "V"), WordPosition(word: "Ä°PTAL", x: 5, y: 4, direction: "V"), WordPosition(word: "KATÄ°P", x: 7, y: 3, direction: "V"), WordPosition(word: "TAKÄ°P", x: 0, y: 0, direction: "H"), WordPosition(word: "PAKET", x: 0, y: 2, direction: "H")],
    extras: ["PÄ°L", "TÄ°P", "KÄ°T", "PÄ°K", "KAT", "PAK", "AÄ°T"],
  ),
  // Level 6
  LevelModel(
    id: 6, letters: ["G", "Ãœ", "N", "E", "Å"],
    words: [WordPosition(word: "GÃœNEÅ", x: 0, y: 2, direction: "H"), WordPosition(word: "GÃœMÃœÅ", x: 0, y: 2, direction: "V"), WordPosition(word: "GÃœNE", x: 2, y: 0, direction: "V"), WordPosition(word: "GEN", x: 2, y: 0, direction: "H"), WordPosition(word: "ÅEN", x: 4, y: 2, direction: "V")],
    extras: ["GÃœN", "ÅEY", "GÃœR", "ÃœN", "NE", "EÅ"],
  ),
  // Level 7
  LevelModel(
    id: 7, letters: ["D", "E", "N", "Ä°", "Z"],
    words: [WordPosition(word: "DENÄ°Z", x: 2, y: 3, direction: "H"), WordPosition(word: "ZÄ°NDE", x: 2, y: 0, direction: "V"), WordPosition(word: "DÄ°ZGÄ°", x: 5, y: 2, direction: "V"), WordPosition(word: "DÄ°Z", x: 0, y: 0, direction: "H"), WordPosition(word: "DÄ°N", x: 0, y: 2, direction: "H")],
    extras: ["ZÄ°L", "ZOR", "NED", "ZÄ°G", "Ä°N", "Ä°Z"],
  ),
  // Level 8
  LevelModel(
    id: 8, letters: ["Ã‡", "Ä°", "Ã‡", "E", "K"],
    words: [WordPosition(word: "Ã‡Ä°Ã‡EK", x: 1, y: 3, direction: "H"), WordPosition(word: "KEÃ‡Ä°", x: 1, y: 1, direction: "V"), WordPosition(word: "Ã‡EKÄ°", x: 3, y: 3, direction: "V"), WordPosition(word: "Ã‡EKE", x: 4, y: 0, direction: "V"), WordPosition(word: "Ä°Ã‡", x: 3, y: 6, direction: "H"), WordPosition(word: "EK", x: 0, y: 1, direction: "H"), WordPosition(word: "KÄ°", x: 5, y: 3, direction: "V")],
    extras: ["Ã‡EK", "KÄ°Ã‡", "Ã‡Ä°Ä", "Ã‡Ä°L"],
  ),
  // Level 9
  LevelModel(
    id: 9, letters: ["V", "A", "T", "A", "N"],
    words: [WordPosition(word: "VATAN", x: 3, y: 2, direction: "H"), WordPosition(word: "TAVAN", x: 3, y: 0, direction: "V"), WordPosition(word: "VANA", x: 6, y: 1, direction: "V"), WordPosition(word: "VAAT", x: 0, y: 0, direction: "H"), WordPosition(word: "TAVA", x: 0, y: 3, direction: "H"), WordPosition(word: "NARA", x: 3, y: 4, direction: "H")],
    extras: ["VAN", "TAV", "ANA", "ATA", "ANT"],
  ),
  // Level 10
  LevelModel(
    id: 10, letters: ["S", "E", "V", "G", "Ä°"],
    words: [WordPosition(word: "SEVGÄ°", x: 2, y: 2, direction: "H"), WordPosition(word: "VERGÄ°", x: 3, y: 1, direction: "V"), WordPosition(word: "EVGÄ°", x: 5, y: 0, direction: "V"), WordPosition(word: "SERÄ°", x: 0, y: 5, direction: "H"), WordPosition(word: "EVSÄ°", x: 5, y: 0, direction: "H"), WordPosition(word: "SEV", x: 0, y: 5, direction: "V")],
    extras: ["GÄ°Z", "GÄ°R", "SÄ°G", "GEZ", "SÄ°S"],
  ),
  // Level 11
  LevelModel(
    id: 11, letters: ["D", "Ãœ", "N", "Y", "A"],
    words: [WordPosition(word: "DÃœNYA", x: 0, y: 4, direction: "H"), WordPosition(word: "AYDIN", x: 0, y: 2, direction: "V"), WordPosition(word: "DAYAN", x: 2, y: 0, direction: "V"), WordPosition(word: "YÃœN", x: 3, y: 4, direction: "V"), WordPosition(word: "YAD", x: 0, y: 0, direction: "H")],
    extras: ["YÃœN", "DÃœN", "YAN", "AY", "YA", "AN"],
  ),
  // Level 12
  LevelModel(
    id: 12, letters: ["Z", "A", "M", "A", "N"],
    words: [WordPosition(word: "ZAMAN", x: 3, y: 3, direction: "H"), WordPosition(word: "AZMAN", x: 3, y: 2, direction: "V"), WordPosition(word: "NAMAZ", x: 5, y: 1, direction: "V"), WordPosition(word: "AMAN", x: 7, y: 0, direction: "V"), WordPosition(word: "AZAM", x: 0, y: 4, direction: "H"), WordPosition(word: "MANA", x: 0, y: 2, direction: "H")],
    extras: ["ZAM", "NAM", "AMA", "NAZ", "ZAN"],
  ),
  // Level 13
  LevelModel(
    id: 13, letters: ["S", "O", "N", "U", "Ã‡"],
    words: [WordPosition(word: "SONUÃ‡", x: 0, y: 3, direction: "H"), WordPosition(word: "ONUR", x: 1, y: 3, direction: "V"), WordPosition(word: "SORU", x: 3, y: 0, direction: "V"), WordPosition(word: "SUÃ‡", x: 0, y: 5, direction: "H"), WordPosition(word: "SON", x: 3, y: 0, direction: "H")],
    extras: ["UÃ‡", "ON", "US", "Ã‡OK", "SAÃ‡"],
  ),
  // Level 14
  LevelModel(
    id: 14, letters: ["K", "A", "N", "A", "T"],
    words: [WordPosition(word: "KANAT", x: 3, y: 2, direction: "H"), WordPosition(word: "NAKAT", x: 3, y: 0, direction: "V"), WordPosition(word: "TANK", x: 5, y: 0, direction: "V"), WordPosition(word: "TAKA", x: 7, y: 2, direction: "V"), WordPosition(word: "KANT", x: 0, y: 4, direction: "H"), WordPosition(word: "ATAK", x: 7, y: 3, direction: "H")],
    extras: ["KAN", "ANA", "KAT", "TAN", "ANT"],
  ),
  // Level 15
  LevelModel(
    id: 15, letters: ["G", "Ã–", "Z", "E", "L"],
    words: [WordPosition(word: "GÃ–ZEL", x: 2, y: 2, direction: "H"), WordPosition(word: "GÃ–ZLÃœ", x: 2, y: 2, direction: "V"), WordPosition(word: "Ã–ZEL", x: 4, y: 1, direction: "V"), WordPosition(word: "GÃ–LE", x: 6, y: 0, direction: "V"), WordPosition(word: "GÃ–Z", x: 0, y: 4, direction: "H"), WordPosition(word: "Ã–ZE", x: 6, y: 1, direction: "H")],
    extras: ["Ã–Z", "GEL", "ZÄ°L", "ZOR"],
  ),
  // Level 16
  LevelModel(
    id: 16, letters: ["R", "E", "S", "Ä°", "M"],
    words: [WordPosition(word: "RESÄ°M", x: 3, y: 3, direction: "H"), WordPosition(word: "ESÄ°R", x: 3, y: 0, direction: "V"), WordPosition(word: "REÄ°S", x: 5, y: 0, direction: "V"), WordPosition(word: "MÄ°RS", x: 7, y: 3, direction: "V"), WordPosition(word: "SERÄ°", x: 0, y: 2, direction: "H"), WordPosition(word: "MÄ°DE", x: 0, y: 0, direction: "H")],
    extras: ["SÄ°M", "MÄ°R", "MÄ°S", "Ä°RS", "SER", "REM"],
  ),
  // Level 17
  LevelModel(
    id: 17, letters: ["Y", "I", "L", "D", "I", "Z"],
    words: [WordPosition(word: "YILDIZ", x: 2, y: 2, direction: "H"), WordPosition(word: "YILLIK", x: 2, y: 2, direction: "V"), WordPosition(word: "YILIÅ", x: 4, y: 0, direction: "V"), WordPosition(word: "YILI", x: 6, y: 1, direction: "V"), WordPosition(word: "DIÅ", x: 1, y: 6, direction: "H"), WordPosition(word: "YIL", x: 0, y: 4, direction: "H")],
    extras: ["ZIT", "ZÄ°L", "ZAR", "ZOR", "ZIH"],
  ),
  // Level 18
  LevelModel(
    id: 18, letters: ["B", "A", "Y", "R", "A", "K"],
    words: [WordPosition(word: "BAYRAK", x: 3, y: 4, direction: "H"), WordPosition(word: "YARBA", x: 3, y: 1, direction: "V"), WordPosition(word: "KABAY", x: 5, y: 0, direction: "V"), WordPosition(word: "KABAR", x: 7, y: 3, direction: "V"), WordPosition(word: "KAYA", x: 0, y: 2, direction: "H"), WordPosition(word: "YARA", x: 0, y: 5, direction: "H"), WordPosition(word: "AYAR", x: 5, y: 1, direction: "H")],
    extras: ["RAY", "KAY", "YAR", "BAR", "RAB", "KAR"],
  ),
  // Level 19
  LevelModel(
    id: 19, letters: ["T", "O", "P", "R", "A", "K"],
    words: [WordPosition(word: "TOPRAK", x: 0, y: 2, direction: "H"), WordPosition(word: "KOPAR", x: 1, y: 1, direction: "V"), WordPosition(word: "ORTAK", x: 3, y: 1, direction: "V"), WordPosition(word: "AKKOR", x: 5, y: 1, direction: "V"), WordPosition(word: "KROKÄ°", x: 5, y: 3, direction: "H"), WordPosition(word: "PARK", x: 8, y: 0, direction: "V")],
    extras: ["POT", "ROT", "KOP", "KART", "KAR", "KOT"],
  ),
  // Level 20
  LevelModel(
    id: 20, letters: ["Å", "A", "H", "A", "N", "E"],
    words: [WordPosition(word: "ÅAHANE", x: 1, y: 3, direction: "H"), WordPosition(word: "HAÅÄ°N", x: 1, y: 1, direction: "V"), WordPosition(word: "AÅÄ°NA", x: 4, y: 3, direction: "V"), WordPosition(word: "HANE", x: 6, y: 0, direction: "V"), WordPosition(word: "AHA", x: 0, y: 1, direction: "H"), WordPosition(word: "ÅAH", x: 3, y: 7, direction: "H"), WordPosition(word: "ANA", x: 0, y: 5, direction: "H")],
    extras: ["HAN", "NAAÅ", "ÅAN", "HAÅ", "AÅ"],
  ),
  // Level 21
  LevelModel(
    id: 21, letters: ["B", "Ä°", "L", "G", "Ä°"],
    words: [WordPosition(word: "BÄ°LGÄ°", x: 0, y: 0, direction: "H"), WordPosition(word: "BÄ°L", x: 0, y: 0, direction: "V")],
    extras: ["Ä°L", "LÄ°G"],
  ),
  // Level 22
  LevelModel(
    id: 22, letters: ["Y", "A", "Z", "I"],
    words: [WordPosition(word: "YAZI", x: 0, y: 0, direction: "H"), WordPosition(word: "YAZ", x: 0, y: 0, direction: "V")],
    extras: ["AZ", "AY"],
  ),
  // Level 23
  LevelModel(
    id: 23, letters: ["K", "A", "Y", "I", "K"],
    words: [WordPosition(word: "KAYIK", x: 0, y: 0, direction: "H"), WordPosition(word: "KAY", x: 0, y: 0, direction: "V")],
    extras: ["AYI", "YIK", "YAK"],
  ),
  // Level 24
  LevelModel(
    id: 24, letters: ["S", "A", "N", "A", "T"],
    words: [WordPosition(word: "SANAT", x: 0, y: 0, direction: "H"), WordPosition(word: "SANA", x: 0, y: 0, direction: "V")],
    extras: ["SAN", "NAT", "ATA"],
  ),
  // Level 25
  LevelModel(
    id: 25, letters: ["Z", "E", "K", "A"],
    words: [WordPosition(word: "ZEKA", x: 0, y: 0, direction: "H"), WordPosition(word: "KEZA", x: 2, y: 0, direction: "V")],
    extras: ["KAZ", "EZ"],
  ),
  // Level 26
  LevelModel(
    id: 26, letters: ["A", "Y", "N", "A"],
    words: [WordPosition(word: "AYNA", x: 0, y: 0, direction: "H"), WordPosition(word: "YAN", x: 1, y: 0, direction: "V")],
    extras: ["AY", "AN"],
  ),
  // Level 27
  LevelModel(
    id: 27, letters: ["Ã‡", "Ä°", "Ã‡", "E", "K"],
    words: [WordPosition(word: "Ã‡Ä°Ã‡EK", x: 0, y: 0, direction: "H"), WordPosition(word: "Ã‡EK", x: 2, y: 0, direction: "V")],
    extras: ["Ä°Ã‡", "EK"],
  ),
  // Level 28
  LevelModel(
    id: 28, letters: ["B", "Ã–", "C", "E", "K"],
    words: [WordPosition(word: "BÃ–CEK", x: 0, y: 0, direction: "H"), WordPosition(word: "CEK", x: 2, y: 0, direction: "V")],
    extras: ["EK", "BEK"],
  ),
  // Level 29
  LevelModel(
    id: 29, letters: ["H", "A", "V", "A"],
    words: [WordPosition(word: "HAVA", x: 0, y: 0, direction: "H"), WordPosition(word: "VAHA", x: 2, y: 0, direction: "V")],
    extras: ["AV", "HA", "AH"],
  ),
  // Level 30
  LevelModel(
    id: 30, letters: ["G", "E", "M", "Ä°"],
    words: [WordPosition(word: "GEMÄ°", x: 0, y: 0, direction: "H"), WordPosition(word: "GEM", x: 0, y: 0, direction: "V")],
    extras: ["MÄ°", "ME"],
  ),
  // Level 31
  LevelModel(
    id: 31, letters: ["U", "Ã‡", "A", "K"],
    words: [WordPosition(word: "UÃ‡AK", x: 0, y: 0, direction: "H"), WordPosition(word: "UÃ‡", x: 0, y: 0, direction: "V")],
    extras: ["AÃ‡", "AK", "KAÃ‡"],
  ),
  // Level 32
  LevelModel(
    id: 32, letters: ["O", "R", "M", "A", "N"],
    words: [WordPosition(word: "ORMAN", x: 0, y: 0, direction: "H"), WordPosition(word: "MOR", x: 2, y: 0, direction: "V")],
    extras: ["ON", "NAM"],
  ),
  // Level 33
  LevelModel(
    id: 33, letters: ["K", "Ã–", "P", "E", "K"],
    words: [WordPosition(word: "KÃ–PEK", x: 0, y: 0, direction: "H"), WordPosition(word: "PEK", x: 2, y: 0, direction: "V")],
    extras: ["EK", "KEP"],
  ),
  // Level 34
  LevelModel(
    id: 34, letters: ["A", "R", "S", "L", "A", "N"],
    words: [WordPosition(word: "ARSLAN", x: 0, y: 0, direction: "H"), WordPosition(word: "NAR", x: 5, y: 0, direction: "V")],
    extras: ["AR", "LAN", "SAL"],
  ),
  // Level 35
  LevelModel(
    id: 35, letters: ["T", "A", "V", "U", "K"],
    words: [WordPosition(word: "TAVUK", x: 0, y: 0, direction: "H"), WordPosition(word: "TAV", x: 0, y: 0, direction: "V")],
    extras: ["KUT", "AK", "AT"],
  ),
  // Level 36
  LevelModel(
    id: 36, letters: ["M", "E", "Y", "V", "E"],
    words: [WordPosition(word: "MEYVE", x: 0, y: 0, direction: "H"), WordPosition(word: "MEY", x: 0, y: 0, direction: "V")],
    extras: ["EV", "ME", "YEM"],
  ),
  // Level 37
  LevelModel(
    id: 37, letters: ["B", "A", "L", "I", "K"],
    words: [WordPosition(word: "BALIK", x: 0, y: 0, direction: "H"), WordPosition(word: "BAL", x: 0, y: 0, direction: "V")],
    extras: ["AL", "KIL", "BAK"],
  ),
  // Level 38
  LevelModel(
    id: 38, letters: ["K", "U", "Z", "U"],
    words: [WordPosition(word: "KUZU", x: 0, y: 0, direction: "H"), WordPosition(word: "KUZ", x: 0, y: 0, direction: "V")],
    extras: ["UZ"],
  ),
  // Level 39
  LevelModel(
    id: 39, letters: ["A", "T", "E", "Å"],
    words: [WordPosition(word: "ATEÅ", x: 0, y: 0, direction: "H"), WordPosition(word: "AT", x: 0, y: 0, direction: "V")],
    extras: ["EÅ", "TAÅ", "AÅ"],
  ),
  // Level 40
  LevelModel(
    id: 40, letters: ["S", "U", "Y", "U"],
    words: [WordPosition(word: "SUYU", x: 0, y: 0, direction: "H"), WordPosition(word: "SUY", x: 0, y: 0, direction: "V")],
    extras: ["SU", "UY"],
  ),
  // Level 41
  LevelModel(
    id: 41, letters: ["R", "E", "N", "K"],
    words: [WordPosition(word: "RENK", x: 0, y: 0, direction: "H"), WordPosition(word: "KEN", x: 3, y: 0, direction: "V")],
    extras: ["EN", "NE", "ERK"],
  ),
  // Level 42
  LevelModel(
    id: 42, letters: ["D", "O", "Ä", "A"],
    words: [WordPosition(word: "DOÄA", x: 0, y: 0, direction: "H"), WordPosition(word: "DAÄ", x: 0, y: 0, direction: "V")],
    extras: ["AÄ", "OD"],
  ),
  // Level 43
  LevelModel(
    id: 43, letters: ["D", "E", "N", "Ä°", "Z"],
    words: [WordPosition(word: "DENÄ°Z", x: 0, y: 0, direction: "H"), WordPosition(word: "DÄ°N", x: 0, y: 0, direction: "V")],
    extras: ["EN", "NE", "Ä°Z", "DÄ°Z"],
  ),
  // Level 44
  LevelModel(
    id: 44, letters: ["Å", "E", "H", "Ä°", "R"],
    words: [WordPosition(word: "ÅEHÄ°R", x: 0, y: 0, direction: "H"), WordPosition(word: "ÅER", x: 0, y: 0, direction: "V")],
    extras: ["EÅ", "RE", "HER"],
  ),
  // Level 45
  LevelModel(
    id: 45, letters: ["B", "A", "H", "A", "R"],
    words: [WordPosition(word: "BAHAR", x: 0, y: 0, direction: "H"), WordPosition(word: "BAR", x: 0, y: 0, direction: "V")],
    extras: ["AH", "HA", "AB", "ARA", "HAR"],
  ),
  // Level 46
  LevelModel(
    id: 46, letters: ["Y", "A", "Ä", "I", "Å"],
    words: [WordPosition(word: "YAÄIÅ", x: 0, y: 0, direction: "H"), WordPosition(word: "YAÄ", x: 0, y: 0, direction: "V")],
    extras: ["AY", "AÅ", "ÅA"],
  ),
  // Level 47
  LevelModel(
    id: 47, letters: ["K", "A", "Y", "A"],
    words: [WordPosition(word: "KAYA", x: 0, y: 0, direction: "H"), WordPosition(word: "KAY", x: 0, y: 0, direction: "V")],
    extras: ["AY", "YA", "AK"],
  ),
  // Level 48
  LevelModel(
    id: 48, letters: ["O", "K", "Y", "A", "N", "U", "S"],
    words: [WordPosition(word: "OKYANUS", x: 0, y: 0, direction: "H"), WordPosition(word: "KANO", x: 1, y: 0, direction: "V")],
    extras: ["OK", "SU", "SON", "YAK"],
  ),
  // Level 49
  LevelModel(
    id: 49, letters: ["G", "Ã–", "K", "Y", "Ãœ", "Z", "Ãœ"],
    words: [WordPosition(word: "GÃ–KYÃœZÃœ", x: 0, y: 0, direction: "H"), WordPosition(word: "GÃ–Z", x: 0, y: 0, direction: "V")],
    extras: ["Ã–K", "YÃœZ", "KÃ–Y"],
  ),
  // Level 50
  LevelModel(
    id: 50, letters: ["B", "Ä°", "L", "G", "E"],
    words: [WordPosition(word: "BÄ°LGE", x: 0, y: 0, direction: "H"), WordPosition(word: "BÄ°L", x: 0, y: 0, direction: "V"), WordPosition(word: "GEL", x: 3, y: 0, direction: "V")],
    extras: ["Ä°L", "BEL", "LÄ°G"],
  ),
  // Level 51
  LevelModel(
    id: 51, letters: ["P", "N", "Ä°", "S", "A"],
    words: [
      WordPosition(word: "NÄ°SAP", x: 0, y: 0, direction: "H"),
      WordPosition(word: "NASÄ°P", x: 0, y: 0, direction: "V"),
      WordPosition(word: "PÄ°S", x: 2, y: 2, direction: "H")
    ],
    extras: ["PAS", "SÄ°N", "ASÄ°", "ANÄ°", "Ä°SA", "PÄ°S"],
  ),
  // Level 52
  LevelModel(
    id: 52, letters: ["A", "Y", "H", "L", "A"],
    words: [
      WordPosition(word: "HALAY", x: 0, y: 0, direction: "H"),
      WordPosition(word: "HAYAL", x: 0, y: 0, direction: "V"),
      WordPosition(word: "YAL", x: 4, y: 0, direction: "V")
    ],
    extras: ["HALA", "HAL", "AYA", "YAL", "AY", "YA", "AH"],
  ),
  // Level 53
  LevelModel(
    id: 53, letters: ["Ãœ", "E", "R", "P", "S"],
    words: [
      WordPosition(word: "SÃœPER", x: 0, y: 0, direction: "H"),
      WordPosition(word: "SÃœRE", x: 0, y: 0, direction: "V"),
      WordPosition(word: "PÃœRE", x: 2, y: 0, direction: "V")
    ],
    extras: ["PRES", "PES", "SER", "ÃœS", "ER"],
  ),
  // Level 54
  LevelModel(
    id: 54, letters: ["B", "E", "Y", "A", "Z"],
    words: [
      WordPosition(word: "BEYAZ", x: 0, y: 0, direction: "H"),
      WordPosition(word: "BAZ", x: 0, y: 0, direction: "V"),
      WordPosition(word: "YAZ", x: 2, y: 0, direction: "V")
    ],
    extras: ["BEZ", "BAY", "YAZ", "AY", "YA", "AB"],
  ),
];

