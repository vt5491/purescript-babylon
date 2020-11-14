
// exports.createXRExp4 = function(ctxObj) {
// exports.XRInit = {
//   abc: 7,
//
// }
      // let scene = ctxObj.scene;
      // let camera = ctxObj.camera;
      // console.log("WebXR.createXRExp: scene=", scene, ",opts=", opts);
      // //result = await asyncHandler(scene, camera, opts);
      // // console.log("createXRExp5: result=", result);
      // scene.createDefaultXRExperienceAsync(opts)
      //   .then((XRExp) => {
          // console.log("asyncHandler2 loaded XRexp=", XRExp);
          // console.log("asyncHandler2 loaded ctxObj=", ctxObj);
          // console.log("WebXR.CreateXRExp: baseExperience=", XRExp.baseExperience );
          // let baseExperience = XRExp.baseExperience;
          // if (! BABYLON.VT) {
          //   BABYLON.VT = {};
          // }
          // BABYLON.VT.active_camera = baseExperience.camera;

exports.xrAppHelper = (function (x) {
  //return function () {
    // Note: if you want to use ES6 functional notatation, then 'this' is not bound to 'factory'.
    // If you use ES6 notation, you need to specify 'factory' in your calls e.g 'factory.doIt' not 'this.doIt'.
    let factory = {};

    factory.abc = 7;

    factory.dummy = (x) => {
    // factory.dummy = function(x) {
      console.log("XREnv.dummy: abc=", factory.abc);
      console.log("XREnv.dummy: VT.active_scene==", BABYLON.VT.active_scene);
    };

    factory.dummy2 = function () {
      return 8;
    }

    // Note: BABYLON.VT is not defined when the factory is created, only at runtime.  Thus
    // you can only access BABYLON.VT from within a factory function.
    //factory.scene = BABYLON.VT.active_scene;

    // this sets up the "enter VR" button
    factory.createXRExp = (opts) => {
       console.log("xrAppHelper.createXRExp: entered, opts=", opts);
       let scene = BABYLON.VT.active_scene;
       scene.createDefaultXRExperienceAsync(opts)
        .then((xrExp) => {
          console.log("js.ControllerXR.CreateXRExp: baseExperience=", xrExp.baseExperience );
          factory.setupXRCtrlCallbacks(xrExp);
          factory.enterXRHandler();
        })
    }

    factory.enterXRHandler = function () {
        console.log("js.ControllerXR.enterXRHandler: entered");
    }

    // This is called after clicking the "enter vr" button.
    factory.setupXRCtrlCallbacks = function (xrExp) {
        console.log("js.ControllerXR.setupXRCtrlCallbacks: entered");
        xrExp.input.onControllerAddedObservable.add((xrCtrl) => {
          this.ctrlAdded(xrCtrl);
        })
    }

    // This is called after clicking the "enter vr" button.
    factory.ctrlAdded = function (xrCtrl) {
      console.log("js.ControllerXR.ctrlAdded: entered");
      let hand = this.getCtrlHandedness(xrCtrl);
      console.log("js.ControllerXR.ctrlAdded: hand=", hand);
      if (hand === "left") {
        BABYLON.VT.leftCtrlXR = xrCtrl;
      }
      else if (hand === "right") {
        BABYLON.VT.rightCtrlXR = xrCtrl;
      }
      // (-> xr-controller .-onMotionControllerInitObservable (.add motion-controller-added)
      xrCtrl.onMotionControllerInitObservable.add(this.motionControllerAdded);
    }

// (defn get-ctrl-handedness [ctrl]
//   (let [id (.-uniqueId ctrl)]
//     (if (re-matches #".*-(left).*" id)
//       :left
//       (if (re-matches #".*-(right).*" id)
//         :right))))
    factory.getCtrlHandedness = function (xrCtrl) {
       let id = xrCtrl.uniqueId;
       console.log("getCtrlHandedness: id=", id);
       let result = "";
       if (id.match(/.*-left.*/)) {
         result = "left";
       }
       else {
         if (id.match(/.*-right.*/)) {
           result = "right";
         }
       }
       // debugger;
       return result;
    }

// (defn motion-controller-added [motion-ctrl]
//   (prn "gamepad-evt-hander entered, motion-ctrl=" motion-ctrl)
//   (set! grip (-> motion-ctrl (.getComponent "xr-standard-squeeze")))
//   (when grip
//     (prn "setting up grip btn handler")
//     (-> grip (.-onButtonStateChangedObservable) (.add grip-handler-xr))))
    factory.motionControllerAdded = function(motionCtrl) {
      console.log("js.ControllerXR.motionControllerAdded: entered, motionCtrl=", motionCtrl);
      let grip = motionCtrl.getComponent("xr-standard-squeeze");
      console.log("grip=", grip);
      if(grip) {
        console.log("setting up grip btn handler");
        BABYLON.VT.grip = grip;
        // grip.onButtonStateChangedObservable.add((cmpt) => {
        //   console.log("js-now in grip btn handler");
        // });
        grip.onButtonStateChangedObservable.add(this.gripHandlerXR);
        // grip.onButtonStateChanged.add(this.gripHandlerXR);
      }
      // const thumbstick = motionCtrl.getComponent(BABYLON.WebXRControllerComponent.THUMBSTICK);
      var thumbstick = motionCtrl.getComponent("thumbstick");
      console.log("motionControllerAdded: thumbstick=", thumbstick);
      if(thumbstick) {
        console.log("setting up thumbstick btn handler");
        thumbstick.onButtonStateChangedObservable.add((eventData) => {console.log("thumbstick handler")});
      }
      var mainComp = motionCtrl.getMainComponent();
      console.log("motionControllerAdded: mainComp=", mainComp);
      if(mainComp) {
        console.log("setting up mainComp btn handler");
        mainComp.onButtonStateChangedObservable.add((eventData) => {console.log("mainComp handler")});
      }
    }

    // I cannot get this function to ever be driven.  It's the main controller "read" routine.
    // e.g. the final goal of all the prior callbacks.
    // Update: Put on the headset to fully activate controllers.
    factory.gripHandlerXR = function (cmpt) {
      console.log("gripHandlerXR: entered, cmpt=", cmpt);
    }

    // factory.setupXR = () => {
    factory.setupXR = function (opts) {
      console.log("xrAppHelper.setupXR: entered");
      // factory.createXRExp();
      this.createXRExp(opts);
    }

    return factory;
  //}
})()
// })

