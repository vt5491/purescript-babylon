module Graphics.Babylon.Scene where

import Prelude
import Effect (Effect)
import Data.Maybe (Maybe)
import Graphics.Babylon.Utils (fpi, ffi)
import Graphics.Babylon.Engine (Engine)
import Base (FFICallback, Canvas)

foreign import data Scene :: Type

create :: Engine -> Effect Scene
create = ffi ["engine"]
  """(function () {
        console.log("Scene.create: engine=", engine);
        var s= new BABYLON.Scene(engine);
        console.log("Scene.create: s=", s);
        return s;
      })
  """
getCanvasById :: String -> Canvas
getCanvasById = ffi ["id"] "document.getElementById(id)"

uid :: Scene -> String
uid = ffi ["scene"] "(() => {return scene.uid})()"

-- following is a hack
setActiveScene :: Scene -> Effect Unit
setActiveScene = ffi["scene"]
  "(function () {BABYLON.VT_active_scene=scene})"
