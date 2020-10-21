module Graphics.Babylon.Mesh where

import Prelude
import Effect (Effect)
import Graphics.Babylon.Scene    as Scene
import Graphics.Babylon.Utils (fpi, ffi)
import Graphics.Babylon.Material as Material
import Graphics.Babylon.Math.Vector (Vector3)

foreign import data Mesh :: Type

createGround :: String -> forall opt. {|opt} -> Scene.Scene -> Effect Mesh
createGround = ffi ["name", "opt", "scene"]
  "(function () {return BABYLON.MeshBuilder.CreateGround(name, opt, scene)})"

createBox :: String -> forall opt. {|opt} -> Scene.Scene -> Effect Mesh
createBox = ffi ["name", "opt", "scene"]
  "(function () {return BABYLON.MeshBuilder.CreateBox(name, opt, scene)})"

setMaterial :: forall a. Material.Material a => Mesh -> a -> Effect Unit
setMaterial = ffi ["mesh", "mat"]
  """(function () {
        console.log("setMaterial: mesh=", mesh, ", mat=", mat);
        console.log("setMaterial: mesh.material=", mesh.material);
        mesh.material=mat;
    })
  """

setPosition :: Mesh -> Vector3 -> Effect Unit
setPosition = ffi ["mesh", "v3"] "(function () {return mesh.position = v3})"
