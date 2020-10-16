module Game where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Examples.LoadModel (mainLoadModel)
import Examples.HelloWorld (mainHelloWorld)
import MainScene (runMainScene)

main :: Effect Unit
main = do
  log "hello Game top level 2"
  -- mainLoadModel
  -- mainHelloWorld
  runMainScene
