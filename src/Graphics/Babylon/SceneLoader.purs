module Graphics.Babylon.SceneLoader where

import Prelude (Unit)
import Effect (Effect)
import Graphics.Babylon.Utils (ffi, fpi)
import Graphics.Babylon.Scene (Scene)
-- import Foreign (Foreign)
-- type aliases

type MeshName = String
type Path = String
type File = String
type OnSuccess = Effect Unit

doIt :: Int -> String
doIt = ffi [""] "BABYLON.Engine.Version"

importMesh :: MeshName -> Path -> File -> Scene -> OnSuccess -> Effect Unit
importMesh = ffi ["meshName", "path", "fn", "scene", "cb"]
  """( () => {
                BABYLON.SceneLoader.ImportMesh(meshName, path, fn, scene, cb);  
  })
  """
-- (defn load-triplet-cube [path file name user-cb]
--   (.ImportMesh bjs/SceneLoader ""
--                path
--                file
--                main-scene/scene
--                #(triplet-cube-loaded %1 %2 %3 %4 name user-cb)))

        -- (load-triplet-cube
        --  "models/geb_cube/"
        --  triplet-fn
        --  triplet-name
        --  init-triplet-cube))
