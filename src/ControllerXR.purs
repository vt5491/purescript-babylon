-- module Graphics.Babylon.ControllerXR where
module ControllerXR where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Graphics.Babylon.Utils (ffi, fpi)
import Graphics.Babylon.Scene as Scene
import Control.Monad.Reader (Reader, ask, runReader)
import Graphics.Babylon.Camera as Camera
-- import Graphics.Babylon.Common as Common
import Graphics.Babylon.WebXR as WebXR
import Data.Maybe
import Data.String.Regex (match, search)
import Data.String.Regex.Flags (noFlags)
import Data.String.Regex.Unsafe (unsafeRegex)
import Graphics.Babylon.Mesh (Mesh)
-- import GlobalTypes (GameContext)
import GlobalTypes as GlobalTypes
import UtilsInternal as UtilsInternal
-- (-> xr-helper (.-input ) (.-onControllerAddedObservable) (.add ctrl-added)))
-- CBLiteral = callback literal
-- type CBLiteral = String
type Callback = String
-- foreign import XRAppHelper :: Effect Unit
-- foreign import data XRAppHelper :: Type
-- foreign import xrAppHelper :: Effect Unit
-- foreign import encodeURIComponent :: String -> String
-- foreign import xrSetup2 :: Effect Unit
foreign import xrSetup2 :: Scene.Scene -> Effect Unit
foreign import xrSetup3 :: Scene.Scene -> Effect Unit
-- WebXRInput
-- this is a purescript level definition of foreign type WebXRInput
-- data WebXRInput = WebXRInput {
--     uniqueId  :: Int
-- }
-- type WebXRInput = {
--   -- uniqueId :: Int
--   uniqueId :: String
-- }

-- This basically corresponds to a controller
-- type WebXRInputSource = {
--
-- }
-- foreign import data WebXRInput :: Type

-- instance showWebXRInput :: Show WebXRInput where
--   show = ffi ["ctrl"] "'showWebXRInput: ctrl=' + ctrl + ', uniqueId=' + ctrl.uniqueId;"
--   -- show (WebXRInput wxi) = "showWebXRInput (ps style)= uniqueId=" <> show wxi.uniqueId

-- showIt :: WebXRInput -> String
-- showIt wxi = "wxi.uniqueId=" <> show wxi.uniqueId
-- debuggerHelper :: XRAppHelperType -> Int -> Effect Unit
-- debuggerHelper = fpi ["x", "x2"]
--   """
--        console.log("hi from debuggerHelper");
--        debugger;
--   """
-- type XRAppHelperType = {abc :: Int, dummy :: Int -> Effect Unit, setupXR :: GlobalTypes.DummyInt -> Effect Unit}
type XRAppHelperType = {
  abc :: Int,
  dummy :: Int -> Effect Unit,
  setupXR :: WebXR.WebXRDefaultExperienceOptions -> Effect Unit}
-- foreign import xrAppHelper :: {abc :: Int, dummy :: Int -> Effect Unit}
foreign import xrAppHelper :: XRAppHelperType

debuggerHelper :: XRAppHelperType -> Effect Unit
debuggerHelper = fpi ["x"]
  """
       console.log("hi from debuggerHelper");
       debugger;
  """

dummy :: Effect Unit
dummy = log $ "ControllerXr.dummy: entered"

-- This gets driven after the "enter vr" btn is clicked (by the setup of 'initControllerAddedObservable').
-- ctrlAdded :: Effect Unit
ctrlAdded :: WebXR.WebXRInput -> Effect Unit
-- ctrlAdded = do
ctrlAdded ctrl = do
  log $ "*****ctrlAdd: entered"
  -- log $ "ctrlAdd: WebXRInput.uniqueId=" <> show ctrl.uniqueId
  -- ctx@(UtilsInternal.Context c) <- MainScene.runMainScene
  -- log $ "***ctrlAdded: WebXRInput.uniqueId (js style)=" <> show ctrl
  log $ "***ctrlAdded: WebXRInput.uniqueId (ps style)=" <> show ctrl
  let hand = getCtrlHandedness ctrl
  -- log $ "***ctrlAdded: ctrl handedness=" <> getCtrlHandedness ctrl
  -- if hand == "left" then log $ "left-hand ctrl found"
  -- let r = GlobalTypes.setGameContext ctrl
  if hand == "left" then
    let r = GlobalTypes.setGameContext ctrl
    in pure unit
  --   -- else log $ "some other ctrl found"
    else pure unit
  setupMotionControllerAdded ctrl "motionControllerAdded"
  -- let uniqueId = ctrl.uniqueId
  -- let uniqueId = cont@(WebXRInput c)
  -- cont@(WebXRInput c) <- ctrl
  -- let cont@(WebXRInput c) = ctrl
  -- log $ "***c.uniqueId ps style=" <> show c.uniqueId

  pure unit

