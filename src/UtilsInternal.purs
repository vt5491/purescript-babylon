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
import Graphics.Babylon.Camera (CameraInstance)

-- Context
-- Note: update Context and ContextObj in unison
data Context = Context {
-- type Context = Context {
    scene     :: Scene
  , camera    :: CameraInstance
}

type ContextObj = {
    scene     :: Scene
  , camera    :: CameraInstance
}

instance showContext :: Show Context where
  -- show Context {scene: s, camera: c} = "scene=" <> show s
  show (Context {scene: s, camera: c}) =
    "showContext: scene=" <> show s <> ", camera=" <> show c

-- instance showContextObj :: Show ContextObj where
--   show ({scene: s, camera: c}) =
--     "showContextObj: scene=" <> show s <> ", camera=" <> show c

initContext :: Scene -> CameraInstance -> Context
initContext s c = Context {scene: s, camera: c}

-- alias for initContext
createContext = initContext

getContextScene :: Context -> Scene
getContextScene (Context {scene: s, camera: c}) = s

getContextCamera :: Context -> CameraInstance
getContextCamera (Context {scene: s, camera: c}) = c

-- getCurrentCamera :: Context -> CameraInstance
-- getCurrentCamera
-- voidCameraInstance :: CameraInstance
-- getCurrentCamera :: CameraInstance
-- getCurrentCamera = createContext

-- contextToObj :: Context -> {scene :: Scene, camera :: CameraInstance}
-- contextToObj (Context {scene: s, camera: c}) = {scene: s, camera: c}

contextToObj :: Context -> ContextObj
contextToObj (Context {scene: s, camera: c}) = {scene: s, camera: c}

contextObjToContext :: ContextObj -> Context
-- contextObjToContext (ctxObj {scene: s, camera: c} =  Context s c
-- contextObjToContext ctxObj =  Context $ ctxObj.scene $ ctxObj.camera
contextObjToContext ctxObj =
  let s = ctxObj.scene
      c = ctxObj.camera
  in createContext s c

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
