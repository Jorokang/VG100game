module Scenes.Teaching.MainLayer.Render exposing (..)

import Scenes.Level.Frame.Functions exposing (addLoc, addPoint, allGrids, cellLength, coorChange, coorChangeS, grid2real, lengthChange, lengthChangeS, mapCoorData, nullCoorData, shadowCoorData, sizeChangeS)
import Canvas exposing (Point, Renderable, circle, empty, rect, shapes, text)
import Canvas.Settings exposing (Setting, fill)
import Canvas.Settings.Advanced exposing (filter)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color, rgb255)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Teaching.MainLayer.Common exposing (EnvC, Model, nullModel)
import Lib.Render.Sprite exposing (renderSprite)
import Lib.Coordinate.Coordinates exposing (posToReal)
import Lib.Coordinate.Coordinates exposing (lengthToReal)

renderAvatar : EnvC -> Model -> Renderable
renderAvatar env model =
    let
        pos1 = model.pos

        pos2 =
            addPoint pos1 model.anima.a_pos

        pos3 =
            addPoint pos1 model.anima.p_pos

        cl =
            200

        rend1 =
            renderSprite env.globalData [] pos1 (cl, cl) "avatar"

        rend2 =
            renderSprite env.globalData [] pos3 (cl,cl) "pillow"
    in
    Canvas.group
        []
        [ rend1
        , rend2
        ]

renderShadow : EnvC -> Model -> Renderable
renderShadow env model =
    let
        ( bx, by ) =
            ( 100, 50 )

        ( dx, dy ) =
            ( 50, 50 )

        ( sx, sy ) =
            ( 720, 600 )

        lx = sx

        ly = sy

        ( px, py ) =
            model.pos

        colorb =
            Color.rgb255 20 30 40

        range =
            model.lightRange

        r1 = 170

        r2 = 180

        spos =
            ( px - range / 2 * r2, py - range / 2 * r2 )

        rend1 =
            Canvas.group
                []
                --[ shapes [ fill colorb ] [ rect (coorChange env ( bx, by ) shadowCoorData) (lengthChange env (max (px - r1 - bx) 0) shadowCoorData) ly ]
                [ shapes [ fill colorb ] [ rect (posToReal env.globalData (0,0)) (lengthToReal env.globalData (max (px - range / 2 * r1) 0)) ly ]
                , shapes [ fill colorb ] [ rect (posToReal env.globalData ( 0, 0 ) ) lx (lengthToReal env.globalData(max (py - range / 2 * r1) 0)) ]
                , shapes [ fill colorb ] [ rect (posToReal env.globalData ( px + range / 2 * r1, 0 )) (lengthToReal env.globalData (max (sx - px - range / 2 * r1) 0) ) ly ]
                , shapes [ fill colorb ] [ rect (posToReal env.globalData ( 0, py + range / 2 * r1 )) lx (lengthToReal env.globalData (max (sy - py - range / 2 * r1) 0) ) ]
                ]

        rend2 =
            renderSprite env.globalData [] spos ( range * r2, range * r2 ) "light_shade"

        --[ renderSprite env.globalData [] (0,0) (100,100) "light_shade"]
    in
    Canvas.group
        []
        [ rend1
        , rend2
        ]

renderSpirit : EnvC -> Model -> Renderable
renderSpirit env model =
    let
        max_box_color =
            Color.rgb255 25 25 112

        --dark blue
        label_pos =
            ( 500, 18 )

        ( box_x, box_y ) =
            ( 200, 25 )

        ( box_l, box_w ) =
            ( 600, 40 )

        ( spirit_x, spirit_y ) =
            addPoint ( box_x, box_y ) ( 15, 7 )

        ( spirit_max_l, spirit_w ) =
            addPoint ( box_l, box_w ) ( -30, -14 )

        spirit_l =
            spirit_max_l / model.spirit.max_spirit * model.spirit.cur_spirit

        spirit_color =
            Color.rgb255 255 240 245

        --LavenderBlush
        render_label =
            Canvas.group
                [ fill Color.white ]
                [ text [ font { size = 24, family = "Arial", style = "" }, align Center ] (coorChange env label_pos nullCoorData) "spirit" ]

        render_max_box =
            shapes
                [ fill max_box_color ]
                [ rect (coorChange env ( box_x, box_y ) nullCoorData) (lengthChange env box_l nullCoorData) (lengthChange env box_w nullCoorData) ]

        render_spirit =
            shapes
                [ fill spirit_color ]
                [ rect (coorChange env ( spirit_x, spirit_y ) nullCoorData) (lengthChange env spirit_l nullCoorData) (lengthChange env spirit_w nullCoorData) ]
    in
    Canvas.group
        []
        [ render_max_box
        , render_spirit
        , render_label
        ]