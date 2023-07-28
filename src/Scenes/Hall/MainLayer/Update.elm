module Scenes.Hall.MainLayer.Update exposing (..)

import Lib.Coordinate.Coordinates exposing (judgeMouseRect, posToReal)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Hall.MainLayer.Common exposing (Button, ButtonStatus(..), Choice(..), EnvC, HallStatus(..), Hallname(..), Levelbtn, Model)
import Scenes.Level.Frame.Functions exposing (coorChange, nullCoorData)


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
levelokclicked : EnvC -> Model -> ( Float, Float ) -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
levelokclicked env model ( a, b ) =
    let
        lev =
            model.level
    in
    if ifClicked lev.level1 ( a, b ) then
        ( model, [ ( LayerParentScene, LayerStringMsg "Level1" ) ], env )

    else if ifClicked lev.level2 ( a, b ) then
        ( model, [ ( LayerParentScene, LayerStringMsg "Level2" ) ], env )

    else if ifClicked lev.level3 ( a, b ) then
        ( model, [ ( LayerParentScene, LayerStringMsg "Level3" ) ], env )

    else if ifClicked lev.level4 ( a, b ) then
        ( model, [ ( LayerParentScene, LayerStringMsg "Level4" ) ], env )

    else
        ( model, [], env )


{-| in setting choices
when button up or down is pressed, change the volume by 10
-}
ifupdown : Model -> ( Float, Float ) -> Int
ifupdown model ( a, b ) =
    let
        set =
            model.setting

        num =
            set.volume
    in
    if ifClicked set.up ( a, b ) && num < 100 then
        num + 10

    else if ifClicked set.down ( a, b ) && num > 0 then
        num - 10

    else
        num


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
                    , level1 = buttonInact lev.level1
                    , level2 = buttonInact lev.level2
                    , level3 = buttonInact lev.level3
                    , level4 = buttonInact lev.level4
                }
          }
        , []
        , env
        )

    else
        levelokclicked env model ( a, b )


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
        ( { model
            | setting =
                { set
                    | volume = ifupdown model ( a, b )
                }
          }
        , []
        , env
        )


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
                        , level1 = buttonAct lev.level1
                        , level2 = buttonAct lev.level2
                        , level3 = buttonAct lev.level3
                        , level4 = buttonAct lev.level4
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
                        , up = buttonAct set.up
                        , down = buttonAct set.down
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
