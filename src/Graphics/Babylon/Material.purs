module Graphics.Babylon.Material where

import Prelude
-- import Prelude (Unit)
import Effect (Effect)
import Graphics.Babylon.Utils (ffi, fpi)
-- import Base (Name)
import Base as Base
import Graphics.Babylon.Scene (Scene)

foreign import data StandardMaterial :: Type

class Material a

instance standardMaterial :: Material StandardMaterial

-- Note: you need a dummy int in order to "force the function"
-- (make it evaluate and return a value)
green :: Int -> Base.Color3
-- green = ffi [""] "BABYLON.Color3.Green"
green = ffi ["n"]
-- -- """(() => {return BABYLON.Color3.Green})()"""
  """(function () {
         var c = BABYLON.Color3.Green();
         //debugger;
         console.log("c=", c);
         return c;
  })()
  """

purple :: Int -> Base.Color3
purple = ffi ["n"]
  """(function () {
         var c = BABYLON.Color3.Purple();
         return c;
  })()
  """
-- purple ::  Base.Color3
-- purple = ffi [""]
--   """(function () {
--          var c = BABYLON.Color3.Purple();
--          return c;
--   })
--   """
-- green2 :: Int -> Int
-- green2 n = n + 1
-- green2 :: {r :: Int, g :: Int, b :: Int}
green2 :: Base.Color3
-- green = ffi [""] "BABYLON.Color3.Green"
-- green2 = {r: 1, g: 2, b: 3}
green2 = ffi ["n"]
-- """(() => {return BABYLON.Color3.Green})()"""
  """(function () {
         var c = BABYLON.Color3.Green();
         console.log("c=", c);
         return c;
         //return {r: 1, g: 2, b: 3};
  })()
  """

green3 :: Effect Base.Color3
green3 = ffi [""] "BABYLON.Color3.Green();"
-- """(() => {return BABYLON.Color3.Green})()"""
  -- """(function () {
  --        var c = BABYLON.Color3.Green();
  --        console.log("c=", c);
  --        return c;
  --        //return {r: 1, g: 2, b: 3};
  -- })()
  -- """
createStandardMaterial :: Base.Name -> Scene -> Effect StandardMaterial
createStandardMaterial = ffi ["name", "scene"]
  "(function () {return new BABYLON.StandardMaterial(name, scene)})"

setDiffuseColor :: StandardMaterial -> Base.Color3 -> Effect Unit
setDiffuseColor = ffi ["mat", "color"]
  """ (function () {
         console.log("setDiffuseColor: mat=", mat, ", color=", color);
         mat.diffuseColor = color;
         console.log("setDiffuseColor: post: mat=", mat, ", color=", color);
       })
  """
