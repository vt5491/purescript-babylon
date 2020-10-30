module Graphics.Babylon.Common where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Graphics.Babylon.Utils (ffi, fpi)
import Graphics.Babylon.Scene as Scene
import Graphics.Babylon.Mesh (Mesh)

foreign import data WebXRExperienceHelper :: Type
foreign import data WebXRDefaultExperience :: Type

initXR :: WebXRExperienceHelper -> Effect Unit
-- initXR xrH = pure unit
-- initXR xrH = log $ "hi from initXR baby"
initXR xrh = fpi [""]
  """
  (function () {
    console.log("hi from initXR-ffi style");
  })()
  """

createXRExp :: Scene.Scene -> {floorMeshes :: Array Mesh} -> String -> Effect Unit
createXRExp = fpi ["scene", "opts", "cb"]
  """
    console.log("createXRExp: scene=", scene, ",opts=", opts);
    scene.createDefaultXRExperienceAsync(opts)
      .then((XRExp) => {
        console.log("Xr loaded, XRexp=", XRExp);
        console.log("initXR=", PS["Graphics.Babylon.Common"].initXR );
        console.log("CreateXRExp: baseExperience=", XRExp.baseExperience );
        (PS["Graphics.Babylon.Common"].initXR(XRExp.baseExperience))();
      })
  """
