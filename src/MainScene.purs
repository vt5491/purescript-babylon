module MainScene where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Graphics.Babylon.Scene    as Scene
import Graphics.Babylon.Engine    as Engine
import Graphics.Babylon.Camera    as Camera
import Graphics.Babylon.Math.Vector as Vector
import Graphics.Babylon.Mesh as Mesh
import Graphics.Babylon.Material as Material
import Graphics.Babylon.Light as Light
import Math (pi)
import Graphics.Babylon.Utils (ffi, oneDeg)
import Base as Base

-- data Context = Context {
--           -- renderer  :: Renderer.Renderer
--           engine    :: Scene.Engine
--         , scene     :: Scene.Scene
--         -- , camera    :: Camera.CameraInstance
--         --TODO objects
--     }
debugger :: Engine.Engine -> Effect Unit
debugger = ffi ["x"] "function (x) {debugger}"

debuggerInt :: Int -> Engine.Engine -> Effect Unit
debuggerInt = ffi ["x", "e"] "function (x) {debugger}"

renderFn =  ffi [""]
      """(function () {
            //console.log("now in renderFn");
            return BABYLON.VT_active_scene.render();
          })()
      """

runMainScene :: Effect Unit
runMainScene =
  let x = 3
      y = 4
      dummyObj = {a: 7, b: 8}
      canvas = Scene.getCanvasById "renderCanvas"
  in do
    log "hello from MainScene toplevel"
    engine       <- Engine.createEngine canvas
    -- let r = Engine.getDescription engine
    -- log $ "r=" <> r
    -- let r = show dummyObj
    -- log r
    -- let r2 = show engine
    -- log r2
    scene        <- Scene.create engine
    Scene.setActiveScene scene
    camera <- Camera.createArcRotate "camera" (oneDeg * 90.0) (oneDeg * 90.0) (45.0)  (Vector.createVector3 0.0 0.0 0.0)
    Camera.attachControl camera canvas true
    light <- Light.createHemisphericLight "light" (Vector.createVector3 0.0 1.0 0.0) scene
    ground <- Mesh.createGround "ground" {width: 50, height: 50} scene
    greenMat <- Material.createStandardMaterial "greenMat" scene
    Material.setDiffuseColor greenMat Material.green
    Mesh.setMaterial ground greenMat
    box <- Mesh.createBox "box" {} scene
    Mesh.setPosition box $ Vector.createVector3 0.0 0.5 0.0
    Engine.runRenderLoop engine renderFn
    pure unit
