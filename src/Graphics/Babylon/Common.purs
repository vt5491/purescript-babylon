module Graphics.Babylon.Common where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Graphics.Babylon.Utils (ffi, fpi)
import Graphics.Babylon.Scene as Scene
import Graphics.Babylon.Mesh (Mesh)
import UtilsInternal as UtilsInternal

foreign import data WebXRExperienceHelper :: Type
foreign import data WebXRDefaultExperience :: Type

-- createXRExp :: Scene.Scene -> {floorMeshes :: Array Mesh} -> String -> Effect Unit
-- createXRExp :: UtilsInternal.Context -> {floorMeshes :: Array Mesh} -> String -> Effect Unit
createXRExp :: UtilsInternal.ContextObj -> {floorMeshes :: Array Mesh} -> String -> Effect Unit
-- createXRExp = fpi ["scene", "opts", "cb"]
createXRExp = fpi ["ctxObj", "opts", "cb"]
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
             -- (set! camera (-> xr-default-exp (.-baseExperience) (.-camera)))
             -- (set! (.-position camera) camera-init-pos)
-- initXR :: WebXRExperienceHelper -> Effect Unit
-- initXR xrh =
-- initXR :: WebXRExperienceHelper -> UtilsInternal.Context -> Effect Unit
initXR :: WebXRExperienceHelper -> UtilsInternal.ContextObj -> Effect Unit
-- initXR xrh ctx =
initXR xrh ctxObj =
  let r = "abc"
      -- scene = UtilsInternal.getContextScene ctx
      -- camera = UtilsInternal.getContextCamera ctx
      scene = ctxObj.scene
      camera = ctxObj.camera
  in do
    log $ "r=" <> r
    log $ "initXR: scene=" <> show scene <> ", camera=" <> show camera
    pure unit
-- initXR xrh = fpi ["xhr", "ctxObj"]
--   """
--   (function () {
--     console.log("hi from initXR-ffi style");
--     console.log("initXR: xhr=", xhr);
--     console.log("initXR: ctxObj=", ctxObj);
--   })()
--   """
