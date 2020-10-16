module Graphics.Babylon.Loader where

import Prelude (Unit)
import Effect (Effect)
import Graphics.Babylon.Utils (ffi, fpi)
-- import Foreign (Foreign)

doIt :: Int -> String
doIt = ffi [""] "BABYLON.Engine.Version"
