module Scenes.Hall.MainLayer.Render exposing (..)

import Canvas exposing (Point, Renderable, circle, empty, group, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (filter)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color)
import Lib.Render.Sprite exposing (renderSprite)
import List
import Scenes.Hall.MainLayer.Common exposing (Button, ButtonStatus(..), Cardbtn, EnvC, Helpbtn, Levelbtn, Model, Settingbtn, nullModel, Choice(..))
import Scenes.Level.Frame.Functions exposing (addPoint, coorChange, lengthChange, nullCoorData)
import Scenes.Level.Grids.Common exposing (GridsStatus(..))
import Lib.Coordinate.Coordinates exposing (posToReal, lengthToReal)

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
            ]
    in
    Canvas.group
        []
        rend



--to do: render a img


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



--render the different Hall parts


rendersetting : EnvC -> Settingbtn -> Renderable
rendersetting env set =
    let
        rend =
            [ renderButton env set.close
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
            [ renderButton env help.close
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
            [ renderButton env level.close
            , renderButton env level.up
            , renderButton env level.down
            , renderButton env level.ok
            , renderStr env (coorChange env ( 500, 700 ) nullCoorData) ("Level close")
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
            [ renderButton env card.close
            , text [ font { size = 48, family = "Arial", style = "" }, align Left ] (coorChange env card.close.pos nullCoorData) "card here"
            ]
    in
    Canvas.group
        []
        rend

{-let the background faded-}
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
