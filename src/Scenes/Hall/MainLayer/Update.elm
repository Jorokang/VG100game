module Scenes.Hall.MainLayer.Update exposing (..)

import Lib.Coordinate.Coordinates exposing (judgeMouseRect, posToReal)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Hall.MainLayer.Common exposing (Button, ButtonStatus(..), Choice(..), EnvC, HallStatus(..), Model)
import Scenes.Level.Frame.Functions exposing (coorChange, nullCoorData)
import Scenes.Hall.MainLayer.Common exposing (Levelbtn)



{-to check if one btn clicked-}


ifClicked : Button -> ( Float, Float ) -> Bool
ifClicked btn ( a, b ) =
    if btn.status == ButtonActive then
        judgeMouseRect ( a, b ) btn.pos btn.size

    else
        False



{-decide which part should be opened-}


checkopen : Model -> ( Float, Float ) -> Choice
checkopen model ( a, b ) =
    if model.choice == Hall then
        if ifClicked model.setting.open ( a, b ) then
            Setting

        else if ifClicked model.level.open ( a, b ) then
            Level

        else if ifClicked model.help.open ( a, b ) then
            Help

        else if ifClicked model.card.open ( a, b ) then
            Card

        else
            Hall

    else
        model.choice



--change the state of button


buttonInact : Button -> Button
buttonInact btn =
    { btn | status = ButtonInactive }


buttonAct : Button -> Button
buttonAct btn =
    { btn | status = ButtonActive }



--change the Hallstate of model


hallState : Choice -> Model -> Model
hallState c model =
    { model | choice = c }



--change the scene to Level


levelokclicked : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
levelokclicked env model =
    let
        lev =
            model.level

        num =
            lev.levelInt
    in
    ( { model
        | status = Inactive
        , level =
            { lev
                | open = buttonInact lev.open
                , close = buttonInact lev.close
                , up = buttonInact lev.up
                , down = buttonInact lev.down
                , ok = buttonInact lev.ok
            }
      }
    , [ ( LayerParentScene, LayerStringMsg ("Level" ++ String.fromInt num ) ) ]
    , env
    )


--change the level num
upclicked : Levelbtn -> Levelbtn
upclicked lev =
    let
        num = lev.levelInt + 1
    in
    {lev | levelInt = num }

downclicked : Levelbtn -> Levelbtn
downclicked lev =
    let
        num = lev.levelInt - 1
    in
    {lev | levelInt = num }


--check if up or down clicked
checkupdown : Levelbtn -> (Float , Float) -> Levelbtn
checkupdown lev (a , b) =
    if lev.levelInt > 1 && lev.levelInt < 4 then
        if ifClicked lev.up (a , b) then    
            upclicked lev
        else if ifClicked lev.down (a , b) then 
            downclicked lev
        else 
            lev
    else if lev.levelInt == 1 then
        if ifClicked lev.up (a , b) then    
            upclicked lev
        else 
            lev
    else if lev.levelInt == 4 then
        if ifClicked lev.down (a , b) then    
            downclicked lev
        else 
            lev
    else
        lev
