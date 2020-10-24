-- Utils is refer to few, referenced by many.
module Graphics.Babylon.Utils where

import Prelude
import Data.Foreign.EasyFFI
import Effect (Effect)
import Math (pi)
-- import Graphics.Babylon.Material (StandardMaterial)

ffi :: forall a. Array String -> String -> a
ffi = unsafeForeignFunction
fpi :: forall a. Array String -> String -> a
fpi = unsafeForeignProcedure

oneDeg :: Number
oneDeg = pi / 180.0

-- Note: because debugger usually requires a passed parm of whatever it is you're
-- tring to examine, you must import that data structure.  However, most modules also
-- reference Utils, thus you get a circular reference.  So just code up your debugger
-- ad-hoc style in MainScene.
-- debuggerStrArray :: Array String
-- debuggerStrArray = ffi [""] "debugger"
-- debugger :: StandardMaterial -> Effect Unit
-- debugger = ffi ["x"]
--    """(function () {
--         debugger;
--       })
--    """
  -- // Resize
  --   window.addEventListener("resize", function () {
  --     engine.resize();
  --   });
-- resizeListener ::
-- getScene :: 
