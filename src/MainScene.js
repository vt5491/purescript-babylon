exports.foo = function(x) {
  return function (y) {
    return function (z) {
      return (x + y) * z; // <- the actually interesting part!
    };
  };
};
// green3 :: Base.Color3
// green3 = ffi [""] "BABYLON.Color3.Green();"
exports.green4 = function() {
  console.log("hi from green4");
  return BABYLON.Color3.Green();
}

exports.green5 = function() {
  console.log("hi from green5");
  return BABYLON.Color3.Green();
}
