module Scenes.Level.Card.Render exposing (..)

import Canvas exposing (Point, Renderable, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (white)
import Lib.Render.Sprite exposing (renderSprite)
import Scenes.Level.Card.CardCreate exposing (Card, PileSize, giveBackPile, giveDeckSize, giveDiscardSize, giveErrorCard, giveHandSize)
import Scenes.Level.Card.CardSystem exposing (takeCard)
import Scenes.Level.Card.Common exposing (CardStatus(..), EnvC, Model)
import Scenes.Level.Frame.Functions exposing (addPoint, coorChange, coorChangeS, lengthChange, nullCoorData, scalePoint, sizeChange, sizeChangeS)
import Tuple exposing (first)


renderStr : EnvC -> Point -> String -> Renderable
renderStr env pos str =
    text [ font { size = 24, family = "Arial", style = "" }, align Left ] (coorChange env pos nullCoorData) str


giveInfoList : List String
giveInfoList =
    [ "purify two grids in a direction"
    , "protect a grid in all four directions for two turn"
    , "skip your next turn and gain 8 points of spirit energy"
    , "make the range of light bigger"
    , "draw two cards from your deck"
    , "recall the emotion of the eight grids around you"
    , "draw three cards from your deck"
    , "purify the eight grids around you"
    , "summon a table light on your right for two turns and he will pure the grid he pass"
    , "gain 5 points of spirit power and have a additional move stage in next turn"
    , "delete a row or a column beside you"
    ]


renderCardInfo : EnvC -> Model -> Renderable
renderCardInfo env model =
    let
        ( name, info, cost ) =
            if model.selected_pos == -1 then
                ( "", "", "" )

            else
                ( model.selected_card.name
                , Maybe.withDefault "" <|
                    List.head <|
                        List.drop (model.selected_card.id - 1) giveInfoList
                , String.fromInt model.selected_card.cost ++ " spirits"
                )
    in
    Canvas.group
        []
        [ renderStr env (coorChange env ( 900, 250 ) nullCoorData) ("Card name: " ++ name)
        , renderStr env (coorChange env ( 900, 290 ) nullCoorData) ("Info: " ++ info)
        , renderStr env (coorChange env ( 900, 370 ) nullCoorData) ("Cost: " ++ cost)
        ]


renderTestMessage : EnvC -> Model -> Renderable
renderTestMessage env model =
    let
        str =
            case model.status of
                Active ->
                    "Active"

                Inactive ->
                    "Inactive"

                Moving ->
                    "Moving"

                Playing ->
                    "Playing"
    in
    Canvas.group
        []
        [ --renderStr env (coorChange env ( 200, 500 ) nullCoorData) ("click" ++ String.fromFloat (Tuple.first model.point) ++ ", " ++ String.fromFloat (Tuple.second model.point))
          renderStr env (coorChange env ( 200, 750 ) nullCoorData) ("hands:" ++ String.fromInt (List.length model.hand) ++ pileToString model.hand)
        , renderStr env (coorChange env ( 200, 770 ) nullCoorData) ("decks:" ++ String.fromInt (List.length model.deck) ++ pileToString model.deck)
        , renderStr env (coorChange env ( 200, 790 ) nullCoorData) ("piles:" ++ String.fromInt (List.length model.discard) ++ pileToString model.discard)
        , renderStr env (coorChange env ( 200, 810 ) nullCoorData) ("spirits:" ++ String.fromInt model.spirit)
        , renderStr env (coorChange env ( 200, 830 ) nullCoorData) ("turn_status:" ++ String.fromInt model.turn_status)
        , renderStr env (coorChange env ( 200, 850 ) nullCoorData) ("model_status:" ++ str)
        , renderStr env (coorChange env ( 200, 870 ) nullCoorData) ("selected:" ++ String.fromInt model.selected_pos ++ model.selected_card.name)
        , renderStr env (coorChange env ( 200, 890 ) nullCoorData) "Card System version: 0.3.3"
        ]


renderHelper : EnvC -> Model -> Int -> Int -> List Card -> PileSize -> Renderable
renderHelper env model index length pile size =
    let
        selected =
            if size.name == "hand" then
                model.selected_pos == index

            else
                False

        element =
            renderCard env (first (takeCard pile index)) index selected size
    in
    if index < length then
        Canvas.group
            []
            [ element, renderHelper env model (index + 1) length pile size ]

    else
        Canvas.group
            []
            [ element ]


renderHandCards : EnvC -> Model -> Renderable
renderHandCards env model =
    let
        length =
            List.length model.hand

        index =
            1
    in
    Canvas.group
        []
        [ renderHelper env model index length model.hand giveHandSize
        , text [ font { size = 40, family = "Arial", style = "" }, align Left ] (coorChange env ( 0, 700 ) nullCoorData) "Hand Cards"
        ]


renderDeckCards : EnvC -> Model -> Renderable
renderDeckCards env model =
    let
        length =
            List.length model.deck

        index =
            1
    in
    Canvas.group
        []
        [ renderHelper env model index length (giveBackPile model.deck) giveDeckSize
        , text [ font { size = 40, family = "Arial", style = "" }, align Left ] (coorChange env ( 850, 50 ) nullCoorData) "Deck Cards"
        ]


renderDiscardCards : EnvC -> Model -> Renderable
renderDiscardCards env model =
    let
        length =
            List.length model.discard

        index =
            1
    in
    Canvas.group
        []
        [ renderHelper env model index length (giveBackPile model.discard) giveDiscardSize
        , text [ font { size = 40, family = "Arial", style = "" }, align Left ] (coorChange env ( 850, 250 ) nullCoorData) "Deck Cards"
        ]


pileToString : List Card -> String
pileToString pile =
    if List.length pile == 0 then
        " "

    else
        let
            card =
                Maybe.withDefault giveErrorCard (List.head pile)
        in
        ", " ++ card.name ++ String.fromInt card.cost ++ pileToString (List.drop 1 pile)


renderOneCard : EnvC -> Card -> Point -> Bool -> Renderable
renderOneCard env card pos bool =
    let
        color =
            card.img

        width =
            giveHandSize.width

        length =
            giveHandSize.length

        offset =
            giveHandSize.offset
    in
    if bool then
        shapes
            [ fill color ]
            [ rect (coorChange env (addPoint pos ( -offset, -offset )) nullCoorData) (lengthChange env (width + 2 * offset) nullCoorData) (lengthChange env (length + 2 * offset) nullCoorData) ]

    else
        shapes
            [ fill color ]
            [ rect (coorChange env pos nullCoorData) (lengthChange env width nullCoorData) (lengthChange env length nullCoorData) ]


renderCard : EnvC -> Card -> Int -> Bool -> PileSize -> Renderable
renderCard env card num selected size =
    let
        color =
            card.img

        width =
            size.width

        length =
            size.length

        startPoint =
            size.startPoint

        offset =
            size.offset

        interval =
            size.interval
    in
    if color == white then
        renderSprite env.globalData [] (coorChangeS env (addPoint startPoint (scalePoint ( interval, 0 ) (toFloat num - 1))) nullCoorData) (sizeChangeS env ( 4 * width, 4 * length ) nullCoorData) "cardback"

    else if selected then
        shapes
            [ fill color ]
            [ rect (coorChange env (addPoint (addPoint ( -offset, -offset ) startPoint) (scalePoint ( interval, 0 ) (toFloat num - 1))) nullCoorData) (lengthChange env (width + 2 * offset) nullCoorData) (lengthChange env (length + 2 * offset) nullCoorData) ]

    else
        shapes
            [ fill color ]
            [ rect (coorChange env (addPoint startPoint (scalePoint ( interval, 0 ) (toFloat num - 1))) nullCoorData) (lengthChange env width nullCoorData) (lengthChange env length nullCoorData) ]
