{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "my-project"
, dependencies =
  [ "aff"
  , "affjax"
  , "arrays"
  , "console"
  , "easy-ffi"
  , "effect"
  , "foreign-object"
  , "math"
  , "maybe"
  , "node-fs"
  , "node-fs-aff"
  , "node-path"
  , "psci-support"
  , "record"
  , "transformers"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
