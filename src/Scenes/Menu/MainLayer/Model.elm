module Scenes.Menu.MainLayer.Model exposing
    ( initModel
    , updateModel, updateModelRec
    , viewModel
    )

{-| Model module

@docs initModel
@docs updateModel, updateModelRec
@docs viewModel

-}

import Base exposing (Msg(..))
import Canvas exposing (Renderable, empty, rect, shapes, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (filter)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Color
import Lib.Coordinate.Coordinates exposing (lengthToReal, posToReal)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Render.Sprite exposing (renderSprite)
import Scenes.Level.Frame.Functions exposing (coorChange, lengthChange, nullCoorData)
import Scenes.Menu.MainLayer.Common exposing (EnvC, Model, nullModel)
import Scenes.Menu.SceneInit exposing (MenuInit)
import String
import Time exposing (posixToMillis)


{-| initModel
Add components here
-}
initModel : EnvC -> MenuInit -> Model
initModel _ _ =
    nullModel


{-| updateModel
Default update function

Add your logic to handle msg here

-}
updateModel : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env model =
    case env.msg of
        Tick new_time ->
            judgeEnd env (updateTime model (posixToMillis new_time))

        KeyDown _ ->
            ( model, [ ( LayerName "MainLayer", LayerIntMsg 0 ) ], env )

        _ ->
            ( model, [], env )


updateTime : Model -> Int -> Model
updateTime model new_time =
    if model.time == -1 then
        { model | time = new_time, e_time = new_time + 6000 }

    else
        { model | time = new_time }


judgeEnd : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
judgeEnd env model =
    if (model.time > model.e_time) && model.active == True then
        ( model, [ ( LayerName "MainLayer", LayerIntMsg 0 ) ], env )

    else
        ( model, [], env )


updateModelRec : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelRec env lmsg model =
    case lmsg of
        LayerIntMsg _ ->
            ( { model | active = False }
            , [ ( LayerParentScene, LayerStringMsg "Story" ) ]
            , env
            )

        _ ->
            ( model, [], env )


viewModel : EnvC -> Model -> Renderable
viewModel env model =
    let
        f =
            (6000 - toFloat (model.e_time - model.time)) / 6000

        f1 =
            if 0.4 < f && f < 0.6 then
                (0.4 - f) * 20

            else
                0

        f2 =
            if f <= 0.3 then
                1

            else if f < 0.6 then
                (0.6 - f) * 3.3

            else
                0

        f3 =
            if f < 0.2 then
                0

            else if f < 0.4 then
                (f - 0.2) * 5

            else
                1

        str1 =
            "hue-rotate(" ++ String.fromInt (round (90 * f1)) ++ "deg)"

        str2 =
            "opacity(" ++ String.fromInt (round (100 * f2)) ++ "%)"

        str3 =
            if f < 0.4 then
                "saturate(" ++ String.fromInt (round (100 * f3)) ++ "%)"

            else
                "hue-rotate(" ++ String.fromInt (round (90 * f1)) ++ "deg)"

        rend_background =
            shapes
                [ fill Color.white ]
                [ rect (posToReal env.globalData ( 0, 0 )) (lengthToReal env.globalData 1920) (lengthToReal env.globalData 1080) ]

        rend_s =
            renderSprite env.globalData [ filter str3 ] ( 690, 270 ) ( 550, 380 ) "team_logo"

        rend_t0 =
            --text [ font { size = 96, family = "Comic Sans MS", style = "" }, align Center ] (posToReal env.globalData ( 965, 860 )) "Light in Nightmares"
            text [ font { size = round (lengthChange env 96 nullCoorData), family = "Comic Sans MS", style = "" }, align Left ] (coorChange env ( 965, 800 ) nullCoorData) "Light in Nightmares"

        rend_t =
            Canvas.group [ filter str2 ] [ rend_t0 ]
    in
    Canvas.group
        []
        [ rend_background
        , rend_s

        --, rend_masking
        , rend_t
        ]
