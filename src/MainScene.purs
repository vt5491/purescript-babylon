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
import Graphics.Babylon.Utils (ffi, fpi, oneDeg)
-- import UtilsInternal (addResizeListener, Context)
import UtilsInternal as UtilsInternal
import Base as Base
-- import Data.Foreign
-- subscenes
import Scenes.HelloWorldScene as HelloWorldScene
-- import Graphics.Babylon.GlobalTypes (ContextObj, GameContext)
import GlobalTypes as GlobalTypes

-- foreign import dummy_js_7 :: Number
foreign import foo :: Number -> Number -> Number -> Number
foreign import green4 :: Int -> Base.Color3
foreign import green5 :: Effect Base.Color3
-- foreign import incClick :: Effect Unit

dummyMainScene ::  Int -> Int
dummyMainScene n = 8

dummyReadGameCtx :: GlobalTypes.GameContext
dummyReadGameCtx = GlobalTypes.getGameContext

currentCtx :: Scene.Scene -> Camera.CameraInstance -> UtilsInternal.Context
currentCtx s c = UtilsInternal.createContext s c

debuggerMat :: Material.StandardMaterial -> Effect Unit
debuggerMat = ffi ["x"]
  """function () {
       console.log("x=", x);
       //debugger;
     }
  """

-- Init the BABYLON.VT hash
initJsAppGlobal :: Effect Unit
-- initJsAppGlobal :: GlobalTypes.DummyInt -> Effect Unit
-- initJsAppGlobal n = log $ "hi from initJsAppGlobal"
-- initJsAppGlobal = ffi ["n"]
--   """(function () {
--         console.log("initJsAppGlobal: entered");
--         BABYLON.VT = {};
--   })()
--   """
initJsAppGlobal = fpi [""]
  """
          console.log("initJsAppGlobal: entered");
          //if (! BABYLON.VT) {
          BABYLON.VT = {};
          //}
  """

renderFn =  ffi ["scene"]
      """(function () {
            //console.log("now in renderFn");
            //return BABYLON.VT_active_scene.render();
            //BABYLON.VT_active_scene.render();
            scene.render();
          })
      """
-- runMainScene :: Effect Unit
-- runMainScene :: Effect Scene.Scene
runMainScene :: Effect UtilsInternal.Context
runMainScene =
  let x = 3
      y = 4
      dummyObj = {a: 7, b: 8}
      canvas = Scene.getCanvasById "renderCanvas"
      foo_r = foo 1.0 2.0 3.0
      -- gameCtx = GlobalTypes.initGameContext
  in do
    log "hello from MainScene toplevel"
    gameCtx <- GlobalTypes.initGameContext
    log $ "foo_r=" <> show foo_r
    engine       <- Engine.createEngine canvas
    UtilsInternal.addResizeListener engine
    scene        <- Scene.create engine
    -- let rAppGlobal = initJsAppGlobal 1
    -- initJsAppGlobal 1
    initJsAppGlobal
    Scene.setActiveScene scene
    camera <- Camera.createArcRotate "camera" (oneDeg * 90.0) (oneDeg * 90.0) (45.0)  (Vector.createVector3 0.0 0.0 0.0)
    let ctx = UtilsInternal.initContext scene camera
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
    -- pure unit
    -- pure scene
    log $ "returning from runMainScene, ctx=" <> show ctx
    pure ctx
