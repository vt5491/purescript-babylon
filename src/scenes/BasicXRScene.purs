module Scenes.BasicXRScene where

import Prelude
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Aff (Aff, attempt, message, launchAff, launchAff_)
-- import Effect.Console (log)
import Effect.Class.Console (log, logShow)
import Data.Semigroup ((<>))
import Data.Either (Either(..))
-- import Data.Either (Either)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (readTextFile, writeTextFile)
import Node.Path (FilePath)
-- import Control.Monad.Aff.Console (log)
import Affjax as AX
import Affjax.ResponseFormat as ResponseFormat

import Graphics.Babylon.Engine   as Engine
import Graphics.Babylon.Scene    as Scene
import Graphics.Babylon.Mesh as Mesh
import Graphics.Babylon.Math.Vector as Vector
import Graphics.Babylon.Math.Quaternion as Quaternion
-- import Graphics.Babylon.Math.Quaternion (quaternion, Axis)
import Graphics.Babylon.Common as Common
import Graphics.Babylon.WebXR as WebXR
import ControllerXR as ControllerXR
import Base as Base
import Graphics.Babylon.Utils (ffi)
import UtilsInternal as UtilsInternal

import GlobalTypes (ContextObj)
import Graphics.Babylon.Mesh (Mesh)
import Graphics.Babylon.Utils (ffi, fpi)

getUrl :: String -> Aff String
-- getUrl :: String -> Aff Unit
getUrl url = do
  result <- AX.get ResponseFormat.string url
  -- pure unit
  pure $ case result of
    Left err -> "GET /api response failed to decode: " <> AX.printError err
    Right response -> response.body

 -- launchAff_ do
 --   str <- getUrl "https://reqres.in/api/users/1"
 --   log $ str
 --   pure unit
