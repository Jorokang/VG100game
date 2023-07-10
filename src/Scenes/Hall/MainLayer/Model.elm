module Scenes.Hall.MainLayer.Model exposing
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
import Canvas exposing (Renderable, empty)
import Color
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Hall.MainLayer.Common exposing (EnvC, Model, nullModel)
import Scenes.Hall.MainLayer.Render exposing (renderButtonPureColor, renderStr, renderTime)
import Scenes.Hall.MainLayer.Update exposing (btn_1_clicked, mouseClickedState)
import Scenes.Hall.SceneInit exposing (HallInit)
import Scenes.Level.Frame.Functions exposing (addPoint, coorChange, lengthChange, point2Int)
import Time exposing (posixToMillis)


{-| initModel
Add components here
-}
initModel : EnvC -> HallInit -> Model
initModel _ _ =
    nullModel


{-| updateModel
Default update function

Add your logic to handle msg here

-}
updateModel : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env model =
    case env.msg of
        Tick new_time ->
            ( { model | time = posixToMillis new_time }
            , []
            , env
            )

        KeyDown x ->
            ( model, [ ( LayerParentScene, LayerStringMsg "Level" ) ], env )

        MouseDown x ( a, b ) ->
            let
                n_model =
                    { model | click_pos = ( a, b ) }
            in
            case mouseClickedState env n_model ( a, b ) of
                1 ->
                    btn_1_clicked env n_model

                _ ->
                    ( n_model, [], env )

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
            [ renderStr env ( 200, 50 ) "HALL"
            , renderButtonPureColor env model.btn_1 Color.gray
            , renderStr env ( 200, 500 ) ("click" ++ String.fromFloat (Tuple.first model.click_pos) ++ ", " ++ String.fromFloat (Tuple.second model.click_pos))
            ]
    in
    Canvas.group
        []
        rend
