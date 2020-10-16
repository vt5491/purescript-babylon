module Graphics.Babylon.Light where

import Prelude (Unit)
import Effect (Effect)
import Graphics.Babylon.Utils (fpi, ffi)
import Graphics.Babylon.Scene    as Scene
import Base (Name)
import Graphics.Babylon.Math.Vector (Vector3)

foreign import data HemisphericLight :: Type

createHemisphericLight :: Name -> Vector3 -> Scene.Scene -> Effect HemisphericLight
createHemisphericLight = ffi ["name", "pos", "scene"]
  "(function (){return new BABYLON.HemisphericLight(name, pos, scene)})"
