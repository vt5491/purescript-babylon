module Scenes.LoadModelScene where
-- module Scenes.LoadModelScene (meshLoadedPS, main) where

import Prelude
import Effect (Effect)
import Effect.Console (log, logShow)
import Data.Semigroup ((<>))
import Graphics.Babylon.SceneLoader as SceneLoader
import Graphics.Babylon.Scene    as Scene
import Graphics.Babylon.Mesh as Mesh
import Graphics.Babylon.Math.Vector as Vector
import Graphics.Babylon.Utils (ffi)
import Data.Array (length)
import Tmp as Tmp

-- exported :: Int -> Int
-- exported = [dummy main]

cb2 :: Int -> Effect Unit
cb2 n = log $ "now in cb2, n=" <> (show n)

meshLoaded :: Effect Unit
meshLoaded = log $ "now in meshLoaded"

-- meshLoaded :: Array Mesh.Mesh -> Effect Unit
-- meshLoaded :: _ -> Effect Unit
-- meshLoaded ms = log $ show $ length ms

-- meshLoaded :: Array Mesh -> Effect Unit
meshLoaded2 :: Effect Unit
meshLoaded2 = ffi ["meshes"]
  """ ( () => {
    console.log("meshloaded2: length meshes=", meshes.length);
    //console.log("meshloaded2: Game.dummy= ", PS.Game.dummy);
    // do the rest of the processing at the ps level
    (PS["Scenes.LoadModelScene"].meshLoadedPS(meshes))();
  })()
  """

meshLoaded3 :: Effect Unit
meshLoaded3 = ffi [""]
  """ ( () => {
    console.log("meshloaded3: length meshes=");
  })()
  """
  -- map (\x -> show x.name) peeps
meshLoadedPS :: Array Mesh.Mesh -> Effect Unit
-- meshLoadedPS :: Array Mesh.Mesh -> Effect String
meshLoadedPS meshes =
  -- log $ "meshloadedPS: meshes.length=" <> show (length meshes)
  -- log $ map $ (\x -> show x.name) meshes
  -- let r = show (map (\x -> Mesh.getName x) meshes)
  let r = (map (\x -> Mesh.getName x) meshes)
  in log $ "r=" <> show r
  -- in log $ "r="
-- meshLoadedPS meshes = log $ "hi from meshLoadedPS"

-- exportMeshLoadedPS :: Array Mesh.Mesh -> Effect Unit
-- exportMeshLoadedPS meshes = meshLoadedPS meshes

dummy :: Int
dummy = 8

dummy2 :: Int -> Int
dummy2 n = n + 1

dummyB :: Int
dummyB = 18

main :: Scene.Scene -> Effect Unit
main scene = do
  let d = dummy
  -- log $ "LoadModelScene.main: abf" <> "\n" <> "def" <> show d
  -- let d2 = show meshLoadedPS
  box2 <- Mesh.createBox "box2" {} scene
  Mesh.setPosition box2 $ Vector.createVector3 (-14.0) 0.5 0.0
  log $ "getName= " <> (show $ Tmp.getName "fre")
  let cb = ffi [""] "(() => {console.log('back from timeout')})()"
  Tmp.doTimeout cb 1000
  Tmp.doTimeout2
    (cb2 17) 1000
  -- let loadResult = SceneLoader.load loader "../resources/models/simple_cube.gltf" cb
  -- cb2
  let cb3 = ffi ["meshes"] "(function () {console.log('cb3: meshes=', meshes)})"
  SceneLoader.importMesh
    ""
    -- "resources/models/LoadModelScene"
    "http://localhost:8000/models/LoadModelScene/"
    "encore_las_vegas.glb"
    scene
    meshLoaded2
    -- cb3
  pure unit
