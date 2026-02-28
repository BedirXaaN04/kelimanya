import json

class CrosswordGenerator:
    def __init__(self, words):
        # Sort words by length descending
        self.words = sorted(words, key=len, reverse=True)
        self.grid = {}
        self.word_positions = []
        self.placed_words = []

    def place_first_word(self, word):
        self.word_positions.append({'word': word, 'x': 0, 'y': 0, 'direction': 'H'})
        self.placed_words.append(word)
        for i, char in enumerate(word):
            self.grid[(i, 0)] = char

    def can_place(self, word, x, y, direction):
        # Check if the word can be placed at x, y with direction without conflicts
        if direction == 'H':
            # Check prefix/suffix bounds (must be empty before and after)
            if (x - 1, y) in self.grid or (x + len(word), y) in self.grid:
                return False
            for i, char in enumerate(word):
                cx, cy = x + i, y
                if (cx, cy) in self.grid:
                    if self.grid[(cx, cy)] != char:
                        return False
                else:
                    # If empty, neighbors above and below must be empty to avoid accidental words
                    if (cx, cy - 1) in self.grid or (cx, cy + 1) in self.grid:
                        return False
            return True
        else: # 'V'
            if (x, y - 1) in self.grid or (x, y + len(word)) in self.grid:
                return False
            for i, char in enumerate(word):
                cx, cy = x, y + i
                if (cx, cy) in self.grid:
                    if self.grid[(cx, cy)] != char:
                        return False
                else:
                    if (cx - 1, cy) in self.grid or (cx + 1, cy) in self.grid:
                        return False
            return True

    def place_word(self, word, x, y, direction):
        self.word_positions.append({'word': word, 'x': x, 'y': y, 'direction': direction})
        self.placed_words.append(word)
        if direction == 'H':
            for i, char in enumerate(word):
                self.grid[(x + i, y)] = char
        else:
            for i, char in enumerate(word):
                self.grid[(x, y + i)] = char

    def try_place_word(self, word):
        for placed_word_info in self.word_positions:
            placed_word = placed_word_info['word']
            px, py = placed_word_info['x'], placed_word_info['y']
            pdir = placed_word_info['direction']

            for i, pchar in enumerate(placed_word):
                for j, char in enumerate(word):
                    if pchar == char:
                        # Potential intersection
                        if pdir == 'H':
                            nx = px + i
                            ny = py - j
                            ndir = 'V'
                        else:
                            nx = px - j
                            ny = py + i
                            ndir = 'H'

                        if self.can_place(word, nx, ny, ndir):
                            self.place_word(word, nx, ny, ndir)
                            return True
        return False

    def generate(self):
        if not self.words:
            return []
        self.place_first_word(self.words[0])
        unplaced = []
        for word in self.words[1:]:
            if not self.try_place_word(word):
                unplaced.append(word)
        
        # Normalize coordinates so all are >= 0
        if not self.word_positions: return []
        min_x = min(pos['x'] for pos in self.word_positions)
        min_y = min(pos['y'] for pos in self.word_positions)
        
        for pos in self.word_positions:
            pos['x'] -= min_x
            pos['y'] -= min_y
            
        return self.word_positions, unplaced


