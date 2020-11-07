-- Module for doing experiments.
module Tmp where

import Prelude
import Data.Foldable (traverse_)
import Control.Monad.State
import Control.Monad.State.Class
import Effect (Effect)
import Effect.Console (log)
import Graphics.Babylon.Utils (ffi)
import Data.Array (head)
-- import Data.Maybe (Maybe)
import Data.Maybe
import Foreign.Object as FO
import Data.Array ((..), length)
import Control.Plus (empty)

type DummyInt = Int

sumArray :: Array Number -> State Number Unit
sumArray = traverse_ \n -> modify \sum -> sum + n

sumArrayInt :: Array Int -> State Int Unit
sumArrayInt = traverse_ \n -> modify \sum -> sum + n

-- getName :: String -> Int
-- getName "fred" = 42
-- getName s = 7

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

r :: Array {name :: String, id :: Int}
r = [{name: "wilma", id: 10}, {name: "betty", id: 11}]
-- Maybe
--   { id :: Int
--   , name :: String
--   }
getName :: Maybe {id :: Int, name :: String} -> String
-- getName :: {id :: Int, name :: String}
-- getName r = r.name
-- getName (Just {r}) = r.name
getName (Just r2) = r2.name
getName Nothing = ""

-- createObj :: Int -> Effect (Array String)
createObj :: Int -> Effect (FO.Object String)
createObj = ffi ["dummy_n"]
   """(() => {
     return {a: "abc"};
   })()
   """

createObj2 :: Int ->  (FO.Object String)
createObj2 = ffi ["dummy_n"]
   """(() => {
     return {a: "abc", b: "def", c: 7};
   })()
   """

createObj3 :: forall a. Int ->  (FO.Object a)
createObj3 = ffi ["dummy_n"]
   """(() => {
     return {a: "abc", b: "def", c: 7};
   })()
   """

createObj4 :: DummyInt ->  (FO.Object {a :: String, c :: Int})
createObj4 = ffi ["dummy_n"]
-- createObj4 ::  (FO.Object {a :: String, c :: Int})
-- createObj4 = ffi ["n"]
   """(() => {
     return {a: "abc", c: 7};
   })()
   """

-- createPSObj :: {a :: String, c :: Int} -> FO.Object {a :: String, c :: Int}
-- createPSObj r = FO.insert

-- printJsObj :: Effect Unit
-- -- printJsObj :: Effect (FO.Object String)
-- printJsObj = do
--   -- let
--   --   jo = createObj 1
--   --   ks = FO.keys jo
--   -- printKeys ks
--    let
--      -- jo = createObj2 1
--      jo = createObj3 1
--      -- r = printKeys $ FO.keys (createObj2 1)
--      r = printKeys $ FO.keys jo
--      r2 = printVals $ FO.values jo
--    -- log $ "r=" <> r
--    pure unit

-- printJsObj2 :: Effect Unit
-- printJsObj2 = do
--    let
--      jo = createObj3 1
--      r = printKeys $ FO.keys jo
--      r2 = printVals $ FO.values jo
--    pure unit

-- printKeys :: Array String -> Effect Unit
-- printKeys = ffi ["keys"]
--   """ (() => {
--     console.log("printKeys: keys=", keys);
--   })()
--   """

printVals :: Array String -> Effect Unit
printVals = ffi ["vals"]
  """ (() => {
    console.log("printVals: vals=", vals);
  })()
  """
-- printObj :: FO.empty -> Effect Unit
-- printObj :: FO.Object -> Effect Unit
-- printObj :: forall a. FO.Object a -> Effect Unit
-- printObj :: forall a. FO.Object a ->  Unit
-- printObj :: forall a. Int -> FO.Object a  -> Effect Unit
-- printObj :: forall b. Int -> FO.Object Int  -> Effect Unit
-- printObj n o =
--   let
--     keys = FO.keys o
--   in
--     ffi ["keys"]
--     """((keys) => {
--       //console.log("printObj: o=", o);
--       console.log("printObj: keys=", keys);
--       //return 7
--     })()
--     """
-- printObj = log $ "hi"
-- printObj obj = do
--   log $ "hi"
--   pure unit
-- Note: dont want IIFE parens
printObj2 :: Int -> FO.Object String -> Effect Unit
printObj2 n = ffi ["o"]
    """(() => {
      //console.log("printObj: o=", o);
      console.log("printObj2: o mo=", o);
      //return 7
    })
    """

-- > in3 = FO.insert "a" "abc" $ FO.empty
-- > in4=FO.insert "b" "def" in3
-- > printObj3  in4
printObj3 ::  FO.Object String -> Effect Unit
printObj3 = ffi ["o"]
    """(() => {
      //console.log("printObj: o=", o);
      console.log("printObj3: o=", o);
      //return 7
    })
    """

printObj4 ::  FO.Object {a :: String, c :: Int} -> Effect Unit
printObj4 = ffi ["o"]
    """(() => {
      //console.log("printObj: o=", o);
      console.log("printObj4: o=", o);
      //return 7
    })
    """
doTest :: Int -> Effect Unit
doTest n = do
  log $ "hi"

foTest :: Effect Unit
foTest = do
  let
    o = FO.empty
    inserted = FO.insert "a" 1 o
    -- log $ "o=" <> show o
  pure unit

--- play around with Maybe
mbAdd1 :: Int -> Maybe Int
mbAdd1 n = Just $ n + 1

mbAdd2 :: Int -> Maybe Int
mbAdd2 n = Just $ n + 2

mbAddChaos :: Int -> Maybe Int
mbAddChaos n
    | n < 100 = Just n
    | otherwise = Nothing

mbDo :: Int -> Maybe Int
mbDo n =
  let a = "hi"
  in do
    r1 <- mbAdd1 n
    rc <- mbAddChaos r1
    r2 <- mbAdd2 rc
    pure r2

-- play around with changing objects
type Person = {name :: String, id :: Int}

fred :: Person
fred = {name: "fred", id: 69}

-- var newCtxObj = Graphics_Babylon_Common.createXRExp2(UtilsInternal.contextToObj(ctx))({
--               floorMeshes: [ ground ]
--           })("myCB")();

arrayDo :: Array Int
-- arrayDo :: Array (Array Int)
arrayDo =
  let sum = 1
  in do
    x <- 1..4
    -- let sum = sum + x
    -- sum + x
    -- y <- 1..3
    -- log $ "x+y=" <> show  (length  x )
    -- log $ "x+y=" <> show  (x + y)
    -- x <- [1,2]
    pure $ x + sum

countThrows :: Int -> Array (Array Int)
countThrows n = do
  x <- 1 .. 6
  y <- 1 .. 6
  if x + y == n
    then pure [x, y]
    else empty

intDo :: Array Int
intDo =
  let s = 0
  in do
    -- x <- 1
    z <- [2]
    let x = 1
        y = 2
    -- r <- x + y
    [7]
