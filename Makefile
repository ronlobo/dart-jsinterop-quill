
gen/js.js: packages/js/js.dart
	dart /Users/vsm/dart/sdk/pkg/dev_compiler/bin/dartdevc.dart --modules=common -p packages/ -o gen/js.js package:js/js.dart

gen/js.sum: gen/js.js

gen/func.js: packages/func/func.dart
	dart /Users/vsm/dart/sdk/pkg/dev_compiler/bin/dartdevc.dart --modules=common -p packages/ -o gen/func.js package:func/func.dart

gen/func.sum: gen/func.js

gen/captains_log.js gen/captains_log.sum: lib/captains_log.dart lib/quill.dart gen/js.sum gen/func.sum
	dart /Users/vsm/dart/sdk/pkg/dev_compiler/bin/dartdevc.dart --modules=common -p packages/ -o gen/captains_log.js -s gen/js.sum -s gen/func.sum package:captains_log/captains_log.dart package:captains_log/quill.dart

gen/main.js: web/main.dart gen/js.sum gen/func.sum gen/captains_log.sum
	dart /Users/vsm/dart/sdk/pkg/dev_compiler/bin/dartdevc.dart --modules=common -p packages/ -o gen/main.js -s gen/captains_log.sum -s gen/js.sum -s gen/func.sum /Users/vsm/git/dart-jsinterop-quill/web/main.dart

all: gen/main.js
