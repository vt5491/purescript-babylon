module Graphics.Babylon.Material where

import Prelude (Unit)
import Effect (Effect)
import Graphics.Babylon.Utils (ffi)
-- import Base (Name)
import Base as Base
import Graphics.Babylon.Scene (Scene)

foreign import data StandardMaterial :: Type

class Material a

instance standardMaterial :: Material StandardMaterial

green :: Base.Color3
green = ffi [""] "BABYLON.Color3.Green"

createStandardMaterial :: Base.Name -> Scene -> Effect StandardMaterial
createStandardMaterial = ffi ["name", "scene"]
  "(function () {return new BABYLON.StandardMaterial(name, scene)})"

setDiffuseColor :: StandardMaterial -> Base.Color3 -> Effect Unit
setDiffuseColor = ffi ["mat", "color"]
  """ (function () {
         console.log("setDiffuseColor: mat=", mat, ", color=", color);
       })
  """
