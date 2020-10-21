module Graphics.Babylon.Engine where

import Prelude
import Effect (Effect)
import Graphics.Babylon.Utils (ffi)
import Base (FFICallback, Canvas)

foreign import data Engine :: Type

runRenderLoop :: Engine -> FFICallback -> Effect Unit
runRenderLoop = ffi ["engine", "renderFn"]
  "(function () {return engine.runRenderLoop(renderFn)})"

createEngine :: Canvas -> Effect Engine
-- Note: this is the syntax to do prints.  You need a func in parens w/o
-- the iife parens at the end.
-- Note2: if the result is a do-level effect (not a let) then do it this way.
-- If it's a let, then put in the iife parens.
-- Note 3: if it's a new, I think you need to expcility specify "return"
createEngine = ffi ["canvas"]
    """ (function() {
            console.log("hi from createEngine, canvas=", canvas);
            var e = new BABYLON.Engine(canvas, true);
            console.log("hi from createEngine, e=", e);
            return e;
        })
    """
printEngine :: Engine -> Effect Unit
printEngine = ffi ["engine"] "console.log('printEngine: engine=', engine)"

getDescription :: Engine -> String
-- for lets , you need the iife parens
getDescription = ffi ["eng"]
    """(function() {
          console.log("getDescription: eng._fps=", eng._fps);
          //debugger;
          return "ello";
        })()
    """

instance showEngine :: Show Engine where
  show e = "engine.desc = " <> getDescription e
