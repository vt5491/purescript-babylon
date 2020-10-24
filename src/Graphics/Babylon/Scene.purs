module Graphics.Babylon.Scene where

import Prelude
import Effect (Effect)
import Data.Maybe (Maybe)
import Graphics.Babylon.Utils (fpi, ffi)
import Graphics.Babylon.Engine (Engine)
import Base (FFICallback, Canvas)

foreign import data Scene :: Type

instance showScene :: Show Scene where
  show = ffi ["s"] "(function () {return 'hey ' + s.uid})()" 

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
-- end hack
getScene :: Int -> Scene
getScene = ffi [""]
  """(function () {
        //var s = BABYLON.Engine.Instances[0].scenes[0];
        //debugger;
        console.log("getScene: Instances.length=", BABYLON.Engine.Instances.length);
        console.log("getScene: Instances[1]=", BABYLON.Engine.Instances[1]);
        var instance_1 = BABYLON.Engine.Instances[1];
        var s;
        var s2;
        if (instance_1) {
          console.log("getScene: instance_1=", instance_1);
          console.log("getScene: instance_1.scenes=", instance_1.scenes);
          s2 = instance_1.scenes[0];
          console.log("getScene: s2.uid=", s2.uid, ",s2=", s2);
        }
        if (s2) {
          return s2;
        }
        else {
          BABYLON.Engine.Instances[0].scenes[0];
          return s;
        }
        //var s = BABYLON.Engine.Instances[0].scenes[0];
        //return s;
        return s2;
        //return BABYLON.Engine.Instances[0].scenes[1];
  })()
  """
