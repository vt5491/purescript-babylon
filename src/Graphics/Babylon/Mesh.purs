module Graphics.Babylon.Mesh where

import Prelude
import Effect (Effect)
import Graphics.Babylon.Scene    as Scene
import Graphics.Babylon.Utils (fpi, ffi)
import Graphics.Babylon.Material as Material
import Graphics.Babylon.Math.Vector (Vector3)

foreign import data Mesh :: Type

instance showMesh :: Show Mesh where
  show = ffi ["m"] "(function () {return 'uid=' + m.uid + ',scaling=' + m.scaling})()"

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

setScale :: Mesh -> Number -> Number -> Number -> Effect Unit
setScale = ffi ["mesh", "x", "y", "z"]
  """(function () {
       console.log("Mesh.setScale: mesh.scaling pre=", mesh._scaling);
       let scale = new BABYLON.Vector3(x, y, z);
       //mesh.scaling = scale;
       mesh._scaling = scale;
       console.log("Mesh.setScale: mesh.scaling post=", mesh._scaling);
  })()"""

setScale2 :: Mesh -> Effect Unit
setScale2 = ffi ["mesh"]
  """(() => {
       console.log("Mesh.setScale2: mesh.scaling pre=", mesh._scaling);
  })()
  """

getName :: Mesh -> String
getName = ffi ["m"]
  """(() => {
              console.log("Mesh.getName: mesh=", m);
              //console.log("Mesh.getName: mesh.name=", m.name);
              return m.name;
  })()
  """

getName2 :: Mesh -> Effect String
getName2 = ffi ["m"]
  """(() => {
              console.log("Mesh.getName2: mesh=", m);
              //console.log("Mesh.getName: mesh.name=", m.name);
              return m.name;
  })()
  """
