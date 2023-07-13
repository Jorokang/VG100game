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
import Scenes.Level.Frame.Render exposing (renderFrameStatus, renderStamina)
import Scenes.Level.Frame.Update exposing (costPlayerStamina, switchTurn, checkErodePermission)
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
updateModelRec env lmsg model =
    case lmsg of
        LayerIntMsg x ->
            --reduce 1 stamina
            case x of
                1 ->
                    --cost 1 stamina
                    if model.player_data.cur_stamina == 0 then
                        ( model
                        , [ ( LayerName "Avatar", LayerIntMsg 0 ) ]
                          --disable avatar
                        , env
                        )

                    else
                        ( model
                            |> costPlayerStamina
                        , []
                        , env
                        )

                _ ->
                    ( model, [], env )

        LayerMsgEnemyErodeCell loc ->
            ( model
            , [ ( LayerName "Avatar", LayerMsgErodeCell loc ) ]
            , env
            )

        LayerMsgClearCell loc ->
            ( model
            , [ ( LayerName "Avatar", LayerMsgClearCell loc )
              , ( LayerName "Enemy", LayerMsgClearCell loc )
              ]
            , env
            )

        LayerMsgErodePermission loc x ->
            checkErodePermission env model loc

        _ ->
            ( model, [], env )


viewModel : EnvC -> Model -> Renderable
viewModel env model =
    let
        rend =
            [ renderFrameStatus env model
            , renderStamina env model
            ]
    in
    Canvas.group
        []
        rend