levels_data = [
    # Letters, Main Words, Extras
    (["E", "L", "M", "A", "S"], ["ELMAS", "SELAM", "ALEM", "AMEL", "ELMA", "MESA"], ["SEL", "SAL", "MAS", "LAM", "ELA", "MAL", "ASL"]),
    (["K", "A", "L", "E", "M"], ["KALEM", "KEMAL", "EMLAK", "KELAM", "ALEM", "KALE"], ["ELA", "KEM", "KAL", "LAK", "LAM", "MAL"]),
    (["O", "R", "M", "A", "N"], ["ORMAN", "ROMAN", "ONAR", "NORM", "ORAN", "ROM"], ["OMA", "NAM", "NAR", "MOR", "RAM", "OMA"]),
    (["H", "A", "B", "E", "R"], ["HABER", "BAHAR", "HARE", "HEBA", "REHA"], ["RAB", "HER", "BAR", "BRE", "HAR", "BAH", "ABE", "BER"]), 
    (["K", "İ", "T", "A", "P"], ["KİTAP", "PATİK", "İPTAL", "KATİP", "TAKİP", "PAKET"], ["PİL", "TİP", "KİT", "PİK", "KAT", "PAK", "AİT"]),
    (["G", "Ü", "N", "E", "Ş"], ["GÜNEŞ", "GÜMÜŞ", "GÜNE", "GEN", "ŞEN"], ["GÜN", "ŞEY", "GÜR", "ÜN", "NE", "EŞ"]),
    (["D", "E", "N", "İ", "Z"], ["DENİZ", "ZİNDE", "DİZGİ", "DİZ", "DİN"], ["ZİL", "ZOR", "NED", "ZİG", "İN", "İZ"]),
    (["Ç", "İ", "Ç", "E", "K"], ["ÇİÇEK", "KEÇİ", "ÇEKİ", "ÇEKE", "İÇ", "EK", "Kİ"], ["ÇEK", "KİÇ", "ÇİĞ", "ÇİL"]),
    (["V", "A", "T", "A", "N"], ["VATAN", "TAVAN", "VANA", "VAAT", "TAVA", "NARA"], ["VAN", "TAV", "ANA", "ATA", "ANT"]),
    (["S", "E", "V", "G", "İ"], ["SEVGİ", "VERGİ", "EVGİ", "SERİ", "SEV", "EVSİ"], ["GİZ", "GİR", "SİG", "GEZ", "SİS"]),
    (["D", "Ü", "N", "Y", "A"], ["DÜNYA", "YÜN", "YAD", "AYDIN", "DAYAN"], ["YÜN", "DÜN", "YAN", "AY", "YA", "AN"]),
    (["Z", "A", "M", "A", "N"], ["ZAMAN", "AZMAN", "NAMAZ", "AMAN", "AZAM", "MANA"], ["ZAM", "NAM", "AMA", "NAZ", "ZAN"]),
    (["S", "O", "N", "U", "Ç"], ["SONUÇ", "ONUR", "SORU", "SUÇ", "SON"], ["UÇ", "ON", "US", "ÇOK", "SAÇ"]),
    (["K", "A", "N", "A", "T"], ["KANAT", "NAKAT", "TANK", "TAKA", "KANT", "ATAK"], ["KAN", "ANA", "KAT", "TAN", "ANT"]),
    (["G", "Ö", "Z", "E", "L"], ["GÖZEL", "GÖZLÜ", "ÖZEL", "GÖZ", "ÖZE", "GÖLE"], ["ÖZ", "GEL", "ZİL", "ZOR"]),
    (["R", "E", "S", "İ", "M"], ["RESİM", "ESİR", "REİS", "MİRS", "SERİ", "MİDE"], ["SİM", "MİR", "MİS", "İRS", "SER", "REM"]),
    (["Y", "IL", "D", "I", "Z"], ["YILDIZ", "YILLIK", "YILIŞ", "YILI", "DIŞ", "YIL"], ["ZIT", "ZİL", "ZAR", "ZOR", "ZIH"]),
    (["B", "A", "Y", "R", "A", "K"], ["BAYRAK", "YARBA", "KABAY", "KABAR", "KAYA", "YARA", "AYAR"], ["RAY", "KAY", "YAR", "BAR", "RAB", "KAR"]),
    (["T", "O", "P", "R", "A", "K"], ["TOPRAK", "KOPAR", "PARK", "ORTAK", "AKKOR", "KROKİ"], ["POT", "ROT", "KOP", "KART", "KAR", "KOT"]),
    (["Ş", "A", "H", "A", "N", "E"], ["ŞAHANE", "HAŞİN", "AŞİNA", "HANE", "AHA", "ŞAH", "ANA"], ["HAN", "NAAŞ", "ŞAN", "HAŞ", "AŞ"]),
]

output_dart = []

for i, (letters, words, extras) in enumerate(levels_data):
    cg = CrosswordGenerator(words)
    positions, unplaced = cg.generate()
    # Filter only placed words
    
    dart_words = []
    for pos in positions:
        w = pos['word']
        x = pos['x']
        y = pos['y']
        d = pos['direction']
        dart_words.append(f'WordPosition(word: "{w}", x: {x}, y: {y}, direction: "{d}")')
    
    # Format letters
    letters_str = ", ".join(f'"{l}"' for l in letters)
    extras_str = ", ".join(f'"{e}"' for e in extras + unplaced)
    
    level_code = f"""  // Level {i+1}
  LevelModel(
    id: {i+1}, letters: [{letters_str}],
    words: [{', '.join(dart_words)}],
    extras: [{extras_str}],
  ),"""
    output_dart.append(level_code)

print("\n".join(output_dart))
