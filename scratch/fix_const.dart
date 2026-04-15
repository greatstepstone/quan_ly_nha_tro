import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  final blockPats = [
    RegExp(r'const\s+(Icon\()'),
    RegExp(r'const\s+(Divider\()'),
    RegExp(r'const\s+(BoxDecoration\()'),
    RegExp(r'const\s+(BorderSide\()'),
    RegExp(r'const\s+(SnackBar\()'),
    RegExp(r'const\s+(InputDecoration\()'),
    RegExp(r'const\s+(SizedBox\()'),
    RegExp(r'const\s+(EdgeInsets\()'),
    RegExp(r'const\s+(Padding\()'),
    RegExp(r'const\s+(TextStyle\()'),
  ];

  for (final file in files) {
    var content = file.readAsStringSync();
    var newContent = content;
    
    for (var pat in blockPats) {
      newContent = newContent.replaceAllMapped(pat, (m) => m.group(1)!);
    }
    
    if (content != newContent) {
      file.writeAsStringSync(newContent);
      print('Fixed ${file.path}');
    }
  }
}
