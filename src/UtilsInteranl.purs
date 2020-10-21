-- UtilsInternal is refer to many, referenced by few. (the opposite of Graphics.Babylon.Utils)
module UtilsInternal where

import Prelude
import Data.Foreign.EasyFFI
import Effect (Effect)
import Math (pi)
import Graphics.Babylon.Engine (Engine)
import Graphics.Babylon.Utils (ffi)

addResizeListener :: Engine -> Effect Unit
addResizeListener = ffi ["engine"]
  """(function () {
        window.addEventListener('resize', function () {
          console.log("now resizing, engine=", engine);
          engine.resize();
        })
      })
  """
