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

import Base exposing (Msg(..))
import Canvas exposing (Renderable)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Story.MainLayer.Common exposing (EnvC, Model, StoryStatus(..), initModel0, initModel1, initModel2, initModel3)
import Scenes.Story.MainLayer.Render exposing (renderBackground, renderMasking, renderStoryItem)
import Scenes.Story.MainLayer.Update exposing (updateModelItems, updateModelItemsScale, updateModelRoom)
import Scenes.Story.SceneInit exposing (StoryInit)


{-| initModel
Add components here
-}
initModel : EnvC -> StoryInit -> Model
initModel _ i =
    case i.id of
        0 ->
            initModel3

        1 ->
            initModel1

        2 ->
            initModel2

        3 ->
            initModel3

        _ ->
            initModel0


{-| Only considering click events
-}
updateModel : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env model =
    case env.msg of
        MouseDown x m_pos ->
            case model.status of
                StoryRoom ->
                    updateModelRoom env model m_pos

                StoryFamilyPainting ->
                    updateModelItems env model m_pos

                StoryDiary ->
                    updateModelItems env model m_pos

                StorySun ->
                    updateModelItems env model m_pos

                StoryHall ->
                    ( model, [], env )

                StoryNull ->
                    ( model, [], env )

        Tick _ ->
            updateModelItemsScale env model

        _ ->
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
        rend =
            [ renderBackground env model
            , renderMasking env model
            , renderStoryItem env model
            ]
    in
    Canvas.group
        []
        rend
