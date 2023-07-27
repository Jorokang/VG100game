module Scenes.Teaching.MainLayer.Export exposing
    ( Data
    , initLayer
    )

{-| Export module

The export module for layer.

Although this will not be updated, usually you don't need to change this file.

@docs Data
@docs initLayer

-}

import Lib.Layer.Base exposing (Layer)
import Scenes.Teaching.LayerBase exposing (CommonData)
import Scenes.Teaching.MainLayer.Common exposing (EnvC, Model)
import Scenes.Teaching.MainLayer.Model exposing (initModel, updateModel, updateModelRec, viewModel)
import Scenes.Teaching.SceneInit exposing (TeachingInit)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> TeachingInit -> Layer Data CommonData
initLayer env i =
    { name = "MainLayer"
    , data = initModel env i
    , update = updateModel
    , updaterec = updateModelRec
    , view = viewModel
    }