exports.xrSetup2 = async (function (scene) {
  console.log("xrSetup2: entered, scene=", scene);
  // var scene = BABYLON.VT.active_scene;
  // debugger;
  var xr = await scene.createDefaultXRExperienceAsync({
      // floorMeshes: [env.ground],
      // inputOptions: { doNotLoadControllerMeshes: true }
  });
  // xr.pointerSelection.detach();

  // const ray = new BABYLON.Ray();
  xr.input.onControllerAddedObservable.add((source) => {
      if (source.inputSource.handedness === "left") {
          source.onMotionControllerInitObservable.add((motionController) => {
              motionController.getMainComponent().onButtonStateChangedObservable.add((eventData) => {
                  if (eventData.changes.pressed) {
                      if (eventData.pressed) {
                        console.log("hi from eventData pressed");
                      }
                  }
              });
          });
      }
  });
})

exports.xrSetup3 = (function (scene) {
  console.log("xrSetup3: entered, scene=", scene);
  // var scene = BABYLON.VT.active_scene;
  // debugger;
  scene.createDefaultXRExperienceAsync({
      // floorMeshes: [env.ground],
      // inputOptions: { doNotLoadControllerMeshes: true }
  }).then((xr) =>
  {
    console.log("xrSetup3: handling xr setup");
    xr.input.onControllerAddedObservable.add((source) => {
        console.log("xrSetup3: controller added");
        if (source.inputSource.handedness === "left") {
            console.log("xrSetup3: left controller found");
            source.onMotionControllerInitObservable.add((motionController) => {
                console.log("xrSetup3: motionController found");
                // motionController.getMainComponent().onButtonStateChangedObservable.add(PS.ControllerXR.dummy);
                motionController.getMainComponent().onButtonStateChangedObservable.add((eventData) => {
                    // Once again, I cannot get this to drive.
                    // Note: You *must* have the HMD on your head at one point to activate the
                    // controllers. After doing this, this section of code is now driven.
                    console.log("xrSetup3: in onButtonStateChanged handler");
                    if (eventData.changes.pressed) {
                        if (eventData.pressed) {
                          console.log("hi from eventData pressed");
                        }
                    }
                });
            });
        }
    });
  });
})
