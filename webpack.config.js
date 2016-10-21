var path = require('path');



module.exports = {
  entry: "./gen/ENTRY.js",
  output: {
    path: __dirname,
      filename: "main.js"
  },
  resolve: {
    root: [
      '/Users/vsm/dart/sdk/pkg/dev_compiler/lib/js/common',
      path.join(__dirname, 'gen')
    ]
  },
  module: {
    preLoaders: [
      {
        test: /\.js$/,
        loader: "source-map"
      }
    ]
  }
}
