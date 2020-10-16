module Graphics.Babylon.Utils where

import Prelude
import Data.Foreign.EasyFFI
import Effect (Effect)
import Math (pi)

ffi :: forall a. Array String -> String -> a
ffi = unsafeForeignFunction
fpi :: forall a. Array String -> String -> a
fpi = unsafeForeignProcedure

oneDeg :: Number
oneDeg = pi / 180.0

debuggerStrArray :: Array String
debuggerStrArray = ffi [""] "debugger"
