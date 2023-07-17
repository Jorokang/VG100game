module Scenes.Level.Frame.Update exposing (..)

import Base exposing (GlobalData, Msg(..))
import Canvas exposing (Point)
import Lib.Env.Env exposing (Env)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Frame.Common exposing (EnvC, FrameStatus(..), Model, NextRoundButton, NextRoundButtonStatus(..))
import Scenes.Level.Frame.Functions exposing (addPoint, negPoint, nextRoundBCoorData, nullCoorData, pointDistance)


{-| swtich the turn
-}
switchTurn : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
switchTurn env model =
    case model.status of
        FramePlayerTurn ->
            ( { model | status = FrameEnemyTurn }
            , [ ( LayerName "Enemy", LayerMsgEnemyTurn )
              , ( LayerName "Avatar", LayerMsgEnemyTurn )
              , ( LayerName "Card", LayerMsgEnemyTurn )
              ]
            , env
            )

        FrameEnemyTurn ->
            ( { model | status = FramePlayerTurn }
                |> restorePlayerStamina
            , [ ( LayerName "Enemy", LayerMsgPlayerTurn )
              , ( LayerName "Avatar", LayerMsgPlayerTurn )
              , ( LayerName "Grids", LayerMsgPlayerTurn )
              , ( LayerName "Card", LayerMsgPlayerTurn )
              ]
            , env
            )

        FrameStopped ->
            ( { model | status = FramePlayerTurn }
                |> restorePlayerStamina
            , [ ( LayerName "Enemy", LayerMsgPlayerTurn )
              , ( LayerName "Avatar", LayerMsgPlayerTurn )
              , ( LayerName "Card", LayerMsgPlayerTurn )
              ]
            , env
            )

        _ ->
            ( model, [], env )


{-| check whether the erode target is valid
-}
checkErodePermission : EnvC -> Model -> ( Int, Int ) -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
checkErodePermission env model loc =
    ( model
    , [ ( LayerName "Grids", LayerMsgErodePermission loc 0 ) ]
    , env
    )


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



--The following functions are the determined values of the next_round_button


returnNRBV1 : Float
returnNRBV1 =
    5


returnNRBV2 : Float
returnNRBV2 =
    -5


rotateNRBV1 : Float
rotateNRBV1 =
    2


rotateNRBV2 : Float
rotateNRBV2 =
    -2


judgeMouseOnNRB : EnvC -> Model -> Bool
judgeMouseOnNRB env model =
    let
        btn =
            model.next_round_b

        mpos =
            addPoint env.globalData.mousePos nextRoundBCoorData.offset

        bl =
            btn.radius * btn.scale * nextRoundBCoorData.scale

        dis =
            pointDistance mpos btn.pos
    in
    dis <= bl


moveNRB : NextRoundButton -> NextRoundButton
moveNRB btn =
    case btn.status of
        NRBStable ->
            if btn.scale - btn.scale_v <= 1 then
                { btn | scale = 1 }

            else
                { btn | scale = btn.scale - btn.scale_v }

        NRBBig ->
            if btn.scale + btn.scale_v >= btn.max_scale then
                { btn | scale = btn.max_scale }

            else
                { btn | scale = btn.scale + btn.scale_v }

        NRBClicked ->
            { btn | scale = 1 }


{-| Update the state of the button
-}
updateTickNRB : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateTickNRB env model =
    let
        btn =
            model.next_round_b

        btn1 =
            if judgeMouseOnNRB env model then
                { btn | status = NRBBig }

            else
                { btn | status = NRBStable }
    in
    ( { model | next_round_b = moveNRB btn1 }
    , []
    , env
    )


updateMouseClickNRB : EnvC -> Model -> Point -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateMouseClickNRB env model click_pos =
    let
        btn =
            model.next_round_b

        mpos =
            addPoint click_pos nextRoundBCoorData.offset

        bl =
            btn.radius * btn.scale * nextRoundBCoorData.scale

        dis =
            pointDistance mpos btn.pos

        clicked_btn =
            { btn | status = NRBClicked }
    in
    if dis <= bl then
        { model | next_round_b = clicked_btn }
            |> switchTurn env

    else
        ( model, [], env )
