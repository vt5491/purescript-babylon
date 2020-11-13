-- UtilsInternal is refer to many, referenced by few. (the opposite of Graphics.Babylon.Utils)
-- Maybe a better distinction is utilsInternal is app level and can be referenced by the front-end
-- scenes, but avoid accessing from the "Graphics.Babylon" modules.
module UtilsInternal where

import Prelude
import Data.Foreign.EasyFFI
import Effect (Effect)
import Math (pi)
import Graphics.Babylon.Engine (Engine)
import Graphics.Babylon.Utils (ffi, fpi)
import Graphics.Babylon.Scene (Scene)
import Graphics.Babylon.Engine (Engine)
import Graphics.Babylon.Camera (CameraInstance)
import Graphics.Babylon.WebXR (WebXRInputSource)

-- TODO: rename to something like GameContext to make its intent clearer
-- Context
-- Note: update Context and ContextObj in unison
data Context = Context {
-- type Context = Context {
    engine    :: Engine
  , scene     :: Scene
  , camera    :: CameraInstance
}

type ContextObj = {
    engine    :: Engine
  , scene     :: Scene
  , camera    :: CameraInstance
}

-- type GameContext = {
--     scene     :: Scene
--   , camera    :: CameraInstance
--     leftCtrlXR :: WebXRInputSource
-- }

instance showContext :: Show Context where
  -- show Context {scene: s, camera: c} = "scene=" <> show s
  show (Context {scene: s, camera: c}) =
    "showContext: scene=" <> show s <> ", camera=" <> show c

-- instance showContextObj :: Show ContextObj where
--   show ({scene: s, camera: c}) =
--     "showContextObj: scene=" <> show s <> ", camera=" <> show c

initContext :: Engine -> Scene -> CameraInstance -> Context
initContext e s c = Context {engine: e, scene: s, camera: c}

-- alias for initContext
createContext = initContext

getContextEngine :: Context -> Engine
getContextEngine (Context {engine: e, scene: s, camera: c}) = e

getContextScene :: Context -> Scene
getContextScene (Context {engine: e, scene: s, camera: c}) = s

getContextCamera :: Context -> CameraInstance
getContextCamera (Context {engine: e, scene: s, camera: c}) = c

-- getCurrentCamera :: Context -> CameraInstance
-- getCurrentCamera
-- voidCameraInstance :: CameraInstance
-- getCurrentCamera :: CameraInstance
-- getCurrentCamera = createContext

-- contextToObj :: Context -> {scene :: Scene, camera :: CameraInstance}
-- contextToObj (Context {scene: s, camera: c}) = {scene: s, camera: c}

contextToObj :: Context -> ContextObj
contextToObj (Context {engine: e, scene: s, camera: c}) = {engine: e, scene: s, camera: c}

contextObjToContext :: ContextObj -> Context
-- contextObjToContext (ctxObj {scene: s, camera: c} =  Context s c
-- contextObjToContext ctxObj =  Context $ ctxObj.scene $ ctxObj.camera
contextObjToContext ctxObj =
  let e = ctxObj.engine
      s = ctxObj.scene
      c = ctxObj.camera
  in createContext e s c

printCtx :: Context -> Effect Unit
printCtx = fpi ["ctx", ""] "console.log('printCtx: ctx=', ctx);"

printCtxObj :: String -> ContextObj -> Effect Unit
printCtxObj = fpi ["loc", "ctxObj", ""] "console.log('printCtx: ', loc, ':ctxObj=', ctxObj);"

-- Other utils
addResizeListener :: Engine -> Effect Unit
addResizeListener = ffi ["engine"]
  """(function () {
        window.addEventListener('resize', function () {
          console.log("now resizing, engine=", engine);
          engine.resize();
        })
      })
  """
