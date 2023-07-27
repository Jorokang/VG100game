module Scenes.Level.Card.Render exposing (..)

import Canvas exposing (Point, Renderable, text)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Lib.Render.Sprite exposing (renderSprite)
import Scenes.Level.Card.CardCreate exposing (Card, CardStatus(..), Model, PileSize, giveBackPile, giveDeckSize, giveDiscardSize, giveErrorCard, giveHandSize, modifyPos)
import Scenes.Level.Card.CardUnique exposing (createPosList)
import Scenes.Level.Card.Common exposing (EnvC)
import Scenes.Level.Frame.Functions exposing (addPoint, coorChange, coorChangeS, nullCoorData, sizeChangeS)


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
        [ renderStr env (coorChange env ( 200, 830 ) nullCoorData) ("decks:" ++ String.fromInt (List.length model.deck) ++ pileToString model.deck)
        , renderStr env (coorChange env ( 200, 850 ) nullCoorData) ("spirits:" ++ String.fromInt model.spirit)
        , renderStr env (coorChange env ( 200, 870 ) nullCoorData) ("model_status:" ++ str)
        , renderStr env (coorChange env ( 200, 890 ) nullCoorData) "Card System version: 0.3.9"
        ]


renderHandCards : EnvC -> Model -> Renderable
renderHandCards env model =
    let
        poss =
            createPosList model.hand giveHandSize

        temp =
            List.map (\_ -> False) poss

        selecteds =
            modifyPos temp model.selected_pos True
    in
    Canvas.group
        []
        [ renderListCards env model.hand poss selecteds
        , text [ font { size = 40, family = "Arial", style = "" }, align Left ] (coorChange env ( 0, 700 ) nullCoorData) "Hand Cards"
        ]


renderDeckCards : EnvC -> Model -> Renderable
renderDeckCards env model =
    let
        poss =
            createPosList model.deck giveDeckSize

        selecteds =
            List.map (\_ -> False) poss
    in
    Canvas.group
        []
        [ renderListCards env (giveBackPile model.deck) poss selecteds
        , text [ font { size = 40, family = "Arial", style = "" }, align Left ] (coorChange env ( 850, 50 ) nullCoorData) "Deck Cards"
        ]


renderDiscardCards : EnvC -> Model -> Renderable
renderDiscardCards env model =
    let
        poss =
            createPosList model.discard giveDiscardSize

        selecteds =
            List.map (\_ -> False) poss
    in
    Canvas.group
        []
        [ renderListCards env (giveBackPile model.discard) poss selecteds
        , text [ font { size = 40, family = "Arial", style = "" }, align Left ] (coorChange env ( 850, 250 ) nullCoorData) "Discard Cards"
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


renderListCards : EnvC -> List Card -> List Point -> List Bool -> Renderable
renderListCards env cards poss selecteds =
    Canvas.group
        []
        (List.map3 (renderOneCard env) cards poss selecteds)


renderOneCard : EnvC -> Card -> Point -> Bool -> Renderable
renderOneCard env card pos selected =
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
    if color == "cardback" then
        renderSprite env.globalData [] (coorChangeS env pos nullCoorData) (sizeChangeS env ( 4 * width, 4 * length ) nullCoorData) "cardback"

    else if selected then
        renderSprite env.globalData [] (coorChangeS env (addPoint pos ( -offset, -offset )) nullCoorData) (sizeChangeS env ( width + 2 * offset, length + 2 * offset ) nullCoorData) color

    else
        renderSprite env.globalData [] (coorChangeS env pos nullCoorData) (sizeChangeS env ( width, length ) nullCoorData) color
