module Game where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Control.Monad.State
import Control.Monad.State.Class
import Data.Foldable (traverse_)
-- import Examples.LoadModel (mainLoadModel)
-- import Examples.HelloWorld (mainHelloWorld)
-- import MainScene (runMainScene, dummyMainScene)
import MainScene (runMainScene, dummyMainScene) as MainScene
import Graphics.Babylon.Scene (uid)
import Base as Base
import Graphics.Babylon.Mesh as Mesh
-- import Graphics.Babylon.Common (WebXRExperienceHelper )
import Graphics.Babylon.Common as Common
import Graphics.Babylon.WebXR as WebXR
-- import Graphics.Babylon.ControllerXR as Controller
import ControllerXR as Controller
-- subscenes
import Scenes.HelloWorldScene as HelloWorldScene
import Scenes.LoadModelScene as LoadModelScene
import Scenes.LoadModelScene (meshLoadedPS)
import Scenes.BasicXRScene as BasicXRScene
import UtilsInternal as UtilsInternal

dummy :: Int
dummy = 7

-- incCounter :: Array Int -> State Int Unit
-- -- incCounter :: Int -> State Int Int
-- incCounter =  traverse_ \n -> modify \sum -> n + sum

sumArray :: Array Int -> State Int Unit
sumArray = traverse_ \n -> modify \sum -> sum + n

sumArrayExec = execState (do
              sumArray [1,2,3]) 0

-- sumIncCounter = execState (do
--               incCounter [2]
--               incCounter [1]) 0
-- counter :: State Int
-- counter = 0
-- hack to force exporting of ps functions to be called by js callbacks.
-- Has to be done at the "root" module level i.e. can't be done at the callback
-- module itself.
forceExportMeshLoadedPS :: Array Mesh.Mesh -> Effect Unit
forceExportMeshLoadedPS meshes = LoadModelScene.meshLoadedPS meshes

-- forceExportInitXR :: Common.WebXRExperienceHelper -> Effect Unit
-- forceExportInitXR xrHelper = Common.initXR xrHelper
-- forceExportInitXR :: Common.WebXRExperienceHelper -> UtilsInternal.Context -> Effect Unit
-- forceExportInitXR xrHelper ctx = Common.initXR xrHelper ctx
-- forceExportInitXR :: Common.WebXRExperienceHelper -> UtilsInternal.ContextObj -> Effect Unit
-- TODO: update to use WebXR.WebXRExperienceHelper
forceExportInitXR :: Common.WebXRExperienceHelper -> UtilsInternal.ContextObj -> Effect UtilsInternal.ContextObj
forceExportInitXR xrHelper ctxObj = Common.initXR xrHelper ctxObj

forceExportInitXR3 :: Common.WebXRExperienceHelper -> UtilsInternal.ContextObj -> UtilsInternal.ContextObj
forceExportInitXR3 xrHelper ctxObj = Common.initXR3 xrHelper ctxObj

forceExportDummyMainScene :: Int -> Int
forceExportDummyMainScene n = MainScene.dummyMainScene n

-- forceExportEnterXR :: Common.WebXRState -> Effect Unit
-- forceExportEnterXR s = Common.enterXR s
forceExportEnterXR :: WebXR.WebXRState -> Effect Unit
forceExportEnterXR s = WebXR.enterXR s
-- forceExportIncClick :: Effect Unit
-- forceExportIncClick = MainScene.incClick

forceInitXRCtrl :: Common.WebXRDefaultExperience -> Effect Unit
forceInitXRCtrl xrExp= Controller.initXRCtrl xrExp

-- forceCtrlAdded :: Effect Unit
-- forceCtrlAdded = Controller.ctrlAdded
forceCtrlAdded :: Controller.WebXRInput -> Effect Unit
forceCtrlAdded ctrl = Controller.ctrlAdded ctrl

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
                            ctx <- MainScene.runMainScene
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
                          ctx <- MainScene.runMainScene
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
                          -- ctx <- MainScene.runMainScene
                          ctx@(UtilsInternal.Context c) <- MainScene.runMainScene
                          let r = show ctx
                          log $ "Game: r=" <> r
                          log $ "Game: c.camera=" <> show c.camera
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
                          -- let r = execState (do
                          --   sumArray [1,2,3]) 0
                          let r = sumArrayExec
                          log $ "sumArrayExec=" <> show r
                          let r2 = Common.sumIncCounter
                          log $ "sumIncCounter=" <> show r2
                          pure unit
      _           -> log "Unknown Scene specified"
  pure unit
