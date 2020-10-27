-- Module for doing experiments.
module Tmp where

import Prelude
import Data.Foldable (traverse_)
import Control.Monad.State
import Control.Monad.State.Class
import Effect (Effect)
import Effect.Console (log)
import Graphics.Babylon.Utils (ffi)

sumArray :: Array Number -> State Number Unit
sumArray = traverse_ \n -> modify \sum -> sum + n

sumArrayInt :: Array Int -> State Int Unit
sumArrayInt = traverse_ \n -> modify \sum -> sum + n

getName :: String -> Int
getName "fred" = 42
getName s = 7

-- wrap js setTimeout using ffi as a cb.
doTimeout :: String -> Int -> Effect Unit
doTimeout = ffi ["cb", "delay"]
  """(() => {
              console.log("doTimeout: cb=", cb, ",delay=", delay);
              window.setTimeout(cb, delay);
     })
  """

-- wrap js setTimeout passing a native purescript function as a cb.
doTimeout2 :: Effect Unit -> Int -> Effect Unit
doTimeout2 = ffi ["cb", "delay"]
  """(() => {
              console.log("doTimeout2: cb=", cb, ",delay=", delay);
              window.setTimeout(cb, delay);
     })
  """