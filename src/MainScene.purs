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
import UtilsInternal (addResizeListener)
import Base as Base
-- import Data.Foreign
-- subscenes
import Scenes.HelloWorldScene as HelloWorldScene

-- foreign import dummy_js_7 :: Number
foreign import foo :: Number -> Number -> Number -> Number
foreign import green4 :: Int -> Base.Color3
foreign import green5 :: Effect Base.Color3

-- data Context = Context {
--           -- renderer  :: Renderer.Renderer
--           engine    :: Scene.Engine
--         , scene     :: Scene.Scene
--         -- , camera    :: Camera.CameraInstance
--         --TODO objects
--     }
-- debugger :: Engine.Engine -> Effect Unit
-- debugger = ffi ["x"] "function (x) {debugger}"
--
-- debuggerInt :: Int -> Engine.Engine -> Effect Unit
-- debuggerInt = ffi ["x", "e"] "function (x) {debugger}"

debuggerMat :: Material.StandardMaterial -> Effect Unit
debuggerMat = ffi ["x"]
  """function () {
       console.log("x=", x);
       //debugger;
     }
  """

-- renderFn =  ffi [""]
--       """(function () {
--             //console.log("now in renderFn");
--             //return BABYLON.VT_active_scene.render();
--             BABYLON.VT_active_scene.render();
--           })()
--       """

renderFn =  ffi ["scene"]
      """(function () {
            //console.log("now in renderFn");
            //return BABYLON.VT_active_scene.render();
            //BABYLON.VT_active_scene.render();
            scene.render();
          })
      """
-- runMainScene :: Effect Unit
runMainScene :: Effect Scene.Scene
runMainScene =
  let x = 3
      y = 4
      dummyObj = {a: 7, b: 8}
      canvas = Scene.getCanvasById "renderCanvas"
      -- dummy = dummy_module_mjs_7
      foo_r = foo 1.0 2.0 3.0
  in do
    log "hello from MainScene toplevel"
    log $ "foo_r=" <> show foo_r
    engine       <- Engine.createEngine canvas
    addResizeListener engine
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
    -- debuggerMat greenMat
    -- let greenColor = Material.green 1
    -- let greenColor = Material.green2
    -- let greenColor = Material.green3
    greenColor <- Material.green3
    -- let greenColor = green4 1
    -- greenColor <- green5
    log $ "greenColor=" <> (show greenColor)
    -- Material.setDiffuseColor greenMat $ Material.green 1
    Material.setDiffuseColor greenMat greenColor
    purpleMat <- Material.createStandardMaterial "purpleMat" scene
    Material.setDiffuseColor purpleMat $ Material.purple 1

    Mesh.setMaterial ground greenMat
    box <- Mesh.createBox "box" {} scene
    Mesh.setPosition box $ Vector.createVector3 0.0 0.5 0.0
    Mesh.setMaterial box purpleMat
    -- Engine.runRenderLoop engine renderFn
    Engine.runRenderLoop engine $ renderFn scene
    -- log "hi" <<< log "bye"
    -- do
    --   log "hi"
    --   log "bye"
    -- case Base.topLevelScene of
    --     "HelloWorld" -> do
    --                       log "calling HelloWorldScene"
    --                       HelloWorldScene.main scene
    --
    --     "LoadModel" -> log "calling LoadModelScene"
    --     _           -> log "Unknown Scene specified"
    -- pure unit
    pure scene
