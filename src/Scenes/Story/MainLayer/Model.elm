module Scenes.Story.MainLayer.Model exposing
    ( initModel
    , updateModel, updateModelRec
    , viewModel
    )

{-| Model module

@docs initModel
@docs updateModel, updateModelRec
@docs viewModel

-}

import Canvas exposing (Renderable, empty, text)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Story.MainLayer.Common exposing (EnvC, Model, nullModel)
import Scenes.Story.SceneInit exposing (StoryInit)


{-| initModel
Add components here
-}
initModel : EnvC -> StoryInit -> Model
initModel _ _ =
    nullModel


{-| updateModel
Default update function

Add your logic to handle msg here

-}
updateModel : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env model =
    ( model, [], env )


{-| updateModelRec
Default update function

Add your logic to handle LayerMsg here

-}
updateModelRec : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelRec env _ model =
    ( model, [], env )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel _ _ =
    text [ font { size = 48, family = "Arial", style = "" }, align Center ] ( 50, 50 ) "Story"
