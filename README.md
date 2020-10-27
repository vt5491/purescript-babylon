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
Callbacks can be specified using 'ffi' as well:

```
    let cb = ffi ["gltf"] " THREE.vt_scene.add(gltf.scene)"
    let loadResult = Loader.load loader "http://localhost:8000/models/encore.glb" cb
```

#### Conclusion
There's definitely a bit of a learning curve in calling Babylon.js from purescript.  But don't get discouraged.  It really does work, and purescript will reward you with a different way of thinking about code.
