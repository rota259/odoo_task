import 'dart:io';

import 'package:hive_ce/hive.dart';

/// Real Hive boxes in a throwaway directory (pure Dart, no Flutter).
class TestHive {
  late Directory _dir;
  var _counter = 0;

  Future<void> setUp() async {
    _dir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(_dir.path);
  }

  Future<Box<Map<dynamic, dynamic>>> mapBox([String prefix = 'box']) =>
      Hive.openBox<Map<dynamic, dynamic>>('${prefix}_${_counter++}');

  Future<Box<String>> stringBox([String prefix = 'strings']) =>
      Hive.openBox<String>('${prefix}_${_counter++}');

  Future<void> tearDown() async {
    await Hive.close();
    try {
      await _dir.delete(recursive: true);
    } on FileSystemException {
      // Windows may still hold a lock briefly; temp dirs are cleaned later.
    }
  }
}
