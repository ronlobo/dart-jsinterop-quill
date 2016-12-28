all: gen/main.js

gen/js.js: packages/js/js.dart
	dartdevc --modules=common -p packages/ -o gen/js.js package:js/js.dart

gen/js.sum: gen/js.js

gen/func.js: packages/func/func.dart
	dartdevc --modules=common -p packages/ -o gen/func.js package:func/func.dart

gen/func.sum: gen/func.js

gen/captains_log.js: lib/captains_log.dart lib/quill.dart gen/js.sum gen/func.sum
	dartdevc --modules=common -p packages/ -o gen/captains_log.js -s gen/js.sum -s gen/func.sum package:captains_log/captains_log.dart package:captains_log/quill.dart

gen/captains_log.sum: gen/captains_log.js

gen/main.js: web/main.dart gen/js.sum gen/func.sum gen/captains_log.sum
	dartdevc --modules=common -p packages/ -o gen/main.js -s gen/captains_log.sum -s gen/js.sum -s gen/func.sum web/main.dart

clean:
	cd gen && ls | grep -v ENTRY.js | xargs rm
