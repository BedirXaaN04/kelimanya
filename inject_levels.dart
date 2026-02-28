// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures
import 'dart:io';

void main() {
  File modelFile = File('lib/models/level_model.dart');
  File levelsFile = File('generated_levels.txt');

  List<String> lines = modelFile.readAsLinesSync();
  String newLevels = levelsFile.readAsStringSync();

  int startIdx = -1;
  int endIdx = -1;

  for (int i = 0; i < lines.length; i++) {
    if (lines[i].contains('// Level 1') && startIdx == -1) {
      startIdx = i;
    }
    if (lines[i].contains('// Level 21') && endIdx == -1) {
      endIdx = i;
    }
  }

  if (startIdx != -1 && endIdx != -1) {
    List<String> before = lines.sublist(0, startIdx);
    List<String> after = lines.sublist(endIdx);
    
    String finalContent = before.join('\\n') + '\\n' + newLevels + '\\n' + after.join('\\n') + '\\n';
    modelFile.writeAsStringSync(finalContent);
    print('Injection successful.');
  } else {
    print('Could not find boundaries. start: \$startIdx, end: \$endIdx');
  }
}
