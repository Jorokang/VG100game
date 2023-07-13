module Scenes.Level.Card.CardUnique exposing (..)

import Canvas exposing (Point)
import Lib.Coordinate.Coordinates exposing (judgeMouseRect)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Card.CardCreate exposing (Card, giveErrorCard)
import Scenes.Level.Card.CardSystem exposing (drawCard, dropCard, takeCard)
import Scenes.Level.Card.Common exposing (CardStatus(..), EnvC, Model)
import Scenes.Level.Frame.Functions exposing (addPoint, scalePoint)
import Tuple exposing (first)


cardArea : Model -> List Point
cardArea model =
    List.map pointHelper <|
        List.range 1 (List.length model.hand)


pointHelper : Int -> Point
pointHelper num =
    addPoint ( 0, 725 ) (scalePoint ( 100, 0 ) (toFloat num - 1))


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


costSpirit : Model -> Model
costSpirit model =
    { model | spirit = model.spirit - model.selected_card.cost }


enoughSpirit : Model -> Bool
enoughSpirit model =
    model.spirit > model.selected_card.cost


clickDetect : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
clickDetect model =
    let
        ( bool, index ) =
            clicked model (cardArea model)

        nmodel =
            { model | click_status = False }

        card =
            first (takeCard model.hand index)
    in
    if bool then
        if nmodel.selected_pos == index && enoughSpirit model then
            playCard nmodel

        else
            ( { nmodel | selected_pos = index, selected_card = card }, [] )

    else
        ( { nmodel | selected_pos = -1, selected_card = giveErrorCard }, [] )


playCard : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
playCard model =
    let
        card =
            model.selected_card

        nmodel =
            costSpirit model

        nnmodel =
            { model | status = Playing }

        --{ nmodel | selected_pos = -1, selected_card = giveErrorCard }
    in
    if model.turn_status > 0 then
        cardToEffect nnmodel card

    else
        ( model, [] )


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
    ( model, [ ( LayerName "Avatar", LayerMsgCardType 1 ) ] )


card_2 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_2 model =
    ( model, [ ( LayerName "Avatar", LayerMsgCardType 2 ) ] )


card_3 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_3 model =
    ( { model | turn_status = model.turn_status - 1, spirit = model.spirit + 8 }, [ ( LayerName "Card", LayerMsgCardType 3 ) ] )


card_4 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_4 model =
    --( model, [ (  LayerName "Light", LayerMsgChangeLightRange 1 ) ] )
    ( model, [] )


card_5 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_5 model =
    ( drawCard model 2, [ ( LayerName "Card", LayerMsgCardType 5 ) ] )


card_6 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_6 model =
    --( model, [ ( LayerName "Grids", LayerMsgRandomAround ) ] )
    ( model, [] )


card_7 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_7 model =
    ( drawCard model 3, [ ( LayerName "Card", LayerMsgCardType 7 ) ] )


card_8 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_8 model =
    --( model, [ ( LayerName "Enemy", LayerMsgClearAround ) ] )
    ( model, [] )


card_9 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_9 model =
    --( model, [ ( LayerName "Light", LayerMsgTableLight 2 ) ] )
    ( model, [] )


card_10 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_10 model =
    --( { model | spirit = model.spirit + 5, status = Playing }, [ ( LayerName "Frame", LayerMsgChangeStamina -1] )
    ( { model | spirit = model.spirit + 5 }, [] )


card_11 : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
card_11 model =
    -- "-1" means Clear All
    --( model, [ ( LayerName "Enemy", LayerMsgClearDirection -1 ) ] )
    ( model, [] )
