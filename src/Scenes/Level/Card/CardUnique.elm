module Scenes.Level.Card.CardUnique exposing (clickCard, costSpirit, createPosList)

{-| Functions of letting card into use


# Functions

@docs clickCard, costSpirit, createPosList

-}

import Canvas exposing (Point)
import Lib.Coordinate.Coordinates exposing (judgeMouseRect)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Card.CardCreate exposing (Card, Model, PileSize, giveErrorCard, giveHandSize)
import Scenes.Level.Card.CardSystem exposing (drawCard, takeCard)
import Scenes.Level.Frame.Functions exposing (addPoint, scalePoint)
import Tuple exposing (first)


{-| Create the positions of cards
-}
createPosList : List Card -> PileSize -> List Point
createPosList cards size =
    List.map (createPosListHelper size) <|
        List.range 1 (List.length cards)


createPosListHelper : PileSize -> Int -> Point
createPosListHelper size num =
    addPoint size.startPoint (scalePoint ( size.interval, 0 ) (toFloat num - 1))


handArea : Model -> List Point
handArea model =
    List.map handAreaHelper <|
        List.range 1 (List.length model.hand)


handAreaHelper : Int -> Point
handAreaHelper num =
    addPoint giveHandSize.startPoint (scalePoint ( giveHandSize.interval, 0 ) (toFloat num - 1))


clicked : Model -> List Point -> ( Bool, Int )
clicked model lp =
    if List.length lp == 0 then
        ( False, 0 )

    else
        let
            point =
                Maybe.withDefault ( -1, -1 ) (List.head lp)
        in
        if judgeMouseRect model.point point ( giveHandSize.width, giveHandSize.length ) then
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


{-| Send message to cost spirit
-}
costSpirit : Model -> List ( LayerTarget, LayerMsg )
costSpirit model =
    [ ( LayerName "Avatar", LayerMsgModifySpirit -model.selected_card.cost ) ]


enoughSpirit : Model -> Bool
enoughSpirit model =
    model.spirit > model.selected_card.cost


selected : Model -> Int -> Card -> Model
selected model pos card =
    { model | selected_card = card, selected_pos = pos }


notSelected : Model -> Model
notSelected model =
    { model | selected_card = giveErrorCard, selected_pos = -1 }


{-| Deal with click event
-}
clickCard : Model -> ( Model, List ( LayerTarget, LayerMsg ) )
clickCard model =
    let
        ( bool, index ) =
            clicked model (handArea model)

        nmodel =
            { model | click_status = False }

        card =
            first (takeCard model.hand index)
    in
    if bool then
        if nmodel.selected_pos == -1 then
            if index /= -1 then
                selectCard (selected nmodel index card) card

            else
                ( notSelected nmodel, [] )

        else if index == model.selected_pos then
            endCard nmodel card

        else if index /= -1 then
            selectCard (selected nmodel index card) card

        else
            ( notSelected nmodel, [] )

    else
        ( notSelected nmodel, [] )


selectCard : Model -> Card -> ( Model, List ( LayerTarget, LayerMsg ) )
selectCard model card =
    if enoughSpirit model then
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
                ( model, [ ( LayerName "Avatar", LayerMsgCardType 8 ) ] )

            9 ->
                ( model, [ ( LayerName "Avatar", LayerMsgCardType 9 ) ] )

            10 ->
                ( model, [] )

            11 ->
                ( model, [ ( LayerName "Avatar", LayerMsgCardType 11 ) ] )

            _ ->
                ( model, [] )

    else
        ( model, [] )


endCard : Model -> Card -> ( Model, List ( LayerTarget, LayerMsg ) )
endCard model card =
    if enoughSpirit model then
        case card.id of
            1 ->
                ( model, [] )

            2 ->
                ( model, [] )

            3 ->
                ( model, [ ( LayerName "Avatar", LayerMsgModifySpirit 8 ), ( LayerName "Card", LayerMsgCardType 3 ) ] )

            4 ->
                ( model, [ ( LayerName "Avatar", LayerMsgAvatarModifyLight 1 ), ( LayerName "Card", LayerMsgCardType 4 ) ] )

            5 ->
                ( drawCard model 2, [ ( LayerName "Card", LayerMsgCardType 5 ) ] )

            6 ->
                --( model, [ ( LayerName "Grids", LayerMsgRandomAround ) ] )
                ( model, [] )

            7 ->
                ( drawCard model 3, [ ( LayerName "Card", LayerMsgCardType 7 ) ] )

            8 ->
                ( model, [] )

            9 ->
                ( model, [] )

            10 ->
                ( model, [ ( LayerName "Avatar", LayerMsgModifySpirit 5 ), ( LayerName "Frame", LayerMsgIncreaseStamina 1 1 ), ( LayerName "Card", LayerMsgCardType 10 ) ] )

            11 ->
                ( model, [] )

            _ ->
                ( model, [] )

    else
        ( model, [] )
