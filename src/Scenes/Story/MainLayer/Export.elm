module Scenes.Story.MainLayer.Export exposing
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
import Scenes.Story.LayerBase exposing (CommonData)
import Scenes.Story.MainLayer.Common exposing (EnvC, Model)
import Scenes.Story.MainLayer.Model exposing (initModel, updateModel, updateModelRec, viewModel)
import Scenes.Story.SceneInit exposing (StoryInit)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> StoryInit -> Layer Data CommonData
initLayer env i =
    { name = "MainLayer"
    , data = initModel env i
    , update = updateModel
    , updaterec = updateModelRec
    , view = viewModel
    }