-- (-> xr-controller .-onMotionControllerInitObservable (.add motion-controller-added)))
-- initControllerAddedObservable :: Common.WebXRDefaultExperience -> Callback -> Effect Unit
-- This gets driven before the "enter vr" btn is clicked.
-- But the embedded callback 'onControllerAddedObservable' gets driven after entering vr
-- and clicking a controller.
-- initControllerAddedObservable :: Common.WebXRDefaultExperience  -> Effect Unit
initControllerAddedObservable :: WebXR.WebXRDefaultExperience  -> Effect Unit
initControllerAddedObservable = fpi ["xrExp", ""]
  """
  console.log("controllerAddedObservable.js: entered");
  //debugger;
  xrExp.input.onControllerAddedObservable.add((xrCtrl) => {
    //(PS["Graphics.Babylon.ControllerXR"].ctrlAdded);
    //(PS["Graphics.Babylon.ControllerXR"].ctrlAdded)();
    //(PS["Graphics.Babylon.ControllerXR"].ctrlAdded)({uniqueId: 7})();
    // best so far
    //(PS["Graphics.Babylon.ControllerXR"].ctrlAdded)()();
    //(PS["Graphics.Babylon.ControllerXR"].ctrlAdded)(xrCtrl)();
    (PS["ControllerXR"].ctrlAdded)(xrCtrl)();
  });
  return 1;
  """

-- initXRCtrl :: Common.WebXRDefaultExperience -> Effect Unit
initXRCtrl :: WebXR.WebXRDefaultExperience -> Effect Unit
initXRCtrl xrExp = do
  log $ "ControllerXR.initXRCtrl: entered"
  saveXRExp xrExp
  initControllerAddedObservable xrExp
  pure unit


