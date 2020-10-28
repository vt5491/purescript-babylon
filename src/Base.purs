module Base where

import Prelude

import Effect (Effect)
import Graphics.Babylon.Utils (ffi, fpi)
import Math (pi)
-- some common BJS types that don't have their own modules yet.
foreign import data Color3 :: Type
foreign import data Object :: Type
foreign import data Canvas :: Type

-- tmp_f :: String
tmp_f :: Int -> Int
-- tmp_f = ffi [""] "(function() {return 'js: c.r='})()"
tmp_f = ffi ["n"] "(function() {return 7})()"
-- tmp_f = "buck"

tmp_f_2 :: Int -> String
tmp_f_2 = ffi ["n"] "(function() {return 'hey'})()"

tmp_f_3 :: Int -> Color3 -> String
-- tmp_f_3 = ffi ["n", "c"] "(function() {return 'hey, color=', c})()"
tmp_f_3 = ffi ["n", "c"]
  """(function()
      {  var c2 = c.r;
         //debugger;
         return 'hey, color=' + c;
     })()
  """

oneDeg :: Number
oneDeg = pi / 180.0

instance showColor3 :: Show Color3 where
  -- show c = "Color3 = " <> c
  -- let m = "abc"
  -- show c = ffi ["c"] "(() => {return 'js: c.r='})()"
  -- in show c = m
  show c = n
    -- where m = "abc"
    -- where n = "def"
    -- where m = ffi ["c"] "(() => {return 'js: c.r='})()"
    -- where m = ffi [""] "(function() {return 'js: c.r='})()"
    -- where m = ffi [""] "(function() {return 7})()"
    where m = tmp_f_3 1 c
          n = m
-- Some common BJS type synonyms (for parameters).
type Name = String
type FFICallback = String

printObj :: Object -> Effect Unit
printObj = ffi ["o"] "console.log('obj=', obj)"

printArray :: forall a. Array a -> Effect Unit
printArray = ffi ["array"]
  """( () => {
      console.log('array=', array);
      array[0]._scaling = new BABYLON.Vector3(0.1, 0.1, 0.1);
  })()
  """

-- Define the top level scene, to be called after MainScene
-- HelloWorldScene: a basic cube on a plane scene
-- LoadModelScene: load in a gltf model.  Good illustration of using callbacks.
topLevelScene :: String
-- topLevelScene = "HelloWorldScene"
topLevelScene = "LoadModelScene"
