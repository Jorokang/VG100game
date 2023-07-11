module Scenes.Level.Card.CardUnique exposing (..)

import Canvas exposing (Point)
import Lib.Coordinate.Coordinates exposing (judgeMouseRect)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Card.CardSystem exposing (drawCard, dropCard, takeCard)
import Scenes.Level.Card.Common exposing (Card, EnvC, Model)
import Scenes.Level.Card.Render exposing (cardArea)
import Tuple exposing (first)


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
            card1 model

        2 ->
            card2 model

        _ ->
            ( model, [] )



{-
   W.I.P.
-}


card1 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card1 model =
    ( model, [ ( LayerName "Avatar", LayerMsgClearCell ( 3, 3 ) ) ] )


card2 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card2 model =
    ( drawCard model 2, [] )


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
