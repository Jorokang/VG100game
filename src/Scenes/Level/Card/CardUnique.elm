module Scenes.Level.Card.CardUnique exposing (..)

import Canvas exposing (Point)
import Lib.Coordinate.Coordinates exposing (judgeMouseRect)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Card.CardSystem exposing (drawCard, dropCard, takeCard)
import Scenes.Level.Card.Common exposing (Card, EnvC, Model)
import Scenes.Level.Frame.Functions exposing (addPoint, scalePoint)
import Tuple exposing (first)


cardArea : EnvC -> Model -> List Point
cardArea env model =
    List.map pointHelper <|
        List.range 1 (List.length model.hand)


pointHelper : Int -> Point
pointHelper num =
    addPoint ( 0, 600 ) (scalePoint ( 100, 0 ) (toFloat num - 1))


clicked : Model -> List Point -> ( Bool, Int )
clicked model lp =
    if List.length lp == 0 then
        ( False, 0 )

    else
        let
            point =
                Maybe.withDefault ( -1, -1 ) (List.head lp)
        in
        if judgeMouseRect model.point point ( 80, 120 ) then
            ( True, 1 )

        else
            let
                ( bool, nindex ) =
                    clicked model (List.drop 1 lp)
            in
            ( bool, nindex + 1 )


clickDetect : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ) )
clickDetect env model =
    let
        ( bool, index ) =
            clicked model (cardArea env model)

        nmodel =
            { model | click_status = False }
    in
    if bool then
        playCard nmodel index

    else
        ( nmodel, [] )


playCard : Model -> Int -> ( Model, List ( LayerTarget, LayerMsg ) )
playCard model pos =
    let
        card =
            first (takeCard model.hand pos)

        nmodel =
            dropCard model pos
    in
    cardToEffect nmodel card


cardToEffect : Model -> Card -> ( Model, List ( LayerTarget, LayerMsg ) )
cardToEffect model card =
    case card.id of
        1 ->
            card_1 model

        2 ->
            card_2 model

        3 ->
            card_3 model

        4 ->
            card_4 model

        5 ->
            card_5 model

        6 ->
            card_6 model

        7 ->
            card_7 model

        8 ->
            card_8 model

        9 ->
            card_9 model

        10 ->
            card_10 model

        11 ->
            card_11 model

        _ ->
            ( model, [] )



{-
   W.I.P.
-}


card_1 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_1 model =
    ( model, [ ( LayerName "Enemy", LayerMsgClearCell ( 3, 3 ) ) ] )


card_2 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_2 model =
    ( drawCard model 2, [] )


card_3 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_3 model =
    ( model, [] )


card_4 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_4 model =
    ( model, [] )


card_5 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_5 model =
    ( model, [] )


card_6 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_6 model =
    ( model, [] )


card_7 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_7 model =
    ( model, [] )


card_8 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_8 model =
    ( model, [] )


card_9 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_9 model =
    ( model, [] )


card_10 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_10 model =
    ( model, [] )


card_11 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_11 model =
    ( model, [] )
