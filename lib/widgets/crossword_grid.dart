import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'letter_box.dart';

class CrosswordGrid extends StatelessWidget {
  const CrosswordGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final level = provider.currentLevel;

    // Calculate grid bounds
    int maxX = 0;
    int maxY = 0;
    
    // Determine cell positions and states
    // A cell might belong to multiple words (intersection)
    Map<String, Map<String, dynamic>> cells = {}; // "x,y" : {letter, isFound}

    for (var wordPos in level.words) {
      int x = wordPos.x;
      int y = wordPos.y;
      bool wordFound = provider.foundWords.contains(wordPos.word);

      for (int i = 0; i < wordPos.word.length; i++) {
        String char = wordPos.word[i];
        String key = "$x,$y";

        if (!cells.containsKey(key)) {
          cells[key] = {
            'letter': char,
            'x': x,
            'y': y,
            'isFound': false, // will update if any of its word is found
            'isHinted': false,
          };
        }
        
        // If at least one word occupying this cell is found, cell is revealed
        if (wordFound) {
          cells[key]!['isFound'] = true;
        }

        // Apply hint logic
        if (provider.hintedCoordinates.contains(key)) {
            cells[key]!['isHinted'] = true;
        }

        maxX = max(maxX, x);
        maxY = max(maxY, y);

        if (wordPos.direction == 'H') {
          x++;
        } else {
          y++;
        }
      }
    }

    double cellSize = 52.0; // 46 + spacing
    double gridWidth = (maxX + 1) * cellSize;
    double gridHeight = (maxY + 1) * cellSize;

    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InteractiveViewer(
            panEnabled: true,
            boundaryMargin: const EdgeInsets.all(40),
            minScale: 0.1,
            maxScale: 2.0,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: gridWidth,
                height: gridHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: cells.values.map((cell) {
                    int cx = cell['x'];
                    int cy = cell['y'];
                    return Positioned(
                      left: cx * cellSize,
                      top: cy * cellSize,
                      child: LetterBox(
                        letter: cell['letter'],
                        isFound: cell['isFound'],
                        isHinted: cell['isHinted'] ?? false,
                        isSurpriseTile: provider.surpriseTileCoordinate == "${cx}_${cy}" && !provider.isSurpriseFound,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
