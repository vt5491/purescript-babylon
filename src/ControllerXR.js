
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
        grip.onButtonStateChangedObservable.add((cmpt) => {
          console.log("js-now in grip btn handler");
        });
        //debugger;
      }
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
