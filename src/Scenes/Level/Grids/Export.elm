module Scenes.Level.Grids.Export exposing
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
import Scenes.Level.Grids.Common exposing (EnvC, Model)
import Scenes.Level.Grids.Model exposing (initModel, updateModel, updateModelRec, viewModel)
import Scenes.Level.LayerBase exposing (CommonData)
import Scenes.Level.SceneInit exposing (LevelInit)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> LevelInit -> Layer Data CommonData
initLayer env i =
    { name = "Grids"
    , data = initModel env i
    , update = updateModel
    , updaterec = updateModelRec
    , view = viewModel
    }
