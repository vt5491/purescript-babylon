module Scenes.HelloWorldScene where

-- import Prelude (Unit, bind, discard, ($), pure, negate)
import Prelude
import Effect (Effect)
import Effect.Console (log, logShow)
import Data.Semigroup ((<>))
-- import Graphics.Babylon.Loader as Loader
import Graphics.Babylon.Scene    as Scene
import Graphics.Babylon.Mesh as Mesh
import Graphics.Babylon.Math.Vector as Vector
import Graphics.Babylon.Utils (ffi)
import UtilsInternal as UtilsInternal

-- main :: Effect Scene.Scene -> Effect Unit
debuggerScene :: Scene.Scene -> Scene.Scene -> Effect Unit
debuggerScene = ffi ["s", "s2"]
  """function () {
       console.log("s.uid=", s.uid, ",s=", s);
       if (s2) {
         console.log("s2.uid=", s2.uid, ",s2=", s2);
       }
       //debugger;
     }
  """
-- main :: Scene.Scene -> Effect Unit
main :: UtilsInternal.Context -> Effect Unit
-- main scene = do
main ctx = do
  let scene = UtilsInternal.getContextScene ctx
  -- let scene2 = Scene.getScene 1
  -- let scene2 = scene
  log $ "HelloWorldScene.main: scene.uid=" <> Scene.uid scene
  -- debuggerScene scene scene2
  -- log "HelloWorldScene: scene=" <> scene

  -- log $ "HelloWorldScene.main: s.uid=" <> Scene.uid scene
  -- box2 <- Mesh.createBox "box2" {} scene2
  box2 <- Mesh.createBox "box2" {} scene
  -- Mesh.setPosition box2 $ Vector.createVector3 (negate 2.0) 0.5 0.0
  Mesh.setPosition box2 $ Vector.createVector3 (-2.0) 0.5 0.0
  -- debuggerScene scene scene2
  pure unit
  -- log $ "hw: ersion=" <> Loader.doIt 7

-- var canvas = document.getElementById("renderCanvas");
--
-- var engine = null;
-- var scene = null;
-- var sceneToRender = null;
-- var createDefaultEngine = function() { return new BABYLON.Engine(canvas, true, { preserveDrawingBuffer: true, stencil: true }); };
