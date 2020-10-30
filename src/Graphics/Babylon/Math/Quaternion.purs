module Graphics.Babylon.Math.Quaternion where

import Prelude
import Graphics.Babylon.Utils (ffi)
import Graphics.Babylon.Math.Vector (Vector3)
import Base (oneDeg)

foreign import data Quaternion :: Type

data Axis = X | Y | Z
type RotDeg = Number

instance showQuaternion :: Show Quaternion where
  show = ffi ["q"] "(() => { return `x=${q.x},y=${q.y},z=${q.z},w=${q.w}`})()"

createQuaternion :: Number -> Number -> Number -> Number -> Quaternion
createQuaternion = ffi ["x", "y", "z", "w"]
  "(function () {return new BABYLON.Quaternion(x, y, z, w)})()"

-- y-quat90 (.normalize (bjs/Quaternion.RotationAxis bjs/Axis.Y (* base/ONE-DEG 90)))]
-- Create a quaternion in a more practical way.
quaternion :: Axis -> RotDeg -> Quaternion
-- quaternion :: Char -> RotDeg -> Quaternion
-- quaternion :: Char -> RotDeg -> Int -> Quaternion
-- quaternion X rot = ffi [""]
-- quaternion 'X' rot = ffi ["rot"]
-- quaternion 'X' = ffi ["rot"]
quaternion X = ffi ["rot"]
  """(() => {
        return (new BABYLON.Quaternion.RotationAxis(BABYLON.Axis.X, rot)).normalize();
  })()"""
-- quaternion Y rot = ffi [""]
-- quaternion 'Y' rot = ffi ["rot"]
-- quaternion 'Y' = ffi ["rot"]
quaternion Y = ffi ["rot"]
  """(() => {
        console.log("quaterion.y: rot mofo=", rot);
        return (new BABYLON.Quaternion.RotationAxis(BABYLON.Axis.Y, rot)).normalize();
  })()"""
-- quaternion Z rot = ffi [""]
-- quaternion 'Z' rot = ffi ["rot"]
-- quaternion 'Z' = ffi ["rot"]
quaternion Z = ffi ["rot"]
  """(() => {
        console.log("quaterion.z: rot mofo=", rot);
        return (new BABYLON.Quaternion.RotationAxis(BABYLON.Axis.Z, rot)).normalize();
  })()"""
-- quaternion _ rot = ffi ["rot"]
-- quaternion _ = ffi ["rot"]
--   """(() => {
--         console.log("quaterion.default: rot=", rot);
--         return (new BABYLON.Quaternion.RotationAxis(BABYLON.Axis.X, rot)).normalize();
--   })()"""

-- axisX :: Vector3
axisX = ffi ["(() => {return BABYLON.Axis.X;})()"]
axisY = ffi ["(() => {return BABYLON.Axis.Y;})()"]
