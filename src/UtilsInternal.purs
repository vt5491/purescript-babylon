-- UtilsInternal is refer to many, referenced by few. (the opposite of Graphics.Babylon.Utils)
-- Maybe a better distinction is utilsInternal is app level and can be referenced by the front-end
-- scenes, but avoid accessing from the "Graphics.Babylon" modules.
module UtilsInternal where

import Prelude
import Data.Foreign.EasyFFI
import Effect (Effect)
import Math (pi)
import Graphics.Babylon.Engine (Engine)
import Graphics.Babylon.Utils (ffi)
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

initContext :: Scene -> CameraInstance -> Context
initContext s c = Context {scene: s, camera: c}

getContextScene :: Context -> Scene
getContextScene (Context {scene: s, camera: c}) = s

getContextCamera :: Context -> CameraInstance
getContextCamera (Context {scene: s, camera: c}) = c

contextToObj :: Context -> {scene :: Scene, camera :: CameraInstance}
contextToObj (Context {scene: s, camera: c}) = {scene: s, camera: c}

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
