module Graphics.Babylon.ControllerXR where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Graphics.Babylon.Utils (ffi, fpi)
import Graphics.Babylon.Scene as Scene
import Graphics.Babylon.Camera as Camera
import Graphics.Babylon.Common as Common

-- (-> xr-helper (.-input ) (.-onControllerAddedObservable) (.add ctrl-added)))
-- CBLiteral = callback literal
-- type CBLiteral = String
type Callback = String
-- WebXRInput
-- this is a purescript level definition of foreign type WebXRInput
-- data WebXRInput = WebXRInput {
--     uniqueId  :: Int
-- }
foreign import data WebXRInput :: Type

instance showWebXRInput :: Show WebXRInput where
  show = ffi ["ctrl"] "'showWebXRInput: ctrl=' + ctrl + ', uniqueId=' + ctrl.uniqueId;"

-- This gets driven after the "enter vr" btn is clicked (by the setup of 'initControllerAddedObservable').
-- ctrlAdded :: Effect Unit
ctrlAdded :: WebXRInput -> Effect Unit
-- ctrlAdded = do
ctrlAdded ctrl = do
  log $ "*****ctrlAdd: entered"
  -- log $ "ctrlAdd: WebXRInput.uniqueId=" <> show ctrl.uniqueId
  -- ctx@(UtilsInternal.Context c) <- MainScene.runMainScene
  log $ "***ctrlAdded: WebXRInput.uniqueId (js style)=" <> show ctrl
  -- let uniqueId = ctrl.uniqueId
  -- let uniqueId = cont@(WebXRInput c)
  -- cont@(WebXRInput c) <- ctrl
  -- let cont@(WebXRInput c) = ctrl
  -- log $ "***c.uniqueId ps style=" <> show c.uniqueId
  pure unit

-- initControllerAddedObservable :: Common.WebXRDefaultExperience -> Callback -> Effect Unit
-- This gets driven before the "enter vr" btn is clicked.
-- But the embedded callback 'onControllerAddedObservable' gets driven after entering vr
-- and clicking a controller.
initControllerAddedObservable :: Common.WebXRDefaultExperience  -> Effect Unit
initControllerAddedObservable = fpi ["xrExp", ""]
  """
  console.log("controllerAddedObservable.js: entered");
  //debugger;
  xrExp.input.onControllerAddedObservable.add((xrCtrl) => {
    (PS["Graphics.Babylon.ControllerXR"].ctrlAdded);
    //(PS["Graphics.Babylon.ControllerXR"].ctrlAdded)();
    //(PS["Graphics.Babylon.ControllerXR"].ctrlAdded)({uniqueId: 7})();
    // best so far
    //(PS["Graphics.Babylon.ControllerXR"].ctrlAdded)()();
    (PS["Graphics.Babylon.ControllerXR"].ctrlAdded)(xrCtrl)();
  });
  return 1;
  """

initXRCtrl :: Common.WebXRDefaultExperience -> Effect Unit
initXRCtrl xrExp = do
  log $ "ControllerXR.initXRCtrl: entered"
  initControllerAddedObservable xrExp
  pure unit
