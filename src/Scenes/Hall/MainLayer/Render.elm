module Scenes.Hall.MainLayer.Render exposing (..)

import Canvas exposing (Point, Renderable, circle, empty, group, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (filter)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color)
import Lib.Coordinate.Coordinates exposing (judgeMouseRect, lengthToReal, posToReal)
import Lib.Render.Sprite exposing (renderSprite)
import List
import Scenes.Hall.MainLayer.CardSelect exposing (Card, createPosList, giveHandSize)
import Scenes.Hall.MainLayer.Common exposing (Button, ButtonStatus(..), Cardbtn, Choice(..), EnvC, Helpbtn, Levelbtn, Model, Settingbtn, nullModel)
import Scenes.Level.Card.CardCreate exposing (modifyPos)
import Scenes.Level.Frame.Functions exposing (addPoint, coorChange, coorChangeS, lengthChange, nullCoorData, scalePoint, sizeChangeS)
import Scenes.Level.Grids.Common exposing (GridsStatus(..))


{-| for the hall
render the background of hall
-}
renderBackground : EnvC -> Model -> Renderable
renderBackground env _ =
    let
        rend_sprite =
            renderSprite env.globalData [] ( 0, 0 ) ( 1920, 1080 ) "room_background_1"

        rend_masking =
            shapes
                [ filter "opacity(76%)"
                , fill (Color.rgb255 20 30 40)
                ]
                [ rect (coorChange env ( 0, 0 ) nullCoorData) (lengthChange env 1920 nullCoorData) (lengthChange env 1080 nullCoorData) ]
    in
    Canvas.group
        []
        [ rend_sprite
        , rend_masking
        ]


renderStr : EnvC -> Point -> String -> Renderable
renderStr env pos str =
    text [ font { size = 48, family = "Arial", style = "" }, align Left ] (coorChange env pos nullCoorData) str


{-| for the hall
render the hall with four buttons
-}
renderHall : EnvC -> Model -> Renderable
renderHall env model =
    let
        rend =
            [ renderSprite env.globalData [] (coorChangeS env model.card.open.pos nullCoorData) (sizeChangeS env ( 500, 700 ) nullCoorData) "cardback"
            , renderSprite env.globalData [] (coorChangeS env model.help.open.pos nullCoorData) (sizeChangeS env ( 200, 200 ) nullCoorData) "help"
            , renderSprite env.globalData [] (coorChangeS env model.setting.open.pos nullCoorData) (sizeChangeS env ( 200, 200 ) nullCoorData) "setting"
            , renderSprite env.globalData [] (coorChangeS env model.level.open.pos nullCoorData) (sizeChangeS env ( 400, 630 ) nullCoorData) "level"
            ]
    in
    Canvas.group
        []
        rend


{-| for a choice
render the close button
-}
renderclose : EnvC -> Button -> Renderable
renderclose env btn =
    let
        size =
            sizeChangeS env btn.size nullCoorData

        x =
            Tuple.first size

        y =
            Tuple.second size
    in
    Canvas.group
        []
        [ renderSprite env.globalData [] (coorChangeS env btn.pos nullCoorData) ( x, y ) "close"
        ]


{-| for the hall
render the four different Hall parts
-}
rendersetting : EnvC -> Settingbtn -> Renderable
rendersetting env set =
    let
        rend =
            [ renderclose env set.close
            , text [ font { size = 48, family = "Arial", style = "" }, align Left ] (coorChange env ( 100, 100 ) nullCoorData) "Setting:"
            ]
    in
    Canvas.group
        []
        rend


renderhelp : EnvC -> Helpbtn -> Renderable
renderhelp env help =
    let
        rend =
            [ renderclose env help.close
            , text [ font { size = 48, family = "Arial", style = "" }, align Left ] (coorChange env ( 100, 100 ) nullCoorData) "Help:"
            ]
    in
    Canvas.group
        []
        rend


renderlevel : EnvC -> Levelbtn -> Renderable
renderlevel env level =
    let
        rend =
            [ renderclose env level.close
            , renderSprite env.globalData [] (coorChangeS env level.down.pos nullCoorData) (sizeChangeS env level.down.size nullCoorData) "down"
            , renderSprite env.globalData [] (coorChangeS env level.up.pos nullCoorData) (sizeChangeS env level.up.size nullCoorData) "up"
            , renderSprite env.globalData [] (coorChangeS env level.ok.pos nullCoorData) (sizeChangeS env level.ok.size nullCoorData) "ok"
            , renderStr env (coorChange env ( 500, 1000 ) nullCoorData) ("Level : " ++ String.fromInt level.levelInt)
            ]
    in
    Canvas.group
        []
        rend


rendercard : EnvC -> Cardbtn -> Renderable
rendercard env card =
    let
        rend =
            [ renderclose env card.close
            , text [ font { size = 48, family = "Arial", style = "" }, align Left ] (coorChange env ( 100, 100 ) nullCoorData) "Select card:"
            ]
    in
    Canvas.group
        []
        rend


renderHandCards : EnvC -> Model -> Renderable
renderHandCards env model =
    let
        poss =
            createPosList model.hand giveHandSize

        temp =
            List.map (\_ -> False) poss

        selecteds =
            temp

        --modifyPos temp model.selected_pos True
    in
    Canvas.group
        []
        [ renderListCards env model.hand poss selecteds
        , text [ font { size = 40, family = "Arial", style = "" }, align Left ] (coorChange env ( 0, 700 ) nullCoorData) "Available Cards"
        ]


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


{-| for the hall
let the background faded when click a button
-}
renderMasking : EnvC -> Model -> Renderable
renderMasking env model =
    let
        masking =
            shapes
                [ fill Color.white
                , filter "opacity(66%)"
                ]
                [ rect (posToReal env.globalData ( 0, 0 )) (lengthToReal env.globalData 1920) (lengthToReal env.globalData 1080) ]
    in
    case model.choice of
        Hall ->
            Canvas.empty

        _ ->
            masking
