-- This file is *strictly* reference only.  It should *never* refer to (import) any
-- other modules.  This is for global types that need to be referred to by more than one module.
-- We need to create this in order to deal with circular dependencies.
-- module Graphics.Babylon.GlobalTypes where
module GlobalTypes where

import Prelude
import Effect (Effect)
import Graphics.Babylon.Scene (Scene)
import Graphics.Babylon.Camera (CameraInstance)
import Graphics.Babylon.WebXR (WebXRInputSource)
import Graphics.Babylon.Utils (ffi, fpi)
--
-- type GameContext = {
--     scene     :: Scene
--   , camera    :: CameraInstance
--     leftCtrlXR :: WebXRInputSource
-- }
type DummyInt = Int

data Context = Context {
-- type Context = Context {
    scene       :: Scene
  , camera      :: CameraInstance
  , leftCtrlXR  :: WebXRInputSource
}

type ContextObj = {
    scene     :: Scene
  , camera    :: CameraInstance
}

-- data GameContext = GameContext {
--     scene     :: Scene
--   , camera    :: CameraInstance
--   , leftCtrlXR  :: WebXRInputSource
--   , dummyInt :: Int
-- }

type GameContext = {
    scene     :: Scene
  , camera    :: CameraInstance
  , leftCtrlXR  :: WebXRInputSource
  , dummyInt :: Int
}

initGameContext :: Effect GameContext
initGameContext = fpi [""]
  """
      console.log("GlobalTypes.initGameContext: entered");
      if (! BABYLON.VT) {
        BABYLON.VT = {};
      };
      BABYLON.VT.game_context = {};
      BABYLON.VT.game_context.dummyInt = 1;
      //debugger;
      return BABYLON.VT.game_context;
  """

getGameContext :: GameContext
getGameContext = fpi [""]
  """
    console.log("getGameContext: BABYLON.VT.game_context=", BABYLON.VT.game_context);
    //return BABYLON.VT.game_context;
    return BABYLON.VT.game_context;
  """

-- setGameContext :: Int -> GameContext
-- setGameContext = fpi ["dummyInt"]
setGameContext :: WebXRInputSource -> GameContext
setGameContext = fpi ["leftCtrl"]
  """
    console.log("getGameContext: BABYLON.VT.game_context=", BABYLON.VT.game_context);
    //return BABYLON.VT.game_context;
    //BABYLON.VT.game_context.dummyInt = dummyInt;
    BABYLON.VT.game_context.leftCtrlXR = leftCtrl;
    return BABYLON.VT.game_context;
  """
