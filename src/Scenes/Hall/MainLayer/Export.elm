module Scenes.Hall.MainLayer.Export exposing
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
import Scenes.Hall.LayerBase exposing (CommonData)
import Scenes.Hall.MainLayer.Common exposing (EnvC, Model)
import Scenes.Hall.MainLayer.Model exposing (initModel, updateModel, updateModelRec, viewModel)
import Scenes.Hall.SceneInit exposing (HallInit)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> HallInit -> Layer Data CommonData
initLayer env i =
    { name = "MainLayer"
    , data = initModel env i
    , update = updateModel
    , updaterec = updateModelRec
    , view = viewModel
    }
