// createXRExp3 = ffi ["ctxObj", "opts", "cb", ""]
exports.createXRExp4 = function(ctxObj) {
  return function (opts) {
    return function (cb) {
      let scene = ctxObj.scene;
      let camera = ctxObj.camera;
      console.log("createXRExp4: scene=", scene, ",opts=", opts);
      scene.createDefaultXRExperienceAsync(opts)
        .then((XRExp) => {
          console.log("XR loaded XRexp=", XRExp);
          console.log("XR loaded ctxObj=", ctxObj);
          console.log("initXR=", PS["Graphics.Babylon.Common"].initXR );
          console.log("CreateXRExp4: baseExperience=", XRExp.baseExperience );
          (PS["Graphics.Babylon.Common"].initXR3(XRExp.baseExperience))(ctxObj)();
        })
    }
  }
}

exports.createXRExp5 =  function (ctxObj) {
  // function asyncHandler (scene, camera) {
  //   return new Promise( resolve => {
  //     scene.createDefaultXRExperienceAsync(opts)
  //       .then((XRExp) => {
  //         console.log("asyncHandler loaded XRexp=", XRExp);
  //         console.log("asyncHandler loaded ctxObj=", ctxObj);
  //         // console.log("initXR=", PS["Graphics.Babylon.Common"].initXR );
  //         console.log("CreateXRExp5: baseExperience=", XRExp.baseExperience );
  //         //(PS["Graphics.Babylon.Common"].initXR3(XRExp.baseExperience))(ctxObj)();
  //         resolve {scene: scene, camera: camera};
  //       })
  //     });
  //   }
  function asyncHandler(scene, camera, opts) {
     return new Promise ((resolve) => {
      scene.createDefaultXRExperienceAsync(opts)
        .then((XRExp) => {
          console.log("asyncHandler loaded XRexp=", XRExp);
          console.log("asyncHandler loaded ctxObj=", ctxObj);
          console.log("CreateXRExp5: baseExperience=", XRExp.baseExperience );
          let baseExperience = XRExp.baseExperience;
          if (! BABYLON.VT) {
            BABYLON.VT = {};
          }
          BABYLON.VT.active_camera = baseExperience.camera;
          //baseExperience.onStateChangedObservable = PS["Graphics.Babylon.Common"].enterXR(1);
          //baseExperience.onStateChangedObservable.add = () => {console.log("hi from cb")};
          debugger;
          baseExperience.onStateChangedObservable.add = function (x) {console.log("hi from cb, x=", x)};
          resolve({scene: scene, camera: camera, abc: 7});
        })
     })
  };

  return function (opts) {
    return async function (cb) {
      let scene = ctxObj.scene;
      let camera = ctxObj.camera;
      console.log("createXRExp5: scene=", scene, ",opts=", opts);
      //result = await asyncHandler(scene, camera, opts);
      // console.log("createXRExp5: result=", result);
      scene.createDefaultXRExperienceAsync(opts)
        .then((XRExp) => {
          console.log("asyncHandler2 loaded XRexp=", XRExp);
          console.log("asyncHandler2 loaded ctxObj=", ctxObj);
          console.log("CreateXRExp5: baseExperience=", XRExp.baseExperience );
          let baseExperience = XRExp.baseExperience;
          if (! BABYLON.VT) {
            BABYLON.VT = {};
          }
          BABYLON.VT.active_camera = baseExperience.camera;
          //baseExperience.onStateChangedObservable = PS["Graphics.Babylon.Common"].enterXR(1);
          //baseExperience.onStateChangedObservable.add = () => {console.log("hi from cb")};
          console.log("about to set debugger");
          // debugger;
          console.log("past debugger");
          // baseExperience.onStateChangedObservable.add(function (x) {console.log("hi from cb, x=", x)});
          // baseExperience.onStateChangedObservable.add((x) => {console.log("hi from cb, x=", x)});
          // baseExperience.onStateChangedObservable.add((x) => {console.log("hi from cb")});
          (PS["Graphics.Babylon.ControllerXR"].initXRCtrl)(XRExp)();
          baseExperience.onStateChangedObservable.add((webXRState) => {
            console.log("hi from cb");
            (PS["Graphics.Babylon.Common"].enterXR)(webXRState)();
          });
            // (PS["Graphics.Babylon.Common"].enterXR)(1);});
          // baseExperience.onStateChangedObservable.add(() => {return 7});
          // baseExperience.onInitialXRPoseSetObservable.add(() => {return 7})
          console.log("added observer");

          // resolve({scene: scene, camera: camera, abc: 7});
        })
      return 1;
    }
  }
}
