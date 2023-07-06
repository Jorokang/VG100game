module Scenes.Level.Frame.Update exposing (..)

import Base exposing (Msg(..))
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Frame.Common exposing (EnvC, FrameStatus(..), Model)


switchTurn : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
switchTurn env model =
    case model.status of
        FramePlayerTurn ->
            ( { model | status = FrameEnemyTurn }
            , [ ( LayerName "Enemy", LayerMsgEnemyTurn ), ( LayerName "Avatar", LayerMsgEnemyTurn ) ]
            , env
            )

        FrameEnemyTurn ->
            ( { model | status = FramePlayerTurn }
                |> restorePlayerStamina
            , [ ( LayerName "Enemy", LayerMsgPlayerTurn ), ( LayerName "Avatar", LayerMsgPlayerTurn ) ]
            , env
            )

        FrameStopped ->
            ( { model | status = FramePlayerTurn }
                |> restorePlayerStamina
            , [ ( LayerName "Enemy", LayerMsgPlayerTurn ), ( LayerName "Avatar", LayerMsgPlayerTurn ) ]
            , env
            )

        _ ->
            ( model, [], env )


restorePlayerStamina : Model -> Model
restorePlayerStamina model =
    let
        mxs =
            model.player_data.max_stamina

        pd =
            { cur_stamina = mxs
            , max_stamina = mxs
            }
    in
    { model | player_data = pd }


costPlayerStamina : Model -> Model
costPlayerStamina model =
    { model
        | player_data =
            { cur_stamina = model.player_data.cur_stamina - 1
            , max_stamina = model.player_data.max_stamina
            }
    }
