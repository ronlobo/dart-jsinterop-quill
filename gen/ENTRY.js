var entry = require("./main");
if (module && module.hot) {
  console.log('HOT RELOADING SETUP');
  module.hot.accept("./main", function (err) {
    if (!err.message) {
      console.log('HOT RELOADING');
      entry.web__main.clear();
      entry = require("./main");
      entry.web__main.main();
    } else {
      console.log('HOT RELOADING ERROR');
      console.log(err.message);
    }
  });
}
entry.web__main.main();
