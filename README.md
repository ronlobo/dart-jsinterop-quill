# dart-jsinterop-quill

This is an example workflow to run Dart with Webpack as a proof of concept as shown in this [talk](https://www.youtube.com/watch?v=oH6czEQwHdE&index=4).

It's been tested on the Mac only for now.  The following steps should be run in local clone directory of this repository.

- Install a recent Dart SDK.  You will need `1.21.0-dev.2.0` or later.  Set the `DART_SDK` environment variable to point to your installed SDK.  Ensure that the Dart `bin` (`$DART_SDK/bin`) is in your path.  This should include the `dart` and `dartdevc` executables.

- Install Dart dependencies.
```
pub get
```

- Install Node dependencies (for webpack, etc.).
```
npm install
```

- Do an initial build.
```
make all
```

- Start the Dart listener.
```
dart tool/watch.dart 
```

- In a separate terminal, start the webpack server in the same directory.  Add the `-d` option to enable source maps (though it slows the rebuild slightly).

```
./node_modules/.bin/webpack-dev-server --content-base=web --inline --watch --hot
```

- Navigate your browser(s) (recent Chrome, Firefox, or Safari 10) to `http://localhost:8080/webpack-dev-server/`

- Try an edit.  For example, edit `lib/captains_log.dart` and change the theme from "snow" to "bubble".  Your browsers should update immediately.


