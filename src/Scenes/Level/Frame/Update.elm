module Scenes.Level.Frame.Update exposing (..)

import Base exposing (Msg(..), GlobalData)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Frame.Common exposing (EnvC, FrameStatus(..), Model, NextRoundButtonStatus(..), NextRoundButton)
import Scenes.Level.Frame.Functions exposing (nullCoorData, nextRoundBCoorData, pointDistance, addPoint, negPoint)
import Lib.Env.Env exposing (Env)


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
returnNRBV1 = 10

returnNRBV2 : Float
returnNRBV2 = -10

rotateNRBV1 : Float
rotateNRBV1 = 5

rotateNRBV2 : Float
rotateNRBV2 = -5

judgeMouseOnNRB : EnvC -> Model -> Bool
judgeMouseOnNRB env model =
    let
        btn = model.next_round_b
        mpos = addPoint env.globalData.mousePos nextRoundBCoorData.offset
        bl = (Tuple.first btn.size) / 2 * nextRoundBCoorData.scale
        bpos = addPoint btn.pos (bl,bl)
        dis = pointDistance mpos bpos
    in
    dis <= bl
    
rotateNRB_J : NextRoundButton -> NextRoundButton
rotateNRB_J btn =
    let
        (r1, v1) =  if (btn.b_rotation_1 + btn.b_angular_v_1 >= 360 || btn.b_rotation_1 == 0) then
                        (0, 0)
                    else
                        (btn.b_rotation_1 + btn.b_angular_v_1, btn.b_angular_v_1)
        (r2, v2) =  if (btn.b_rotation_2 + btn.b_angular_v_2 <= 0 || btn.b_rotation_2 == 0) then
                        (0, 0)
                    else
                        (btn.b_rotation_2 + btn.b_angular_v_2, btn.b_angular_v_2)
    in
    { btn | b_rotation_1 = r1
          , b_rotation_2 = r2
          , b_angular_v_1 = v1
          , b_angular_v_2 = v2
    }

rotateNRB : NextRoundButton -> NextRoundButton
rotateNRB btn =
    let
        t1 = btn.b_rotation_1 + btn.b_angular_v_1
        r1 =    if t1 >= 360 then
                    t1-360
                else
                    t1
        t2 = btn.b_rotation_2 + btn.b_angular_v_2
        r2 =    if t2 <= 0 then
                    t2+360
                else
                    t2
    in
    { btn | b_rotation_1 = t1
          , b_angular_v_1 = t2
    }

{-| Update the state of the button
-}
updateTickNRB : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateTickNRB env model =
    let
        btn = model.next_round_b
    in
    case btn.status of
        NRBStable ->
            let
                rotate_b = { btn | status = NRBRotating
                           , b_angular_v_1 = rotateNRBV1
                           , b_angular_v_2 = rotateNRBV2
                     }
                return_b = { btn | status = NRBReturning
                           , b_angular_v_1 = returnNRBV1
                           , b_angular_v_2 = returnNRBV2
                     }
            in
            if judgeMouseOnNRB env model then
                ( { model | next_round_b = rotate_b }
                , []
                , env
                )
            else
                ( { model | next_round_b = return_b }
                , []
                , env
                )

        NRBReturning ->
            let
                next_b = rotateNRB_J btn
                next_b2 = {next_b | status = NRBStable }
            in
            if next_b.b_rotation_1==0 && next_b.b_rotation_2==0 then
                ( { model | next_round_b = next_b2 }
                , []
                , env
                )
            else
                ( { model | next_round_b = next_b }
                , []
                , env
                )

        NRBRotating ->
            let
                rotate_b = rotateNRB btn
                return_b = { btn | status = NRBReturning
                           , b_angular_v_1 = returnNRBV1
                           , b_angular_v_2 = returnNRBV2
                     }
            in
            if judgeMouseOnNRB env model then
                ( { model | next_round_b = rotate_b }
                , []
                , env
                )
            else
                ( { model | next_round_b = return_b }
                , []
                , env
                )