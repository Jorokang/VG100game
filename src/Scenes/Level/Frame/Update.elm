module Scenes.Level.Frame.Update exposing (addClearAnima, addSpiritAnima, checkErodePermission, costPlayerStamina, increaseStamina, switchTurn, updateAnima, updateMouseClickNRB, updateTickNRB)

{-| Update module


# Functions

@docs addClearAnima, addSpiritAnima, checkErodePermission, costPlayerStamina, increaseStamina, switchTurn, updateAnima, updateMouseClickNRB, updateTickNRB

-}

import Base exposing (GlobalData, Msg(..))
import Canvas exposing (Point)
import Lib.Env.Env exposing (Env)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Frame.Common exposing (ClearAnimation, EnvC, FrameStatus(..), Model, NextRoundButton, NextRoundButtonStatus(..))
import Scenes.Level.Frame.Functions exposing (addPoint, nextRoundBCoorData, pointDistance)


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
            if model.player_data.turns > 0 then
                { cur_stamina = mxs + model.player_data.add_stamina
                , max_stamina = mxs
                , add_stamina = model.player_data.add_stamina
                , turns = model.player_data.turns - 1
                }

            else
                { cur_stamina = mxs
                , max_stamina = mxs
                , add_stamina = 0
                , turns = 0
                }
    in
    { model | player_data = pd }


{-| Decrease players stamina
-}
costPlayerStamina : Model -> Model
costPlayerStamina model =
    { model
        | player_data =
            { cur_stamina = model.player_data.cur_stamina - 1
            , max_stamina = model.player_data.max_stamina
            , add_stamina = model.player_data.add_stamina
            , turns = model.player_data.turns
            }
    }


{-| Increase players stamina
-}
increaseStamina : Model -> Int -> Int -> Model
increaseStamina model n t =
    { model
        | player_data =
            { cur_stamina = model.player_data.cur_stamina
            , max_stamina = model.player_data.max_stamina
            , add_stamina = n
            , turns = t
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


{-| update the status of button
-}
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


{-| Clear animation
-}
addClearAnima : Model -> Point -> Model
addClearAnima model pos =
    let
        tmp_a =
            { pos = pos
            , i_time = model.time
            , e_time = model.time + 500
            }
    in
    { model | c_anima = tmp_a :: model.c_anima }


{-| Spirit animation
-}
addSpiritAnima : Model -> String -> Model
addSpiritAnima model str =
    let
        tmp_a =
            { str = str
            , i_time = model.time
            , e_time = model.time + 700
            }
    in
    { model | s_anima = tmp_a :: model.s_anima }


{-| Update animation
-}
updateAnima : Model -> Model
updateAnima model =
    { model
        | c_anima = List.filter (\x -> x.e_time > model.time) model.c_anima
        , s_anima = List.filter (\x -> x.e_time > model.time) model.s_anima
    }
