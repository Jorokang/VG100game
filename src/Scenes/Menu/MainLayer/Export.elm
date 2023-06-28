module Scenes.Menu.MainLayer.Export exposing
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
import Scenes.Menu.LayerBase exposing (CommonData)
import Scenes.Menu.MainLayer.Common exposing (EnvC, Model)
import Scenes.Menu.MainLayer.Model exposing (initModel, updateModel, updateModelRec, viewModel)
import Scenes.Menu.SceneInit exposing (MenuInit)


{-| Data
-}
type alias Data =
    Model


{-| initLayer
-}
initLayer : EnvC -> MenuInit -> Layer Data CommonData
initLayer env i =
    { name = "MainLayer"
    , data = initModel env i
    , update = updateModel
    , updaterec = updateModelRec
    , view = viewModel
    }
