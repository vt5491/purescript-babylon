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
import UtilsInternal as UtilsInternal

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
-- main :: Scene.Scene -> Effect Unit
main :: UtilsInternal.Context -> Effect Unit
-- main scene =
main ctx =
  -- let result = attempt $ createXRExp scene
  let r1 = show ctx
      r2 = "abc"
      -- scene = (ctx.scene)
      scene = UtilsInternal.getContextScene ctx
      camera = UtilsInternal.getContextCamera ctx
      ground = Mesh.getMeshByName scene  "ground"
      r      = Mesh.printMesh ground
      -- result = Common.createXRExp scene {floorMeshes: [ground]} "myCB"
      -- result = Common.createXRExp ctx {floorMeshes: [ground]} "myCB"
      result = Common.createXRExp (UtilsInternal.contextToObj ctx) {floorMeshes: [ground]} "myCB"
  in do
    log $ "BasicXRScene:r2=" <> r2
    log $ "BasicXRScene:r1=" <> r1
  --   log $ "BasicXRScene.main: entered" <> show 7
  --   -- result <- Common.createXRExp scene {floorMeshes: [ground]} "myCb"
    log  "xr enabled now"
    pure unit
