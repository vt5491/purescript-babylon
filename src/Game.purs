module Game where

import Prelude

import Effect (Effect)
import Effect.Console (log)
-- import Examples.LoadModel (mainLoadModel)
-- import Examples.HelloWorld (mainHelloWorld)
import MainScene (runMainScene)
import Graphics.Babylon.Scene (uid)
import Base as Base
import Graphics.Babylon.Mesh as Mesh
-- import Graphics.Babylon.Common (WebXRExperienceHelper )
import Graphics.Babylon.Common as Common
-- subscenes
import Scenes.HelloWorldScene as HelloWorldScene
import Scenes.LoadModelScene as LoadModelScene
import Scenes.LoadModelScene (meshLoadedPS)
import Scenes.BasicXRScene as BasicXRScene

dummy :: Int
dummy = 7

-- hack to force exporting of ps functions to be called by js callbacks.
-- Has to be done at the "root" module level i.e. can't be done at the callback
-- module itself.
forceExportMeshLoadedPS :: Array Mesh.Mesh -> Effect Unit
forceExportMeshLoadedPS meshes = LoadModelScene.meshLoadedPS meshes

forceExportInitXR :: Common.WebXRExperienceHelper -> Effect Unit
-- forceExportInitXR :: Common.WebXRDefaultExperience -> Effect Unit
forceExportInitXR xrHelper = Common.initXR xrHelper

-- initXR :: WebXRExperienceHelper -> String
main :: Effect Unit
main = do
  let forceExport = meshLoadedPS
  log "hello Game top level 2"
  -- log $ "Game: LoadModelScene.dummy=" <> show LoadModelScene.dummy
  case Base.topLevelScene of
      "HelloWorldScene" -> do
                        log "calling HelloWorldScene"
                        scene <- runMainScene
                        let my_uid = uid scene
                        -- log $ "abc" <> my_uid
                        log $ "Game: scene.uid=" <> my_uid
                        -- log "Game: scene=" <> my_uid
                        HelloWorldScene.main scene
                        pure unit

      "LoadModelScene" -> do
                        log "calling LogModelScene"
                        scene <- runMainScene
                        let my_uid = uid scene
                        log $ "Game: scene.uid=" <> my_uid
                        log $ "show scene=" <> show scene
                        LoadModelScene.main scene
                        pure unit
      -- "LoadModelScene" -> log "calling LoadModelScene"
      "BasicXRScene" -> do
                        log "calling BasicXRScene"
                        scene <- runMainScene
                        let my_uid = uid scene
                        log $ "Game: scene.uid=" <> my_uid
                        log $ "show scene=" <> show scene
                        let r = BasicXRScene.main scene
                        pure unit
      _           -> log "Unknown Scene specified"
  -- mainLoadModel
  -- mainHelloWorld
  -- runMainScene
  pure unit
