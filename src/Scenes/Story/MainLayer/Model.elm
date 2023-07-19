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
import Scenes.Story.MainLayer.Common exposing (initModel1)
import Scenes.Story.MainLayer.Render exposing (renderBackground, renderMasking, renderStoryItem)


{-| initModel
Add components here
-}
initModel : EnvC -> StoryInit -> Model
initModel _ _ =
    initModel1


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
viewModel env model =
    let
        rend = [ renderBackground env model
               , renderMasking env model
               , renderStoryItem env model
               ]
    in
    Canvas.group
    []
    rend
