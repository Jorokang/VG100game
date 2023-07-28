module Scenes.Hall.MainLayer.Update exposing (..)

import Lib.Coordinate.Coordinates exposing (judgeMouseRect)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Hall.MainLayer.Common exposing (Button, ButtonStatus(..), Choice(..), EnvC, HallStatus(..), Hallname(..), Levelbtn, Model)


{-| for a button
to check if one btn clicked
-}
ifClicked : Button -> ( Float, Float ) -> Bool
ifClicked btn ( a, b ) =
    if btn.status == ButtonActive then
        judgeMouseRect ( a, b ) btn.pos btn.size

    else
        False


{-| in five choices
check which choice part should be opened
-}
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


{-| in 5 choices
change the state of button
-}
buttonInact : Button -> Button
buttonInact btn =
    { btn | status = ButtonInactive }


buttonAct : Button -> Button
buttonAct btn =
    { btn | status = ButtonActive }


{-| in five choices
change the Hallstate of model
-}
hallState : Choice -> Model -> Model
hallState c model =
    { model | choice = c }


{-| in level choices
when button ok is pressed, change the scene from hall to Level
-}
levelokclicked : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
levelokclicked env model =
    if List.length model.selected_cards < 5 then
        ( { model | hint = True }, [], env )

    else
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
        , [ ( LayerParentScene, LayerGoToLevel ("Level" ++ String.fromInt num) model.selected_cards ) ]
        , env
        )


{-| in level choices
change the level num by up and down
-}
upclicked : Levelbtn -> Levelbtn
upclicked lev =
    let
        num =
            lev.levelInt + 1
    in
    { lev | levelInt = num }


downclicked : Levelbtn -> Levelbtn
downclicked lev =
    let
        num =
            lev.levelInt - 1
    in
    { lev | levelInt = num }


{-| in level choices
check if up or down clicked
-}
checkupdown : Levelbtn -> ( Float, Float ) -> Levelbtn
checkupdown lev ( a, b ) =
    if lev.levelInt > 1 && lev.levelInt < 5 then
        if ifClicked lev.up ( a, b ) then
            upclicked lev

        else if ifClicked lev.down ( a, b ) then
            downclicked lev

        else
            lev

    else if lev.levelInt == 1 then
        if ifClicked lev.up ( a, b ) then
            upclicked lev

        else
            lev

    else if lev.levelInt == 5 then
        if ifClicked lev.down ( a, b ) then
            downclicked lev

        else
            lev

    else
        lev


{-| in five hall choices
change the logic here
-}
inlevel : EnvC -> Model -> ( Float, Float ) -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
inlevel env model ( a, b ) =
    let
        lev =
            model.level
    in
    if ifClicked lev.close ( a, b ) then
        ( { model
            | choice = Hall
            , level =
                { lev
                    | open = buttonAct lev.open
                    , close = buttonInact lev.close
                    , up = buttonInact lev.up
                    , down = buttonInact lev.down
                    , ok = buttonInact lev.ok
                }
          }
        , []
        , env
        )

    else if ifClicked model.level.ok ( a, b ) then
        levelokclicked env model

    else
        ( { model | level = checkupdown lev ( a, b ) }, [], env )


inhelp : EnvC -> Model -> ( Float, Float ) -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
inhelp env model ( a, b ) =
    let
        help =
            model.help
    in
    if ifClicked help.close ( a, b ) then
        ( { model
            | choice = Hall
            , help =
                { help
                    | open = buttonAct help.open
                    , close = buttonInact help.close
                }
          }
        , []
        , env
        )

    else
        ( model, [], env )


incard : EnvC -> Model -> ( Float, Float ) -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
incard env model ( a, b ) =
    let
        card =
            model.card
    in
    if ifClicked card.close ( a, b ) then
        ( { model
            | choice = Hall
            , card =
                { card
                    | open = buttonAct card.open
                    , close = buttonInact card.close
                }
          }
        , []
        , env
        )

    else
        ( model, [], env )


insetting : EnvC -> Model -> ( Float, Float ) -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
insetting env model ( a, b ) =
    let
        set =
            model.setting
    in
    if ifClicked set.close ( a, b ) then
        ( { model
            | choice = Hall
            , setting =
                { set
                    | open = buttonAct set.open
                    , close = buttonInact set.close
                }
          }
        , []
        , env
        )

    else
        ( model, [], env )


inhall : EnvC -> Model -> ( Float, Float ) -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
inhall env model ( a, b ) =
    let
        lev =
            model.level

        set =
            model.setting

        help =
            model.help

        card =
            model.card
    in
    case checkopen model ( a, b ) of
        Level ->
            ( { model
                | choice = Level
                , level =
                    { lev
                        | open = buttonInact lev.open
                        , close = buttonAct lev.close
                        , up = buttonAct lev.up
                        , down = buttonAct lev.down
                        , ok = buttonAct lev.ok
                    }
              }
            , []
            , env
            )

        Help ->
            ( { model
                | choice = Help
                , help =
                    { help
                        | open = buttonInact help.open
                        , close = buttonAct help.close
                    }
              }
            , []
            , env
            )

        Card ->
            ( { model
                | choice = Card
                , card =
                    { card
                        | open = buttonInact card.open
                        , close = buttonAct card.close
                    }
              }
            , []
            , env
            )

        Setting ->
            ( { model
                | choice = Setting
                , setting =
                    { set
                        | open = buttonInact set.open
                        , close = buttonAct set.close
                    }
              }
            , []
            , env
            )

        Hall ->
            ( { model | choice = Hall }, [], env )


ifquit : EnvC -> Model -> ( Float, Float ) -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
ifquit env model ( a, b ) =
    if judgeMouseRect ( a, b ) ( 0, 0 ) ( 1900, 1620 ) then
        ( { model | choice = Hall, hall_name = Normal }, [], env )

    else
        ( model, [], env )
