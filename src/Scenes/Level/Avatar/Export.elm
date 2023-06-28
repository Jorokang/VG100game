module Scenes.Level.Avatar.Export exposing
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
import Scenes.Level.Avatar.Common exposing (EnvC, Model)
import Scenes.Level.Avatar.Model exposing (initModel, updateModel, updateModelRec, viewModel)
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
    { name = "Avatar"
    , data = initModel env i
    , update = updateModel
    , updaterec = updateModelRec
    , view = viewModel
    }
