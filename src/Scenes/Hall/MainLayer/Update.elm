module Scenes.Hall.MainLayer.Update exposing (..)

import Lib.Coordinate.Coordinates exposing (judgeMouseRect, posToReal)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Hall.MainLayer.Common exposing (Button, ButtonStatus(..), EnvC, HallStatus(..), Model, Choice(..))
import Scenes.Level.Frame.Functions exposing (coorChange, nullCoorData)

--to check if one btn clicked
ifClicked :  Button -> ( Float, Float ) -> Bool
ifClicked btn ( a, b ) =
    if btn.status == ButtonActive then
        judgeMouseRect ( a, b ) btn.pos btn.size
    else
        False

checkopen : Model -> ( Float, Float ) -> Choice
checkopen model ( a, b ) = 
    if ifClicked model.setting.open ( a, b) then 
        Setting
    else if ifClicked model.level.open ( a, b) then 
        Level
    else if ifClicked model.help.open ( a, b) then 
        Help
    else if ifClicked model.card.open ( a, b) then 
        Card
    else 
        Hall

--change the state of button
buttonInact : Button -> Button
buttonInact btn =
    { btn | status = ButtonInactive }


--change the scene to Level
buttonAct : Button -> Button
buttonAct btn =
    { btn | status = ButtonActive }

btn_1_clicked : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
btn_1_clicked env model =
    let
        btn =
            model.btn_1
    in
    case btn.status of
        ButtonInactive ->
            ( model, [], env )

        _ ->
            ( { model
                | status = Inactive
                , btn_1 =
                    { status = ButtonPressed
                    , pos = btn.pos
                    , size = btn.size
                    }
              }
            , [ ( LayerParentScene, LayerStringMsg "Level" ) ]
            , env
            )