-- (defn get-ctrl-handedness [ctrl]
--   (let [id (.-uniqueId ctrl)]
--     (if (re-matches #".*-(left).*" id)
--       :left
--       (if (re-matches #".*-(right).*" id)
--         :right))))
-- getCtrlHandedness :: WebXRInput -> String
getCtrlHandedness :: WebXR.WebXRInput -> String
getCtrlHandedness ctrl =
  let id = ctrl.uniqueId
      reLeft = unsafeRegex ".*-(left).*" noFlags
      reRight = unsafeRegex ".*-(right).*" noFlags
      idxLeft = search reLeft id
      idxRight = search reRight id
  in
    if isJust idxLeft then "left"
    else
      if isJust idxRight then "right"
      else "no-match"


-- This is activated up entering vr, and then activating a controller
-- Note: you must have the HMD on your head (e.g "pressurized")
-- in order to get any button events generated.
setupMotionControllerAdded :: WebXR.WebXRInput -> String -> Effect Unit
setupMotionControllerAdded = fpi ["ctrl", "cb", ""]
-- setupMotionControllerAdded = fpi ["ctrl", "cb"]
  """
    console.log("***js-setupMotionControllerAdded: ctrl=", ctrl, ",cb=", cb);
    //debugger;
    ctrl.onMotionControllerInitObservable.add((motionCtrl) => {
      console.log("js-embedded-motionControllerAdded: motionCtrl=", motionCtrl);
      let grip = motionCtrl.getComponent("xr-standard-squeeze");
      console.log("grip=", grip);
      if(grip) {
        console.log("setting up grip btn handler");
        BABYLON.VT.grip = grip;
        //grip.onButtonStateChangedObservable.add((cmpt) => {
         // console.log("js-now in grip btn handler");
        //});
        grip.onButtonStateChangedObservable.add(
         //(PS.ControllerXR.gripHandlerXR)(grip)()
         (PS.ControllerXR.gripHandlerXR)(grip)
        );
      }
    });
  """

  -- (if (.-pressed cmpt)
  --   (when (and left-ctrl-xr (not is-gripping))
  --     (set! grip-start-pos (-> left-ctrl-xr (.-grip) (.-position) (.clone)))
  --     (set! is-gripping true)
-- This is the main controller method.  All the callbacks are so that
-- this can eventually be driven.  This is driven on every tick.  We then
-- setup values here and calculate deltas in the 'tick' method.
gripHandlerXR :: WebXR.WebXRControllerComponent -> Effect Unit
gripHandlerXR cmpt =
  let a = 7
      -- pressed = WebXR.isPressed cmpt
      -- pressed = ask WebXR.isPressed cmpt
      -- pressed = do
      -- pressed = WebXR.isPressed2 cmpt
  in do
    log $ "gripHandlerXR: a=" <> show 7
    let r = runReader WebXR.isPressed2 cmpt
    log $ "r=" <> show r
    -- pressed <- WebXR.isPressed cmpt
    -- pressed <- WebXR.isPressed2 cmpt
    -- pressed <- ask WebXR.isPressed cmpt
    -- log $ "gripHandlerXR: pressed=" <> show  pressed
    -- if
    pure unit
-- (defn motion-controller-added [motion-ctrl]
--   (prn "gamepad-evt-hander entered, motion-ctrl=" motion-ctrl)
--   (set! grip (-> motion-ctrl (.getComponent "xr-standard-squeeze")))
--   (when grip
--     (prn "setting up grip btn handler")
--     (-> grip (.-onButtonStateChangedObservable) (.add grip-handler-xr))))

motionControllerAdded :: WebXR.WebXRAbstractMotionController
motionControllerAdded = ffi ["motionCtrl"]
  """
    console.log("js-motionControllerAdded: motionCtrl=", motionCtrl);
  """

saveXRExp :: WebXR.WebXRDefaultExperience -> Effect Unit
-- saveXRExp = fpi ["xrExp", ""]
saveXRExp = fpi ["xrExp", ""]
  """
    BABYLON.VT.xr_exp = xrExp
  """

getLeftCtrlXr :: Effect WebXR.WebXRInputSource
-- getLeftCtrlXr = ffi [""] "BABYLON.VT.leftCtrlXR;"
getLeftCtrlXr = fpi [""]
  """
    if(BABYLON.VT.leftCtrlXR) {
      return BABYLON.VT.leftCtrlXR;
    }
    else {
      return {uniqueId: "zero"};
    }
  """

-- init :: WebXR.WebXRDefaultExperienceOptions -> Effect Unit
init :: UtilsInternal.Context -> WebXR.WebXRDefaultExperienceOptions -> Effect Unit
-- init :: GlobalTypes.Context -> WebXR.WebXRDefaultExperienceOptions -> Effect Unit
init ctx opts =
  let a = 7
      xr_app_helper = xrAppHelper
      scene = UtilsInternal.getContextScene ctx
  in do
    -- xrAppHelper
    let abc = xr_app_helper.abc
    log $ "ControllerXR.init: ctx=" <> show ctx
    -- debuggerHelper xr_app_helper 1
    -- log $ "ControllerXR.init: abc=" <> show abc
    -- let r = xr_app_helper.dummy
    -- let r2 = r 1
    -- r2
    -- let r3 = xr_app_helper.setupXR 1
    -- xr_app_helper.setupXR 1
    -- xr_app_helper.setupXR opts
    --vt-x let r3 = xr_app_helper.setupXR opts
    -- xrSetup2 scene
    -- let r2 = xrSetup2 scene
    let r3 = xrSetup3 scene
    -- log $ "rs=" <> show r2
    pure unit

tick :: Effect Unit
-- tick :: GlobalTypes.DummyInt -> Effect Unit
tick = do
  leftCtrlXR <- getLeftCtrlXr
  -- log $ "now in Controller.tick, leftCtrlXR=" <> show leftCtrlXR
  -- let id = leftCtrlXR.uniqueId
  --     reLeft = unsafeRegex ".*-(left).*" noFlags
  --     idxLeft = search reLeft id
  -- if isJust idxLeft then log $ "found real ctrl" else log $ "fake ctrl"

  pure unit
