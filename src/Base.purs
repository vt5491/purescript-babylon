module Base where

import Prelude (Unit)

import Effect (Effect)
import Graphics.Babylon.Utils (ffi)
-- some common BJS types that don't have their own modules yet.
foreign import data Color3 :: Type
foreign import data Object :: Type
foreign import data Canvas :: Type

-- Some common BJS type synonyms (for parameters).
type Name = String
type FFICallback = String

printObj :: Object -> Effect Unit
printObj = ffi ["o"] "console.log('obj=', obj)"
