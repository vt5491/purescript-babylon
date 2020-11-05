module Graphics.Babylon.Common where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Control.Monad.State
import Effect.Aff (Aff)
import Control.Monad.State.Class
import Data.Foldable (traverse_)
import Graphics.Babylon.Utils (ffi, fpi)
import Graphics.Babylon.Scene as Scene
import Graphics.Babylon.Camera as Camera
import Graphics.Babylon.Mesh (Mesh)
import UtilsInternal as UtilsInternal

foreign import createXRExp4 :: UtilsInternal.ContextObj -> {floorMeshes :: Array Mesh} -> String -> UtilsInternal.ContextObj
foreign import createXRExp5 :: UtilsInternal.ContextObj -> {floorMeshes :: Array Mesh} -> String -> UtilsInternal.ContextObj

foreign import data WebXRExperienceHelper :: Type
foreign import data WebXRDefaultExperience :: Type

incCounter :: Array Int -> State Int Unit
incCounter =  traverse_ \n -> modify \sum -> n + sum

sumIncCounter :: Int
sumIncCounter = execState (do
              incCounter [2]
              incCounter [1]) 0

-- currentCtx :: Scene.Scene -> Camera.CameraInstance -> UtilsInternal.Context
-- currentCtx s c = execState (do
--                 pure unit ) UtilsInternal.initContext s c

-- createXRExp :: Scene.Scene -> {floorMeshes :: Array Mesh} -> String -> Effect Unit
-- createXRExp :: UtilsInternal.Context -> {floorMeshes :: Array Mesh} -> String -> Effect Unit
-- Note: the dummy parm at the end of the ffi.  This is absolutely necessary.
createXRExp :: UtilsInternal.ContextObj -> {floorMeshes :: Array Mesh} -> String -> Effect Unit
-- createXRExp :: UtilsInternal.ContextObj -> {floorMeshes :: Array Mesh} -> String -> Effect UtilsInternal.ContextObj
-- createXRExp = fpi ["scene", "opts", "cb"]
-- createXRExp = fpi ["ctxObj", "opts", "cb"]
-- createXRExp = fpi ["ctxObj", "opts", "cb"]
createXRExp = fpi ["ctxObj", "opts", "cb", ""]
-- createXRExp ctxObj opts cb = ffi ["ctxObj", "opts", "cb"]
  """
    let scene = ctxObj.scene;
    let camera = ctxObj.camera;
    console.log("createXRExp: scene=", scene, ",opts=", opts);
    scene.createDefaultXRExperienceAsync(opts)
      .then((XRExp) => {
        console.log("XR loaded XRexp=", XRExp);
        console.log("XR loaded ctxObj=", ctxObj);
        console.log("initXR=", PS["Graphics.Babylon.Common"].initXR );
        console.log("CreateXRExp: baseExperience=", XRExp.baseExperience );
        //debugger;
        //(PS["Graphics.Babylon.Common"].initXR(XRExp.baseExperience))();
        (PS["Graphics.Babylon.Common"].initXR(XRExp.baseExperience))(ctxObj)();
      })
  """

-- createXRExp2 :: UtilsInternal.ContextObj -> {floorMeshes :: Array Mesh} -> String -> Effect Unit
createXRExp2 :: UtilsInternal.ContextObj -> {floorMeshes :: Array Mesh} -> String -> Effect UtilsInternal.ContextObj
-- createXRExp = fpi ["scene", "opts", "cb"]
-- createXRExp = fpi ["ctxObj", "opts", "cb"]
createXRExp2 = fpi ["ctxObj", "opts", "cb", ""]
-- createXRExp2 ctxObj opts cb= ffi ["ctxObj", "opts", "cb"]
  """
    (function () {
      let scene = ctxObj.scene;
      let camera = ctxObj.camera;
      console.log("createXRExp2: scene=", scene, ",opts=", opts);
      scene.createDefaultXRExperienceAsync(opts)
        .then((XRExp) => {
          console.log("XR loaded XRexp=", XRExp);
          console.log("XR loaded ctxObj=", ctxObj);
          console.log("initXR=", PS["Graphics.Babylon.Common"].initXR );
          console.log("CreateXRExp2: baseExperience=", XRExp.baseExperience );
          //debugger;
          //(PS["Graphics.Babylon.Common"].initXR(XRExp.baseExperience))();
          (PS["Graphics.Babylon.Common"].initXR(XRExp.baseExperience))(ctxObj)();
        })
    })()
  """

