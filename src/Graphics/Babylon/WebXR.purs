-- Kind of a general contain for all Babylon.js XR related objects.
module Graphics.Babylon.WebXR where

import Prelude
import Effect (Effect)
import Effect.Console (log)
-- import Control.Monad.State
-- import Effect.Aff (Aff)
-- import Control.Monad.State.Class
-- import Data.Foldable (traverse_)
import Graphics.Babylon.Utils (ffi, fpi)
import Graphics.Babylon.Scene as Scene
import Graphics.Babylon.Camera as Camera
import Graphics.Babylon.Mesh (Mesh)
-- import UtilsInternal as UtilsInternal
-- import Graphics.Babylon.GlobalTypes (ContextObj)

foreign import data WebXRExperienceHelper :: Type
foreign import data WebXRDefaultExperience :: Type
foreign import data WebXRState :: Type
foreign import data WebXRAbstractMotionController :: Type
-- foreign import data WebXRDefaultExperienceOptions :: Type

instance showWebXRState :: Show WebXRState where
  show = ffi ["s"] "'WebXRState=' + s"

type WebXRInput = {
  -- uniqueId :: Int
  uniqueId :: String
}
-- This basically corresponds to a controller
type WebXRInputSource = {
  uniqueId :: String
}

type WebXRDefaultExperienceOptions = { floorMeshes :: Array Mesh }
-- -- createXRExp :: UtilsInternal.ContextObj -> {floorMeshes :: Array Mesh} -> String -> UtilsInternal.ContextObj
-- createXRExp :: ContextObj -> {floorMeshes :: Array Mesh} -> String -> ContextObj
-- -- createXRExp = fpi ["ctxObj", "opts", "cb", ""]
-- createXRExp = fpi ["ctxObj", "opts", "cb"]
--   """
--       let scene = ctxObj.scene;
--       let camera = ctxObj.camera;
--       console.log("WebXR.createXRExp: scene=", scene, ",opts=", opts);
--       //result = await asyncHandler(scene, camera, opts);
--       // console.log("createXRExp5: result=", result);
--       scene.createDefaultXRExperienceAsync(opts)
--         .then((XRExp) => {
--           console.log("asyncHandler2 loaded XRexp=", XRExp);
--           console.log("asyncHandler2 loaded ctxObj=", ctxObj);
--           console.log("WebXR.CreateXRExp: baseExperience=", XRExp.baseExperience );
--           let baseExperience = XRExp.baseExperience;
--           if (! BABYLON.VT) {
--             BABYLON.VT = {};
--           }
--           BABYLON.VT.active_camera = baseExperience.camera;
--           //baseExperience.onStateChangedObservable = PS["Graphics.Babylon.Common"].enterXR(1);
--           //baseExperience.onStateChangedObservable.add = () => {console.log("hi from cb")};
--           // baseExperience.onStateChangedObservable.add(function (x) {console.log("hi from cb, x=", x)});
--           // baseExperience.onStateChangedObservable.add((x) => {console.log("hi from cb, x=", x)});
--           // baseExperience.onStateChangedObservable.add((x) => {console.log("hi from cb")});
--           //(PS["Graphics.Babylon.ControllerXR"].initXRCtrl)(XRExp)();
--           (PS["ControllerXR"].initXRCtrl)(XRExp)();
--           baseExperience.onStateChangedObservable.add((webXRState) => {
--             console.log("hi from cb");
--             //vt-x(PS["Graphics.Babylon.Common"].enterXR)(webXRState)();
--             (PS["Graphics.Babylon.WebXR"].enterXR)(webXRState)();
--           });
--             // (PS["Graphics.Babylon.Common"].enterXR)(1);});
--           // baseExperience.onStateChangedObservable.add(() => {return 7});
--           // baseExperience.onInitialXRPoseSetObservable.add(() => {return 7})
--           console.log("added observer");
--
--           // resolve({scene: scene, camera: camera, abc: 7});
--         })
--   """

-- createDefaultXRExperienceAsync :: Scene.Scene -> {floorMeshes :: Array Mesh} -> Aff String
-- createDefaultXRExperienceAsync = fpi ["scene", "opts"]
--   """
--     console.log("WebXR.createDefaultXRExperienceAsync: scene=", scene, ",opts=", opts);
--     //return scene.createDefaultXRExperienceAsync(opts);
--     return "hello";
--   """

-- enterXR :: Int -> Effect Unit
-- Note: this gets activated when the "enter VR" button is clicked.
enterXR :: WebXRState -> Effect Unit
-- enterXR :: {} -> Effect Unit
enterXR webXRState = do
  -- let state = webXRState.ENTERING_XR
  let state = webXRState
  log $ "now in WebXR.EnterXR, state=" <> show state

-- (defn get-ctrl-handedness [ctrl]
--   (let [id (.-uniqueId ctrl)]
--     (if (re-matches #".*-(left).*" id)
--       :left
--       (if (re-matches #".*-(right).*" id)
--         :right))))
