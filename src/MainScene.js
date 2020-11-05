// console.log("MainScene.js: hello, MainScene.dummy=", MainScene.dummy);
// PS.MainScene.dummyMainScene(1)
// console.log("MainScene.js: hello. MainScene.dummyMainScene=", PS.MainScene.dummyMainScene(1));
// const Main = require('../output/MainScene/index');
// import {dummy} from '../output/Game/index.js';

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

// exports.incClick = () => {
//   let curVal =  PS.MainScene.dummyMainScene(1);
//   let newVal = curVal + 1;
//   PS.MainScene.dummyMainScene = function (n) {return newVal;}
//   console.log("MainScene.js.incClick: curVal=", curVal , ", dummyMainScene=", PS.MainScene.dummyMainScene(1));
// }
