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


updateSpirit : List ( LayerTarget, LayerMsg )
updateSpirit =
    [ ( LayerName "Avatar", LayerMsgModifySpirit 0 ) ]


costSpirit : Model -> List ( LayerTarget, LayerMsg )
costSpirit model =
    [ ( LayerName "Avatar", LayerMsgModifySpirit -model.selected_card.cost ) ]


enoughSpirit : Model -> Bool
enoughSpirit model =
    model.spirit > model.selected_card.cost


clickedPos : Model -> ( Bool, Int )
clickedPos model =
    clicked model (cardArea model)


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
            ( model, [ ( LayerName "Avatar", LayerMsgCardType 1 ) ] )

        2 ->
            ( model, [ ( LayerName "Avatar", LayerMsgCardType 2 ) ] )

        3 ->
            ( { model | turn_status = model.turn_status - 1, spirit = model.spirit + 8 }, [ ( LayerName "Avatar", LayerMsgModifySpirit 8 ), ( LayerName "Card", LayerMsgCardType 3 ) ] )

        4 ->
            ( model, [] )

        --( model, [ (  LayerName "Light", LayerMsgChangeLightRange 1 ) ] )
        5 ->
            ( drawCard model 2, [ ( LayerName "Card", LayerMsgCardType 5 ) ] )

        6 ->
            ( model, [] )

        --( model, [ ( LayerName "Grids", LayerMsgRandomAround ) ] )
        7 ->
            ( drawCard model 3, [ ( LayerName "Card", LayerMsgCardType 7 ) ] )

        8 ->
            ( model, [] )

        --( model, [ ( LayerName "Enemy", LayerMsgClearAround ) ] )
        9 ->
            ( model, [] )

        --( model, [ ( LayerName "Light", LayerMsgTableLight 2 ) ] )
        10 ->
            ( model, [] )

        --( { model | spirit = model.spirit + 5, status = Playing }, [ ( LayerName "Frame", LayerMsgChangeStamina -1] )
        11 ->
            ( model, [] )

        -- "-1" means Clear All
        --( model, [ ( LayerName "Enemy", LayerMsgClearDirection -1 ) ] )
        _ ->
            ( model, [] )


selectCard : Model -> Card -> ( Model, List ( LayerTarget, LayerMsg ) )
selectCard model card =
    case card.id of
        1 ->
            ( model, [ ( LayerName "Avatar", LayerMsgCardType 1 ) ] )

        2 ->
            ( model, [ ( LayerName "Avatar", LayerMsgCardType 2 ) ] )

        3 ->
            ( model, [] )

        4 ->
            ( model, [] )

        5 ->
            ( model, [] )

        6 ->
            ( model, [] )

        7 ->
            ( model, [] )

        8 ->
            ( model, [] )

        9 ->
            ( model, [] )

        10 ->
            ( model, [] )

        11 ->
            ( model, [] )

        _ ->
            ( model, [] )


endCard : Model -> Card -> ( Model, List ( LayerTarget, LayerMsg ) )
endCard model card =
    case card.id of
        1 ->
            ( model, [] )

        2 ->
            ( model, [] )

        3 ->
            ( { model | turn_status = model.turn_status - 1, spirit = model.spirit + 8 }, [ ( LayerName "Avatar", LayerMsgModifySpirit 8 ), ( LayerName "Card", LayerMsgCardType 3 ) ] )

        4 ->
            ( model, [] )

        --( model, [ (  LayerName "Light", LayerMsgChangeLightRange 1 ) ] )
        5 ->
            ( drawCard model 2, [ ( LayerName "Card", LayerMsgCardType 5 ) ] )

        6 ->
            ( model, [] )

        --( model, [ ( LayerName "Grids", LayerMsgRandomAround ) ] )
        7 ->
            ( drawCard model 3, [ ( LayerName "Card", LayerMsgCardType 7 ) ] )

        8 ->
            ( model, [] )

        --( model, [ ( LayerName "Enemy", LayerMsgClearAround ) ] )
        9 ->
            ( model, [] )

        --( model, [ ( LayerName "Light", LayerMsgTableLight 2 ) ] )
        10 ->
            ( model, [] )

        --( { model | spirit = model.spirit + 5, status = Playing }, [ ( LayerName "Frame", LayerMsgChangeStamina -1] )
        11 ->
            ( model, [] )

        -- "-1" means Clear All
        --( model, [ ( LayerName "Enemy", LayerMsgClearDirection -1 ) ] )
        _ ->
            ( model, [] )
