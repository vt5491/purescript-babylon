module Graphics.Babylon.Camera where

import Prelude (Unit)
import Effect (Effect)
import Graphics.Babylon.Utils (fpi, ffi, oneDeg)
import Graphics.Babylon.Math.Vector (Vector3)
import Base (Canvas)
foreign import data ArcRotateCamera :: Type

type Name = String
type Alpha = Number
type Beta = Number
type Radius = Number

createArcRotate :: Name -> Alpha -> Beta -> Radius -> Vector3 -> Effect ArcRotateCamera
createArcRotate = ffi ["name", "alpha", "beta", "radius", "target"]
  "(function () {return new BABYLON.ArcRotateCamera(name, alpha, beta, radius, target)})"

attachControl :: ArcRotateCamera -> Canvas -> Boolean -> Effect Unit
attachControl = ffi ["camera", "canvas", "bool"]
  """(function () {
         console.log("attachControl: camera=", camera, ", canvas=", canvas , ", bool=", bool);
         camera.attachControl(canvas, bool);
  })
  """
