module Scenes.Level.Card.Render exposing (renderCardInfo, renderDeckCards, renderDiscardCards, renderHandCards, renderTestMessage)

{-| Functions of rendering


# Functions

@docs renderCardInfo, renderDeckCards, renderDiscardCards, renderHandCards, renderTestMessage

-}

import Canvas exposing (Point, Renderable, text)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Lib.Coordinate.Coordinates exposing (lengthToReal, posToReal)
import Lib.Render.Sprite exposing (renderSprite)
import Lib.Render.Text exposing (renderText)
import Scenes.Level.Card.CardCreate exposing (Card, CardObject, CardStatus(..), Model, PileSize, giveBackPile, giveDeckSize, giveDiscardSize, giveErrorCard, giveHandSize, modifyPos)
import Scenes.Level.Card.CardUnique exposing (createPosList)
import Scenes.Level.Card.Common exposing (EnvC)
import Scenes.Level.Frame.Functions exposing (addPoint, coorChange, coorChangeS, lengthChange, nullCoorData, sizeChange, sizeChangeS)


renderStr : EnvC -> Point -> String -> Renderable
renderStr env pos str =
    text [ font { size = round (lengthChange env 24 nullCoorData), family = "Comic Sans MS", style = "" }, align Left ] (coorChange env pos nullCoorData) str



--renderText env.globalData 24 str "Comic Sans MS" (posToReal env.globalData pos)


renderBulletinBoard : EnvC -> Model -> Renderable
renderBulletinBoard env _ =
    renderSprite env.globalData [] (coorChangeS env ( 1000, 180 ) nullCoorData) (sizeChangeS env ( 440, 460 ) nullCoorData) "bulletin_board"


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
    , "gain 5 points of spirit power and have an additional move stage in next turn"
    , "delete a row or a column beside you"
    ]


giveInfoList1 : List String
giveInfoList1 =
    [ "purify two grids in a direction"
    , "protect a grid in all four"
    , "skip your next turn"
    , "make the range of light bigger"
    , "draw two cards from your deck"
    , "recall the emotion of the eight grids around you"
    , "draw three cards from your deck"
    , "purify the eight grids around you"
    , "summon a table light for two turns"
    , "gain 5 points of spirit power"
    , "delete a row or a column beside you"
    ]


giveInfoList2 : List String
giveInfoList2 =
    [ ""
    , "directions for two turns"
    , "gain 8 points of spirit energy"
    , ""
    , ""
    , ""
    , ""
    , ""
    , "he will pure the grid he pass"
    , "have an additional move stage in next turn"
    , ""
    ]


renderCardInfo : EnvC -> Model -> Renderable
renderCardInfo env model =
    let
        ( name, info1, cost ) =
            if model.selected_pos == -1 then
                ( "", "", "" )

            else
                ( model.selected_card.name
                , Maybe.withDefault "" <|
                    List.head <|
                        List.drop (model.selected_card.id - 1) giveInfoList1
                , String.fromInt model.selected_card.cost ++ " spirits"
                )

        info2 =
            if model.selected_pos == -1 then
                ""

            else
                Maybe.withDefault "" <|
                    List.head <|
                        List.drop (model.selected_card.id - 1) giveInfoList2
    in
    Canvas.group
        []
        [ renderStr env ( 1050, 280 ) ("Card name: " ++ name)
        , renderStr env ( 1050, 320 ) ("Cost: " ++ cost)
        , renderStr env ( 1180, 360 ) "Info: "
        , renderStr env ( 1050, 400 ) info1
        , renderStr env ( 1050, 440 ) info2
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

                CardMoving ->
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
        [ renderListCards env model.hand poss selecteds giveHandSize
        , renderStr env ( 500, 730 ) "Hand Cards"
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
        [ renderListCards env (giveBackPile model.deck) poss selecteds giveDeckSize
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
        [ renderListCards env (giveBackPile model.discard) poss selecteds giveDiscardSize
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


pileToStringo : List CardObject -> String
pileToStringo objs =
    let
        pile =
            List.map (\x -> x.card) objs
    in
    if List.length pile == 0 then
        " "

    else
        let
            card =
                Maybe.withDefault giveErrorCard (List.head pile)
        in
        ", " ++ card.name ++ String.fromInt card.cost ++ pileToString (List.drop 1 pile)


renderListCards : EnvC -> List Card -> List Point -> List Bool -> PileSize -> Renderable
renderListCards env cards poss selecteds size =
    Canvas.group
        []
        (List.map3 (renderOneCard env size) cards poss selecteds)


renderListCardso : EnvC -> List CardObject -> PileSize -> Renderable
renderListCardso env objs size =
    Canvas.group
        []
        (List.map (renderOneCardo env size) objs)


renderOneCard : EnvC -> PileSize -> Card -> Point -> Bool -> Renderable
renderOneCard env size card pos selected =
    let
        color =
            card.img

        width =
            size.width

        length =
            size.length

        offset =
            size.offset
    in
    if color == "cardback" then
        renderSprite env.globalData [] (coorChangeS env pos nullCoorData) (sizeChangeS env ( 4 * (width - 5), 4 * (length - 20) ) nullCoorData) "cardback"

    else if selected then
        renderSprite env.globalData [] (coorChangeS env (addPoint pos ( -offset, -offset )) nullCoorData) (sizeChangeS env ( width + 2 * offset, length + 2 * offset ) nullCoorData) color

    else
        renderSprite env.globalData [] (coorChangeS env pos nullCoorData) (sizeChangeS env ( width, length ) nullCoorData) color


renderOneCardo : EnvC -> PileSize -> CardObject -> Renderable
renderOneCardo env size obj =
    let
        card =
            obj.card

        pos =
            obj.pos

        selected =
            obj.selected

        color =
            obj.img

        width =
            size.width

        length =
            size.length

        offset =
            size.offset
    in
    if color == "cardback" then
        renderSprite env.globalData [] (coorChangeS env pos nullCoorData) (sizeChangeS env ( 4 * width, 4 * length ) nullCoorData) "cardback"

    else if selected then
        renderSprite env.globalData [] (coorChangeS env (addPoint pos ( -offset, -offset )) nullCoorData) (sizeChangeS env ( width + 2 * offset, length + 2 * offset ) nullCoorData) color

    else
        renderSprite env.globalData [] (coorChangeS env pos nullCoorData) (sizeChangeS env ( width, length ) nullCoorData) color
