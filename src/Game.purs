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
import UtilsInternal as UtilsInternal

dummy :: Int
dummy = 7

-- hack to force exporting of ps functions to be called by js callbacks.
-- Has to be done at the "root" module level i.e. can't be done at the callback
-- module itself.
forceExportMeshLoadedPS :: Array Mesh.Mesh -> Effect Unit
forceExportMeshLoadedPS meshes = LoadModelScene.meshLoadedPS meshes

-- forceExportInitXR :: Common.WebXRExperienceHelper -> Effect Unit
-- forceExportInitXR xrHelper = Common.initXR xrHelper
-- forceExportInitXR :: Common.WebXRExperienceHelper -> UtilsInternal.Context -> Effect Unit
-- forceExportInitXR xrHelper ctx = Common.initXR xrHelper ctx
forceExportInitXR :: Common.WebXRExperienceHelper -> UtilsInternal.ContextObj -> Effect Unit
forceExportInitXR xrHelper ctxObj = Common.initXR xrHelper ctxObj

-- initXR :: WebXRExperienceHelper -> String
main :: Effect Unit
main = do
  let forceExport = meshLoadedPS
  log "hello Game top level 2"
  -- log $ "Game: LoadModelScene.dummy=" <> show LoadModelScene.dummy
  case Base.topLevelScene of
      "HelloWorldScene" -> do
                            log "calling HelloWorldScene"
                            -- scene <- runMainScene
                            ctx <- runMainScene
                            -- let my_uid = uid scene
                            -- let scene = ctx.scene
                            let scene = UtilsInternal.getContextScene ctx
                            let my_uid = uid scene
                            -- log $ "abc" <> my_uid
                            log $ "Game: scene.uid=" <> my_uid
                            -- log "Game: scene=" <> my_uid
                            -- HelloWorldScene.main scene
                            HelloWorldScene.main ctx
                            pure unit

      "LoadModelScene" -> do
                          log "calling LogModelScene"
                          -- scene <- runMainScene
                          ctx <- runMainScene
                          let scene = UtilsInternal.getContextScene ctx
                          let my_uid = uid scene
                          log $ "Game: scene.uid=" <> my_uid
                          log $ "show scene=" <> show scene
                          -- LoadModelScene.main scene
                          LoadModelScene.main ctx
                          pure unit
      "BasicXRScene" -> do
                          log "calling BasicXRScene"
                          -- scene <- runMainScene
                          ctx <- runMainScene
                          let r = show ctx
                          log $ "Game: r=" <> r
                          -- let scene = ctx.scene
                          -- let scene = (UtilsInternal.Context ctx.scene)
                          let scene = UtilsInternal.getContextScene ctx
                          let my_uid = uid scene
                          let camera = UtilsInternal.getContextCamera ctx
                          -- let my_uid = uid (ctx.scene)
                          log $ "Game: scene.uid=" <> my_uid <> ", camera=" <> show camera
                          -- log $ "show scene=" <> show ctx.scene
                          -- -- let r = BasicXRScene.main scene
                          -- let r = BasicXRScene.main ctx
                          -- r
                          BasicXRScene.main ctx
                          -- pure unit
      _           -> log "Unknown Scene specified"
  pure unit
