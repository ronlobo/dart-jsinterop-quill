import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bazel_worker/bazel_worker.dart';
// TODO(jakemac): Remove once this is a part of the testing library.
import 'package:bazel_worker/src/async_message_grouper.dart';
import 'package:bazel_worker/testing.dart';

var build = {
  'gen/js.js': ['package:js/js.dart'],
  'gen/func.js': ['package:func/func.dart'],
  'gen/captains_log.js': ['lib/captains_log.dart', 'lib/quill.dart', 'gen/js.sum', 'gen/func.sum'],
  'gen/main.js': ['web/main.dart', 'gen/js.sum', 'gen/func.sum', 'gen/captains_log.sum']
};

List<String> compileCommand(String target, List<String> deps) {
  var command = ['--modules=common', '-p', 'packages/', '-o', target];
  deps.where((str) => str.endsWith('.sum')).forEach((str) {
    command.add('-s');
    command.add(str);
  });
  deps.where((str) => str.endsWith('.dart')).forEach((str) {
    command.add(str);
  });
  return command;
}

void registerWatch(String target, List<String> deps) {
  var command = compileCommand(target, deps);
  if (!(new File(target).existsSync())) run(command, true);
  deps.forEach((f) {
    var file = new File(f);
    file.watch().listen((e) => run(command));
  });
}

void processBuild(Map<String, List<String>> map) {
  map.forEach(registerWatch);
}

void run(List<String> command, [bool sync = false]) {
  print('dartdevc ${command.join(" ")}');
  if (sync) {
    Process.runSync('dartdevc', command);
  } else {
    Process.run('dartdevc', command);
  }
}

void main() {
  processBuild(build);
}
