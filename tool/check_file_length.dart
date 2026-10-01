// Fails (exit code 1) when a hand-written Dart file exceeds the line limit.
//
// Usage: dart run tool/check_file_length.dart [maxLines]
import 'dart:io';

const _defaultMax = 100;
const _roots = ['lib', 'test'];
final _excluded = [
  RegExp(r'\.g\.dart$'),
  RegExp(r'\.freezed\.dart$'),
  RegExp(r'[\\/]l10n[\\/]generated[\\/]'),
];

void main(List<String> args) {
  final max = args.isEmpty ? _defaultMax : int.parse(args.first);
  final violations = <String>[];
  var scanned = 0;

  for (final root in _roots) {
    final dir = Directory(root);
    if (!dir.existsSync()) continue;
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (_excluded.any((r) => r.hasMatch(entity.path))) continue;
      scanned++;
      final lines = entity.readAsLinesSync().length;
      if (lines > max) violations.add('${entity.path}: $lines lines');
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('OK: $scanned files, all <= $max lines.');
    return;
  }
  stderr.writeln('Files over $max lines:');
  violations.forEach(stderr.writeln);
  exitCode = 1;
}
