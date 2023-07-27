module Scenes.Teaching.MainLayer.Render exposing (..)

import Scenes.Level.Frame.Functions exposing (addLoc, addPoint, allGrids, cellLength, coorChange, coorChangeS, grid2real, lengthChange, lengthChangeS, mapCoorData, nullCoorData, shadowCoorData, sizeChangeS)
import Canvas exposing (Point, Renderable, circle, empty, rect, shapes, text)
import Canvas.Settings exposing (Setting, fill)
import Canvas.Settings.Advanced exposing (filter, shadow)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color exposing (Color, rgb255)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Teaching.MainLayer.Common exposing (EnvC, Model, nullModel)
import Lib.Render.Sprite exposing (renderSprite)
import Lib.Coordinate.Coordinates exposing (posToReal)
import Lib.Coordinate.Coordinates exposing (lengthToReal)
import List exposing (length)

renderBackgroud : EnvC -> Model -> Renderable
renderBackgroud env model =
    shapes
        [fill (Color.rgb255 20 30 40)]
        [rect (posToReal env.globalData (0,0)) (lengthToReal env.globalData 1920) (lengthToReal env.globalData 1080)]

renderAvatar : EnvC -> Model -> Renderable
renderAvatar env model =
    let
        pos1 = addPoint model.pos (-100,-100)

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

        rend3 =
            shapes
            [ fill Color.white ]
            [ rect (posToReal env.globalData (addPoint spos (10,10))) (lengthToReal env.globalData (range-0.1) * r2) (lengthToReal env.globalData  (range-0.1) * r2 ) ]

        rend2 =
            renderSprite env.globalData [] spos ( range * r2, range * r2 ) "light_shade"

        --[ renderSprite env.globalData [] (0,0) (100,100) "light_shade"]
    in
    Canvas.group
        []
        [ rend3
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

renderClick : EnvC -> Model -> Renderable
renderClick env model =
    let
        tf = modBy 2 (model.time // 100)
        siz =   if (tf==1) then 20
                    else 30
        c =     if (tf==1) then (Color.rgb255 255 240 240)
                    else (Color.rgb255 235 230 230)
        shadow1 = { blur = 0.5
                  , color = Color.black
                  , offset = (3,3)
                  }
        rend1 = 
            shapes
            [ fill c
            , shadow shadow1
            ]
            [circle (posToReal env.globalData (addPoint model.click_pos (25,25))) siz]
        rend2 =  text [ font { size = 32, family = "Arial", style = "" }, align Left ] (posToReal env.globalData model.click_pos) "CLICK"
    in
    Canvas.group
    []
    [ rend1
    , rend2
    ]

renderTextBoxTool : EnvC -> String -> Int -> Renderable
renderTextBoxTool env str d =
    text [ font { size = 32, family = "Arial", style = "" }, align Left ] (posToReal env.globalData (200, toFloat((d-1)*32+700))) str

renderTextBox : EnvC -> List String -> Renderable
renderTextBox env str =
    let
        rend_box = renderSprite env.globalData [] (20,600) (800, 400) "text_box"
        rend_text = List.map2 (renderTextBoxTool env) str (List.range 1 (List.length str))
    in
    Canvas.group
    []
    (rend_box::rend_text)
    

---------------------------------------------------------------------------------------render-status--------------------------------------------------------------------------------------------------------

renderInit : EnvC -> Model -> Renderable
renderInit env model =
    let
        s_name = text [ font { size = 32, family = "Arial", style = "" }, align Left ] (posToReal env.globalData (1000,30)) "Init"
        rend_t = renderTextBox env ["Genshin", "QiDong!"]
        rend = [ s_name
               , rend_t
               ]
    in
    Canvas.group
    []
    rend

renderMuttering1 : EnvC -> Model -> Renderable
renderMuttering1 env model =
    let
        s_name = text [ font { size = 32, family = "Arial", style = "" }, align Left ] (posToReal env.globalData (1000,30)) "Muttering1"
        rend = [s_name]
    in
    Canvas.group
    []
    rend

renderMuttering2 : EnvC -> Model -> Renderable
renderMuttering2 env model =
    let
        s_name = text [ font { size = 32, family = "Arial", style = "" }, align Left ] (posToReal env.globalData (1000,30)) "Muttering2"
        rend = [s_name]
    in
    Canvas.group
    []
    rend

renderEnemy1 : EnvC -> Model -> Renderable
renderEnemy1 env model =
    let
        s_name = text [ font { size = 32, family = "Arial", style = "" }, align Left ] (posToReal env.globalData (1000,30)) "Enemy1"
        rend_e = renderSprite env.globalData [] (0,300) (500, 400) "e_3"
        rend = [ rend_e
               , s_name
               ]
    in
    Canvas.group
    []
    rend

renderEnemy2 : EnvC -> Model -> Renderable
renderEnemy2 env model =
    let
        s_name = text [ font { size = 32, family = "Arial", style = "" }, align Left ] (posToReal env.globalData (1000,30)) "Enemy2"
        rend = [s_name]
    in
    Canvas.group
    []
    rend

renderHurt : EnvC -> Model -> Renderable
renderHurt env model =
    let
        s_name = text [ font { size = 32, family = "Arial", style = "" }, align Left ] (posToReal env.globalData (1000,30)) "Hurt"
        rend = [s_name]
    in
    Canvas.group
    []
    rend

renderMuttering3 : EnvC -> Model -> Renderable
renderMuttering3 env model =
    let
        s_name = text [ font { size = 32, family = "Arial", style = "" }, align Left ] (posToReal env.globalData (1000,30)) "Muttering3"
        rend = [s_name]
    in
    Canvas.group
    []
    rend

renderCard1 : EnvC -> Model -> Renderable
renderCard1 env model =
    let
        s_name = text [ font { size = 32, family = "Arial", style = "" }, align Left ] (posToReal env.globalData (1000,30)) "Card1"
        rend = [s_name]
    in
    Canvas.group
    []
    rend