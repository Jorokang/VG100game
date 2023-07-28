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

import Canvas exposing (Renderable, empty, rect, text)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Text exposing (TextAlign(..), align, font)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Base exposing (Msg(..))
import Scenes.Menu.MainLayer.Common exposing (EnvC, Model, nullModel)
import Scenes.Menu.SceneInit exposing (MenuInit)
import Time exposing (posixToMillis)
import Canvas exposing (shapes)
import Lib.Coordinate.Coordinates exposing (posToReal)
import Lib.Coordinate.Coordinates exposing (lengthToReal)
import Color
import String
import Lib.Render.Sprite exposing (renderSprite)


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
            judgeEnd env (updateTime model (posixToMillis new_time) )
        KeyDown _ ->
            ( model, [(LayerName "MainLayer", LayerIntMsg 0)], env )            
        _ ->
            ( model, [], env )

updateTime : Model -> Int -> Model
updateTime model new_time =
    if (model.time == -1) then
        { model | time = new_time, e_time = new_time+model.e_time }
    else
        { model | time = new_time }

judgeEnd : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
judgeEnd env model =
    if (model.time > model.e_time) && model.active==True then
        ( model, [(LayerName "MainLayer", LayerIntMsg 0)], env )
    else
        (model, [], env)


updateModelRec : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelRec env lmsg model =
    case lmsg of
        LayerIntMsg _ ->
            ( {model|active = False}
            , [(LayerParentScene, LayerStringMsg "Story")]
            , env
            )
        _ ->
            ( model, [], env )

viewModel : EnvC -> Model -> Renderable
viewModel env model =
    let
        rend_background = 
            shapes
            [ fill Color.white ]
            [ rect (posToReal env.globalData (0,0)) (lengthToReal env.globalData 1920) (lengthToReal env.globalData 1080)]
        rend_s = 
            renderSprite env.globalData [] (550, 300) (687,475) "team_logo"

        rend_t =
            text [ font { size = 24, family = "Arial", style = "" }, align Center ] (posToReal env.globalData ( 500, 940 )) ((String.fromInt model.time) ++ ":" ++ (String.fromInt model.e_time))
    in
    Canvas.group
    []
    [ rend_background
    , rend_s
    --, rend_t
    ]
