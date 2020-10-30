module Scenes.BasicXRScene where

import Prelude
import Effect (Effect)
import Effect.Aff (Aff, attempt, message)
import Effect.Console (log, logShow)
import Data.Semigroup ((<>))
import Data.Either (Either(..))
-- import Data.Either (Either)

import Graphics.Babylon.Scene    as Scene
import Graphics.Babylon.Mesh as Mesh
import Graphics.Babylon.Math.Vector as Vector
import Graphics.Babylon.Math.Quaternion as Quaternion
-- import Graphics.Babylon.Math.Quaternion (quaternion, Axis)
import Graphics.Babylon.Common as Common
import Base as Base
import Graphics.Babylon.Utils (ffi)

      -- ; (set! camera (bjs/ArcRotateCamera. "arc-cam" (/ js/Math.PI 2) (/ js/Math.PI 2) 2 (bjs/Vector3.Zero) scene))
      -- (-> (.createDefaultXRExperienceAsync scene (js-obj "floorMeshes" (array (.-ground env))))
      --     (p/then
      --      (fn [xr-default-exp]
      --        (set! xr-helper xr-default-exp)

-- createDefaultXRExperienceAsync :: Aff Unit
-- createXRExp :: Scene.Scene -> Aff Unit
-- createXRExp scene = do
--   let ground = Mesh.getMeshByName scene "ground"
--       r      = Mesh.printMesh ground
--   -- Scene.createDefaultXRExperienceAsync scene {floorMeshes: [ground]}
--   Common.createDefaultXRExperienceAsync scene {floorMeshes: [ground]}
  -- result <- attemptScene.createDefaultXRExperienceAsync $ copyFile "file1.txt" "file2.txt"

  -- res <-
  -- log $ "result=" <> show result
  -- pure unit

-- -- main :: Scene.Scene -> Effect Unit
-- main :: Scene.Scene -> Aff Unit
-- main scene = do
--   -- log $ "BasicXRScene.main: entered"
--   result <- attempt $ createXRExp scene
--   -- case result of
--   --   -- Left e -> log $ "There was a problem with createXRExp: " <> message e
--   --   Left e -> pure unit
--   --   -- Left e -> log $ message e
--   --   _ -> pure unit
--   -- let d = dummy
--     -- let ground =
--   pure unit

-- XRSetup ::
main :: Scene.Scene -> Effect Unit
main scene =
  -- let result = attempt $ createXRExp scene
  let ground = Mesh.getMeshByName scene "ground"
      r      = Mesh.printMesh ground
      result = Common.createXRExp scene {floorMeshes: [ground]} "myCB"
  in do
    log $ "BasicXRScene.main: entered" <> show 7
    -- result <- Common.createXRExp scene {floorMeshes: [ground]} "myCb"
    log  "xr enabled now"
  -- case result of
  --   Left e -> log $ "There was a problem with createXRExp: " <> message e
  -- --   Left e -> pure unit
  -- --   -- Left e -> log $ message e
  --   _ -> pure unit
  -- let d = dummy
    -- let ground =
    pure unit
