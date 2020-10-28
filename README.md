### Introduction
 Some basic examples of running a Babylon.js project using purescript, inspired by [purescript-three](https://github.com/anthonyquizon/purescript-three)
.  Not claiming this is using best practices or anything, just something to hopefully get you started.  

See "Developer Notes" at the end for some purescript information and gotchas discovered during implementation.

### First time setup.
0. See [purescript web site](https://github.com/purescript/documentation/blob/master/guides/Getting-Started.md) for how to setup spago if you haven't already done so.

1. Run 'npm install' from root dir.

  -> this will populate node_modules with babylonjs.

  -> As of this writing, babylon.js is the only npm package we use, thus this step is optional if ok running with the default babylon.js

2. If you want to run with a different version of Babylonjs than the supplied 4.1.0 version, copy 'babylon.max.js' and 'babylon.max.js.map' under 'node_modules'
to resources/libs/babylon.

### Development cycle:
1. From root dir run:  

   spago bundle-app --main Game --watch  

  -> This creates a web bundle 'index.js' in the root dir.
2. Open the associated html file for your scene in a browser e.g.:
resources/index.html

### Specify Which Scene to Run
edit src/Base.purs to have the appopriate scene:

```
-- Define the top level scene, to be called after MainScene
topLevelScene :: String
-- topLevelScene = "HelloWorldScene"
topLevelScene = "LoadModelScene"

```
### Developer Notes:
- Uses spago for purescript package management, which is the currently recommended way on the purescript web site (some older repos, such as purescript-three, are still using bower for instance).
 In other words, just a basic "modern" purescript project -- the directory struture such as 'output' and '.spago' is not anything I had to do with.  

- The code is using the top level JS qualifier "BABYLON" to reference Babylon.js and is not using ES6 modules.  This is simply because I currently do not know how to reference ES6 modules using spago.  I would like to add this capability in the future.

#### Some Gotachs
While I'm not completely new to purescript or Haskell, I still consider myself a student and I mainly used this project as a learning experience.

I would say far and away the thing that gave me the most problem was the interface between Purescript and JS.  This project uses 'easy-ffi' to write native JS code( to which I owe a debt of gratitude to purescript-three for making me aware of).  Without easy-ffi you would to manually write horrible looking curried functions like:
```
  exports.applyImpulse = function(force){
    return function(contactPoint){
        return function(mesh){
            return function(){
                mesh.applyImpulse(force, contactPoint);
            };
        };
    };
};

```
Be very careful about the way specify your JS function.  When I previously implemented a basic three.js app, using purescipt-three, I was usually able to get away with implementing simple statements:

```
setWindowScene :: Scene.Scene -> Effect Unit
setWindowScene = ffi["scene"] "window.scene=scene"

```
But for this project I had much better luck implmenting the ffi payload as a full function:

```
createStandardMaterial :: Base.Name -> Scene -> Effect StandardMaterial
createStandardMaterial = ffi ["name", "scene"]
  "(function () {return new BABYLON.StandardMaterial(name, scene)})"

```

In other words, use a full function definition, wrapped in parens with a "return" statement. Do not add IIFE parens (immediately invoked functional expression) if the target is in a do expression-- Purescript will dereference the function for you.

However, if you're passing the result to a let in your do, make it an "IIFE" statement  by adding parens:

```
  in do
    let r = Engine.getDescription engine

```

```
getDescription :: Engine -> String
-- for lets , you need the iife parens
getDescription = ffi ["eng"]
    """(function() {
          console.log("getDescription: eng._fps=", eng._fps);
          //debugger;
          return "hello";
        })()
    """

```
This last example also shows a good way to write longer JS functions, as well as to add JS debug message and invoke the debugger -- absolutely essential to getting a grip on what's "really" going on behind the scenes and taking some of the "magic/mystery" out of Purescript.  Notice how JS comments are ignored in the ffi text itself.

#### Callbacks
Javascript callbacks can be quite tricky, since they're inter-language i.e. they have to be known on the JS and PS sides.  Here's are some gotchas that I had to find out the hard way:

1. Callbacks can be specified using 'ffi' as well:

```
    let cb = ffi ["gltf"] " THREE.vt_scene.add(gltf.scene)"
    let loadResult = Loader.load loader "http://localhost:8000/models/encore.glb" cb
```

2. If your callback doesn't take any parms, then you can specify a purescript function directly.

For example, let's take the following wrapper for the Babylon.js "ImportMesh".  This framework method will drive the callback upon success, passing the array of meshes it just loaded as a parameter:

```
importMesh :: MeshName -> Path -> File -> Scene -> OnSuccess -> Effect Unit
importMesh = ffi ["meshName", "path", "fn", "scene", "cb"]
  """( () => {
                BABYLON.SceneLoader.ImportMesh(meshName, path, fn, scene, cb);  
  })
  """
```

If you don't need to access the 'meshes' parm in your callback, you can specify a parameterless PS function directly:

```
meshLoadedPS2 ::  Effect Unit
meshLoadedPS2 = log $ "hello from meshLoadedPS2"
```  

```
  SceneLoader.importMesh
    ""
    "http://localhost:8000/models/LoadModelScene/"
    "encore_las_vegas.glb"
    scene
    meshLoadedPS2  <- Note: PS function invoked directly with no parms

```

3.  However, things get a little more tricky if you want to access any passed parameters in your callback. In this case, you'll need to use a native JS handler.  This is because if you define a PS function with parameters, but specify the PS function without any parms in your invocation (since the actual passed values won't be known until runtime), you'll get a type error.  Native Javascript functions are much looser about missing parameters etc., so you'll need to use a native JS callback.  You can then choose to handle the callback entirely in JS, or use it to simply catch the event and then access the "PS" global variable to "promote" control back to PS:

```
-- Native JS handler: Note the passed "meshes" parm.
-- Note: how it "promotes" the handling back to PS via PS["Scene.LoadModelScene"]
meshLoaded2 :: Effect Unit
meshLoaded2 = ffi ["meshes"]
  """ ( () => {
    console.log("meshloaded2: length meshes=", meshes.length);
    // do the rest of the processing at the ps level
    (PS["Scenes.LoadModelScene"].meshLoadedPS(meshes))();
  })()
  """
```

So now we specify the (wrapped) ffi function as our callback:
```
  SceneLoader.importMesh
    ""
    "http://localhost:8000/models/LoadModelScene/"
    "encore_las_vegas.glb"
    scene
    meshLoaded2  <- Note: JS function invoked directly with no parms

```

Then the native PS handler looks something like:

Note: how the native 'meshes' object passed to the JS code is still  accessible to PS:
```
meshLoadedPS :: Array Mesh.Mesh -> Effect Unit
meshLoadedPS meshes =
  let rootMesh = filter (\m -> Mesh.getName m == "__root__") meshes
      r = map (\m -> Mesh.setScale m 0.1 0.1 0.1 ) rootMesh
  in pure unit
```

Note: how we basically use the 'let' statement to do side effects, and the function iteself essentially returns "nothing" via 'pure unit'.

Important Note:  Your PS handler has to be referenced somewhere by another PS function otherwise it won't be in the generated output.  That is to say, the PS compiler will optimize out from the build any PS function that isn't referenced.  You may think, well I am referencing the function, from my JS handler.  However, the PS compiler doesn't recognize references from JS to PS.  So you have to put in a "dummy" reference to your PS callback handler, and for some reason it has to be in your root or "main" module.  For instance, I had to add the following to my Game module to prevent the compiler from optimizing out my callback:

```
-- hack to force exporting of ps functions to be called by js callbacks.
-- Has to be done at the "root" module level i.e. can't be done at the callback
-- module itself.
forceExportMeshLoadedPS :: Array Mesh.Mesh -> Effect Unit
forceExportMeshLoadedPS meshes = LoadModelScene.meshLoadedPS meshes
```

#### Conclusion
There's definitely a bit of a learning curve in calling Babylon.js from purescript.  But don't get discouraged.  It really does work, and purescript will reward you with a different way of thinking about code.

The beauty about using Babylon.js to learn Purescript is, if you're like me and love computer graphics and writing games, it's a very motivating environment.  It's certainly a lot more interesting than the usual dry CS stuff like sorts, or binary tree searches etc.

Honestly, I don't think PS is quite there yet as a mainstream choice, as some of the hassles I had getting callbacks to work (which are not clearly documented anywhere as far as I can tell). Maybe this attitude will change as I learn more, but that's just my honest assessment as I write this.  

I've also done some programming in Clojuescript and Re-frame, which feels much further along as a mainstream FP choice (although, let's face it, even cljs is considered pretty "out there").  I love PS though.  It's taught me a lot.  Ironically, it makes me feel better about adapting Clojurescript, as in comparison to PS I think it's much more likely to be "acceptable" to most JS programmers.
