// to load this module (dummy.mjs) specify this in your html
// <script type="module" src="http://localhost:8000/modules/dummy_module.mjs"></script>
// then start up the 'cors_server.py' using pyton2 e.g "python" not "py"
// import 'babylonjs-loaders';
// const Game = require('../../output/Game/index.js');
// console.log('js: Game.dummy=', Game.dummy());

'use strict';
// console.log("hello from dummy_module.mjs");
// import {dummy} from '../../output/Game/index.js';
// import {dummy} from './output/Game/index.js';
// const Game = require('../output/Game/index.js');
// console.log('js: Game.dummy=', Game.dummy());
// console.log('js: Game.dummy=', dummy());
// console.log('js: Game.dummy=', PS.Game.dummy);

export const name = 'square';

// exports.dummy_module_mjs_7 = function () {
//   return 7;
// }
export function dummy_module_mjs_7 () {
  return 7;
}
