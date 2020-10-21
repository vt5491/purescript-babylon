module Scenes.HelloWorldScene where

-- import Prelude (Unit, bind, discard, ($), pure, negate)
import Prelude
import Effect (Effect)
import Effect.Console (log, logShow)
import Data.Semigroup ((<>))
import Graphics.Babylon.Loader as Loader
import Graphics.Babylon.Scene    as Scene
import Graphics.Babylon.Mesh as Mesh
import Graphics.Babylon.Math.Vector as Vector

-- main :: Effect Scene.Scene -> Effect Unit
main :: Scene.Scene -> Effect Unit
main scene = do
  log $ "HelloWorldScene.main: abc" <> "\n" <> "def"
  log $ "HelloWorldScene.main: s.uid=" <> Scene.uid scene
  box2 <- Mesh.createBox "box2" {} scene
  -- Mesh.setPosition box2 $ Vector.createVector3 (negate 2.0) 0.5 0.0
  Mesh.setPosition box2 $ Vector.createVector3 (-2.0) 0.5 0.0
  pure unit
  -- log $ "hw: ersion=" <> Loader.doIt 7

-- var canvas = document.getElementById("renderCanvas");
--
-- var engine = null;
-- var scene = null;
-- var sceneToRender = null;
-- var createDefaultEngine = function() { return new BABYLON.Engine(canvas, true, { preserveDrawingBuffer: true, stencil: true }); };