createXRExp3 :: UtilsInternal.ContextObj -> {floorMeshes :: Array Mesh} -> String -> UtilsInternal.ContextObj
createXRExp3 = ffi ["ctxObj", "opts", "cb", ""]
  """
    (() => {
      let scene = ctxObj.scene;
      let camera = ctxObj.camera;
      console.log("createXRExp3: scene=", scene, ",opts=", opts);
      scene.createDefaultXRExperienceAsync(opts)
        .then((XRExp) => {
          console.log("XR loaded XRexp=", XRExp);
          console.log("XR loaded ctxObj=", ctxObj);
          console.log("initXR=", PS["Graphics.Babylon.Common"].initXR );
          console.log("CreateXRExp3: baseExperience=", XRExp.baseExperience );
          (PS["Graphics.Babylon.Common"].initXR3(XRExp.baseExperience))(ctxObj)();
        })
    })()
  """
             -- (set! camera (-> xr-default-exp (.-baseExperience) (.-camera)))
             -- (set! (.-position camera) camera-init-pos)
-- initXR :: WebXRExperienceHelper -> Effect Unit
-- initXR xrh =
-- initXR :: WebXRExperienceHelper -> UtilsInternal.Context -> Effect Unit
-- initXR :: WebXRExperienceHelper -> UtilsInternal.ContextObj -> Effect Unit
initXR :: WebXRExperienceHelper -> UtilsInternal.ContextObj -> Effect UtilsInternal.ContextObj
-- initXR xrh ctx =
initXR xrh ctxObj =
  let r = "initXR: abc"
      -- scene = UtilsInternal.getContextScene ctx
      -- camera = UtilsInternal.getContextCamera ctx
      scene = ctxObj.scene
      camera = ctxObj.camera
      newCtxObj = ctxObj { camera = camera}
  in do
    log $ "r=" <> r
    log $ "initXR: scene=" <> show scene <> ", camera=" <> show camera
    -- log $ "initXR: newCtxObj=" <> show newCtxObj
    -- pure newCtxObj
    -- pure unit
    pure  {scene: scene, camera: camera}
    -- pure ctxObj
    -- newCtxObj

initXR3 :: WebXRExperienceHelper -> UtilsInternal.ContextObj -> UtilsInternal.ContextObj
initXR3 xrh ctxObj =
  let scene = ctxObj.scene
      camera = ctxObj.camera
      r = UtilsInternal.printCtxObj "initXR3" ctxObj
  in {scene: scene, camera: camera}

-- initXR xrh = fpi ["xhr", "ctxObj"]
--   """
--   (function () {
--     console.log("hi from initXR-ffi style");
--     console.log("initXR: xhr=", xhr);
--     console.log("initXR: ctxObj=", ctxObj);
--   })()
--   """

-- createDefaultXRExperienceAsync :: Scene.Scene -> {floorMeshes :: Array Mesh} -> Aff Unit
createDefaultXRExperienceAsync :: Scene.Scene -> {floorMeshes :: Array Mesh} -> Aff String
createDefaultXRExperienceAsync = fpi ["scene", "opts"]
  """
    console.log("createDefaultXRExperienceAsync: scene=", scene, ",opts=", opts);
    //return scene.createDefaultXRExperienceAsync(opts);
    return "hello";
  """

enterXR :: Int -> Effect Unit
-- enterXR :: {} -> Effect Unit
enterXR n = do
  log $ "now in EnterXR"
