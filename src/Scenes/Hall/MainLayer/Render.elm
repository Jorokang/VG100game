module Scenes.Hall.MainLayer.Render exposing (..)

import Canvas exposing (Point, Renderable, circle, empty, group, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (filter)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color)
import Lib.Coordinate.Coordinates exposing (lengthToReal, posToReal)
import Lib.Render.Sprite exposing (renderSprite)
import List
import Scenes.Hall.MainLayer.Common exposing (Button, ButtonStatus(..), Cardbtn, Choice(..), EnvC, Helpbtn, Levelbtn, Model, Settingbtn, nullModel)
import Scenes.Level.Frame.Functions exposing (addPoint, coorChange, coorChangeS, lengthChange, nullCoorData, sizeChangeS)
import Scenes.Level.Grids.Common exposing (GridsStatus(..))


{-| render the background of hall
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


renderHall : EnvC -> Model -> Renderable
renderHall env model =
    let
        rend =
            [ renderButton env model.setting.open
            , renderButton env model.level.open
            , renderButton env model.card.open
            , renderButton env model.help.open
            , renderSprite env.globalData [] (coorChangeS env model.help.open.pos nullCoorData) (sizeChangeS env ( 1000, 1000 ) nullCoorData) "help"
            , renderSprite env.globalData [] (coorChangeS env model.setting.open.pos nullCoorData) (sizeChangeS env ( 1000, 1000 ) nullCoorData) "setting"
            , renderSprite env.globalData [] (coorChangeS env model.level.open.pos nullCoorData) (sizeChangeS env ( 1000, 1000 ) nullCoorData) "level"
            ]
    in
    Canvas.group
        []
        rend



{- to do: render a img -}


renderclose : EnvC -> Button -> Renderable
renderclose env btn =
    Canvas.group
        []
        [ renderSprite env.globalData [] (coorChangeS env btn.pos nullCoorData) (sizeChangeS env btn.size nullCoorData) "close"
        ]


renderButton : EnvC -> Button -> Renderable
renderButton env btn =
    let
        ( sx, sy ) =
            btn.size

        text_pos =
            addPoint ( sx / 2, sy / 2 ) btn.pos
    in
    case btn.status of
        ButtonInactive ->
            Canvas.empty

        ButtonActive ->
            Canvas.group
                []
                [ text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env text_pos nullCoorData) "btnimg"
                ]


renderTime : EnvC -> Model -> Renderable
renderTime env model =
    renderStr env (coorChange env ( 200, 500 ) nullCoorData) ("Hall Time: " ++ String.fromInt model.time)



{- render the different Hall parts -}


rendersetting : EnvC -> Settingbtn -> Renderable
rendersetting env set =
    let
        rend =
            [ renderclose env set.close
            , text [ font { size = 48, family = "Arial", style = "" }, align Left ] (coorChange env set.close.pos nullCoorData) "setting here"
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
            , text [ font { size = 48, family = "Arial", style = "" }, align Left ] (coorChange env help.close.pos nullCoorData) "help here"
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
            , renderStr env (coorChange env ( 500, 700 ) nullCoorData) "Level close"
            , renderStr env (coorChange env ( 200, 500 ) nullCoorData) ("Level : " ++ String.fromInt level.levelInt)
            , text [ font { size = 48, family = "Arial", style = "" }, align Left ] (coorChange env level.close.pos nullCoorData) "level here"
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
            , text [ font { size = 48, family = "Arial", style = "" }, align Left ] (coorChange env card.close.pos nullCoorData) "card here"
            ]
    in
    Canvas.group
        []
        rend



{- let the background faded -}


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
