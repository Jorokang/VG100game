module Scenes.Level.Frame.Model exposing
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
import Canvas exposing (Renderable, empty, group)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Frame.Common exposing (EnvC, FrameStatus(..), Model, initFrame1, nullModel)
import Scenes.Level.Frame.Render exposing (renderFrameStatus)
import Scenes.Level.Frame.Update exposing (switchTurn)
import Scenes.Level.SceneInit exposing (LevelInit)


{-| initModel
Add components here
-}
initModel : EnvC -> LevelInit -> Model
initModel _ _ =
    initFrame1


{-| updateModel
Default update function

Add your logic to handle msg here

-}
updateModel : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env model =
    case env.msg of
        KeyDown x ->
            case x of
                13 ->
                    --enter -> switch turn
                    switchTurn env model

                _ ->
                    ( model, [], env )

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
            [ renderFrameStatus env model
            ]
    in
    Canvas.group
        []
        rend
