module Scenes.Hall.MainLayer.Update exposing (..)

import Scenes.Hall.MainLayer.Common exposing (EnvC, Button, HallStatus(..), ButtonStatus(..), Model)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Coordinate.Coordinates exposing (judgeMouseRect)
import Scenes.Level.Frame.Functions exposing (point2Int)

mouseClickedState : EnvC -> Model -> ( Float, Float ) -> Int
mouseClickedState env model ( a,b ) =
    if (judgeMouseRect ( a, b ) ( model.btn_1.pos ) ( model.btn_1.size )) then
        1
    else
        0

btn_1_clicked : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
btn_1_clicked env model =
    let
        btn = model.btn_1
    in
    case btn.status of
        ButtonInactive ->
            ( model, [], env )
        _ ->
            ( { model   |   status = Inactive
                        , btn_1 =   {   status = ButtonPressed
                                    ,   pos = btn.pos
                                    ,   size = btn.size
                                    ,   text = btn.text
                                    }
                }
            , [ ( LayerParentScene, LayerStringMsg "Level" ) ]
            , env )