-- affAjax = launchAff do
--   -- response <- Ajax.get "http://foo.bar"
--   response <- AX.get "http://foo.bar"
--   log response.body

      -- ; (set! camera (bjs/ArcRotateCamera. "arc-cam" (/ js/Math.PI 2) (/ js/Math.PI 2) 2 (bjs/Vector3.Zero) scene))
      -- (-> (.createDefaultXRExperienceAsync scene (js-obj "floorMeshes" (array (.-ground env))))
      --     (p/then
      --      (fn [xr-default-exp]
      --        (set! xr-helper xr-default-exp)
readFile :: FilePath -> Aff Unit
-- readFile :: FilePath -> Aff String
readFile file1 = do
  my_data <- readTextFile UTF8 file1
  -- readTextFile UTF8 file1
  pure unit
  -- Aff unit
  -- pure my_data

affRead :: Aff Unit
-- affRead :: Aff String
affRead = do
  result <- attempt $ readFile "dummy.txt"
  -- pure result
  case result of
    Left e -> log $ "There was a problem with readFile: " <> message e
    _ -> pure unit

copyFile :: FilePath -> FilePath -> Aff Unit
copyFile file1 file2 = do
  my_data <- readTextFile UTF8 file1
  writeTextFile UTF8 file2 my_data

copyFileAff :: Aff Unit
copyFileAff = do
  result <- attempt $ copyFile "dummy1.txt" "dummy2.txt"
  logShow $ "hi from copyFileAff"
  case result of
    Left e -> log $ "There was a problem with copyFile: " <> message e
    _ -> pure unit

-- Note: this needs to be here at the user level, not the backend level, since it reference GameContext
-- and thus is app level.  Putting it in "system" code generates circular dependencies.
createXRExp :: ContextObj -> {floorMeshes :: Array Mesh} -> String -> ContextObj
-- createXRExp = fpi ["ctxObj", "opts", "cb", ""]
createXRExp = fpi ["ctxObj", "opts", "cb"]
  """
      let scene = ctxObj.scene;
      let camera = ctxObj.camera;
      console.log("WebXR.createXRExp: scene=", scene, ",opts=", opts);
      //result = await asyncHandler(scene, camera, opts);
      // console.log("createXRExp5: result=", result);
      scene.createDefaultXRExperienceAsync(opts)
        .then((XRExp) => {
          console.log("asyncHandler2 loaded XRexp=", XRExp);
          console.log("asyncHandler2 loaded ctxObj=", ctxObj);
          console.log("WebXR.CreateXRExp: baseExperience=", XRExp.baseExperience );
          let baseExperience = XRExp.baseExperience;
          if (! BABYLON.VT) {
            BABYLON.VT = {};
          }
          BABYLON.VT.active_camera = baseExperience.camera;
          //baseExperience.onStateChangedObservable = PS["Graphics.Babylon.Common"].enterXR(1);
          //baseExperience.onStateChangedObservable.add = () => {console.log("hi from cb")};
          // baseExperience.onStateChangedObservable.add(function (x) {console.log("hi from cb, x=", x)});
          // baseExperience.onStateChangedObservable.add((x) => {console.log("hi from cb, x=", x)});
          // baseExperience.onStateChangedObservable.add((x) => {console.log("hi from cb")});
          //(PS["Graphics.Babylon.ControllerXR"].initXRCtrl)(XRExp)();
          (PS["ControllerXR"].initXRCtrl)(XRExp)();
          baseExperience.onStateChangedObservable.add((webXRState) => {
            console.log("hi from cb");
            //vt-x(PS["Graphics.Babylon.Common"].enterXR)(webXRState)();
            (PS["Graphics.Babylon.WebXR"].enterXR)(webXRState)();
          });
            // (PS["Graphics.Babylon.Common"].enterXR)(1);});
          // baseExperience.onStateChangedObservable.add(() => {return 7});
          // baseExperience.onInitialXRPoseSetObservable.add(() => {return 7})
          console.log("added observer");

          // resolve({scene: scene, camera: camera, abc: 7});
        })
  """
-- -- createDefaultXRExperienceAsync :: Aff Unit
-- -- createXRExpAsync :: Scene.Scene -> Aff Unit
-- createXRExpAsync :: Scene.Scene -> Aff String
-- createXRExpAsync scene = do
--   let ground = Mesh.getMeshByName scene "ground"
--       r      = Mesh.printMesh ground
--   -- Scene.createDefaultXRExperienceAsync scene {floorMeshes: [ground]}
--   result <- Common.createDefaultXRExperienceAsync scene {floorMeshes: [ground]}
--   -- result <- attempt Scene.createDefaultXRExperienceAsync $ copyFile "file1.txt" "file2.txt"
--   -- res <-
--   -- log $ "result=" <> show result
--   let msg = "abc"
--   pure msg

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
-- renderFn :: Scene.Scene -> Effect Unit
renderFn :: Scene.Scene -> String
renderFn =
  -- let ctrlTick = ControllerXR.tick 1
  -- in
  do
    ffi ["scene"]
      """(function () {
            //console.log("now in renderFn");
            scene.render();
            PS.ControllerXR.tick();
          })
      """

-- https://raw.githubusercontent.com/vt5491/purescript-babylon/main/LICENSE
-- XRSetup ::
-- main :: Scene.Scene -> Effect Unit
main :: UtilsInternal.Context -> Effect Unit
-- main scene =
main ctx =
  -- let result = attempt $ createXRExp scene
  let r1 = show ctx
      -- r3 = UtilsInternal.printCtx ctx
      r2 = "abc"
      -- scene = (ctx.scene)
      engine = UtilsInternal.getContextEngine ctx
      scene = UtilsInternal.getContextScene ctx
      camera = UtilsInternal.getContextCamera ctx
      camera1 = show camera
      ground = Mesh.getMeshByName scene  "ground"
      r      = Mesh.printMesh ground
      -- affResult = copyFileAff
      -- result = Common.createXRExp scene {floorMeshes: [ground]} "myCB"
      -- result = Common.createXRExp ctx {floorMeshes: [ground]} "myCB"
      -- newCtxObj = Common.createXRExp (UtilsInternal.contextToObj ctx) {floorMeshes: [ground]} "myCB"
      -- newCtxObj3 = Common.createXRExp3 (UtilsInternal.contextToObj ctx) {floorMeshes: [ground]} "myCB"
      -- ctx = UtilsInternal.contextObjToContext $ newCtxObj3
       -- fred {id = 70}
      -- newCtxObj3 = Common.createXRExp3 (UtilsInternal.contextToObj ctx)  {floorMeshes: [ground]}  "myCB"
  in do
    -- launchAff_ $ copyFileAff
    -- launchAff_ $ affRead
    -- str <- launchAff_ getUrl
    -- following works
    -- launchAff_ do
      -- works..read an url asynchronously
      -- str <- getUrl "https://reqres.in/api/users/1"
      -- log str
    -- launchAff_ do
    --   str <- createXRExpAsync scene
    --   -- createXRExpAsync scene
    --   log $ "lanuchAff= " <> str
      -- liftEffect $ pure unit
      -- str <- getUrl
      -- liftEffect $ log str
    -- let str = liftEffect $ launchAff_ getUrl
    -- log str
    -- let affResult = copyFileAff
    -- log $ "affResult=" <> show affResult
    -- let rInc = Common.sumIncCounter
    -- log $ "BasicXRScene: sumIncCounter=" <> show rInc
    UtilsInternal.printCtx ctx
    log $ "BasicXRScene.main: about to call createXRExp5"
    -- newCtxObj <- Common.createXRExp (UtilsInternal.contextToObj ctx)  {floorMeshes: [ground]}  "myCB"
    -- let newCtxObj3 = Common.createXRExp3 (UtilsInternal.contextToObj ctx)  {floorMeshes: [ground]}  "myCB"
    -- let newCtxObj4 = Common.createXRExp4 (UtilsInternal.contextToObj ctx)  {floorMeshes: [ground]}  "myCB"
    --vt-xlet newCtxObj5 = Common.createXRExp5 (UtilsInternal.contextToObj ctx)  {floorMeshes: [ground]}  "myCB"
    -- let newCtxObj5 = WebXR.createXRExp (UtilsInternal.contextToObj ctx)  {floorMeshes: [ground]}  "myCB"
    let opts = {floorMeshes: [ground]} :: WebXR.WebXRDefaultExperienceOptions
    --vt-xlet newCtxObj5 = createXRExp (UtilsInternal.contextToObj ctx)  {floorMeshes: [ground]}  "myCB"
    -- let newCtx3 = UtilsInternal.contextObjToContext $ newCtxObj3
    -- log $ "BasicXRScene: newCtxObj3=" <> show newCtxObj3
    -- log $ "BasicXRScene: newCtx3.scene=" <> show (UtilsInternal.getContextScene newCtx3)
    -- UtilsInternal.printCtx newCtx3
    -- UtilsInternal.printCtxObj  "loca"  newCtxObj5
    -- log $ "BasicXRScene: newCtxObj3=" <> newCtxObj3
    -- log $ "BasicXRScene:r2=" <> r2
    -- log $ "BasicXRScene:r1=" <> r1
    -- log $ "camera1=" <> camera1
    -- let newCameraStr = "new camera=" <> show (newCtxObj3.camera)
    -- let newCameraStr = "new camera="
    -- log $ "result=" <> result
  --   log $ "BasicXRScene.main: entered" <> show 7
  --   -- result <- Common.createXRExp scene {floorMeshes: [ground]} "myCb"
    -- ControllerXR.init opts
    ControllerXR.init ctx opts
    log  "xr enabled now"
    Engine.runRenderLoop engine $ renderFn scene
    pure unit
