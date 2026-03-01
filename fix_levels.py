import json
import re

def fix_levels():
    with open('lib/models/level_model.dart', 'r', encoding='utf-8') as f:
        content = f.read()

    # We need to parse each level block
    blocks = re.split(r'(LevelModel\()', content)
    
    out_content = blocks[0]
    
    for i in range(1, len(blocks), 2):
        prefix = blocks[i] # "LevelModel("
        body = blocks[i+1]
        
        # Find the end of this LevelModel call
        # It usually ends with "  )," or something similar.
        # This regex is simplified, we'll extract letters, words, and extras.
        
        letters_match = re.search(r'letters:\s*\[(.*?)\]', body)
        words_matches = re.findall(r'word:\s*"([^"]+)"', body)
        extras_match = re.search(r'extras:\s*\[(.*?)\]', body)
        
        if not letters_match:
            out_content += prefix + body
            continue
            
        current_letters = [x.strip().strip('"').strip("'") for x in letters_match.group(1).split(',')]
        current_letters = [x for x in current_letters if x]
        
        all_words = list(words_matches)
        if extras_match:
            extras = [x.strip().strip('"').strip("'") for x in extras_match.group(1).split(',')]
            extras = [x for x in extras if x]
            all_words.extend(extras)
            
        # Determine the maximum required count for each abstract letter
        required_counts = {}
        for word in all_words:
            word_counts = {}
            for char in word:
                word_counts[char] = word_counts.get(char, 0) + 1
            
            for char, count in word_counts.items():
                if count > required_counts.get(char, 0):
                    required_counts[char] = count
                    
        # Construct new letters array
        new_letters = []
        for char, count in required_counts.items():
            new_letters.extend([char] * count)
            
        # It's possible the new_letters has more variants than before.
        # Let's shuffle them nicely or keep original order as much as possible
        final_letters = []
        # First, add the original letters if they are in required
        temp_req = dict(required_counts)
        for char in current_letters:
            if temp_req.get(char, 0) > 0:
                final_letters.append(char)
                temp_req[char] -= 1
                
        # Then add any missing ones
        for char, count in temp_req.items():
            final_letters.extend([char] * count)
            
        # Format the new letters string
        new_letters_str = ', '.join(f'"{c}"' for c in final_letters)
        
        # Replace in body
        new_body = body[:letters_match.start(1)] + new_letters_str + body[letters_match.end(1):]
        out_content += prefix + new_body

    with open('lib/models/level_model.dart', 'w', encoding='utf-8') as f:
        f.write(out_content)
        
if __name__ == '__main__':
    fix_levels()
    print("Levels updated successfully.")
