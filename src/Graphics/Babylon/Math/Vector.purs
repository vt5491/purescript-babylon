module Graphics.Babylon.Math.Vector where

import Prelude (class Show)
import Graphics.Babylon.Utils (ffi)

foreign import data Vector2 :: Type
foreign import data Vector3 :: Type

createVector3 :: Number -> Number -> Number -> Vector3
createVector3 = ffi ["x", "y", "z"] "(function () {return new BABYLON.Vector3(x, y, z)})()"
