import 'dart:io';

void main() {
  File f = File('lib/models/level_model.dart');
  String c = f.readAsStringSync();
  
  // Replace literal '\n' string with actual newline character
  c = c.replaceAll(r'\n', '\\n');
  c = c.replaceAll(r'\r', '\\r');
  
  f.writeAsStringSync(c);
  print('Fixed newlines correctly.');
}
