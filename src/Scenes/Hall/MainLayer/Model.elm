module Scenes.Hall.MainLayer.Model exposing
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
import Canvas exposing (Renderable, empty)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Hall.MainLayer.Common exposing (Choice(..), EnvC, Model, initModelLose, initModelWin, nullModel)
import Scenes.Hall.MainLayer.Render exposing (renderBackground, renderButton, renderHall, renderMasking, renderStr, rendercard, renderhelp, renderlevel, rendersetting)
import Scenes.Hall.MainLayer.Update exposing (buttonAct, buttonInact, checkopen, checkupdown, ifClicked, levelokclicked)
import Scenes.Hall.SceneInit exposing (HallInit)
import Scenes.Level.Frame.Functions exposing (addPoint, coorChange, nullCoorData, point2Int)
import Set exposing (Set)
import Time exposing (posixToMillis)


{-| initModel
Add components here
-}
initModel : EnvC -> HallInit -> Model
initModel _ i =
    case i.status of
        0 ->
            initModelLose

        1 ->
            initModelWin

        _ ->
            nullModel


{-| updateModel
Default update function

Add your logic to handle msg here

-}



{- to do : about card choice -}
{- to do : card , help and setting -}


updateModel : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env model =
    case env.msg of
        Tick new_time ->
            ( { model | time = posixToMillis new_time }
            , []
            , env
            )

        MouseDown x ( a, b ) ->
            let
                n_model =
                    { model | click_pos = ( a, b ) }

                lev =
                    model.level

                set =
                    model.setting

                help =
                    model.help

                card =
                    model.card
            in
            case model.choice of
                Hall ->
                    case checkopen n_model ( a, b ) of
                        Level ->
                            ( { n_model
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
                            ( { n_model
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
                            ( { n_model
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
                            ( { n_model
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
                            ( { n_model | choice = Hall }, [], env )

                Level ->
                    if ifClicked model.level.close ( a, b ) then
                        ( { n_model
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

                Help ->
                    if ifClicked model.help.close ( a, b ) then
                        ( { n_model
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

                Card ->
                    if ifClicked model.card.close ( a, b ) then
                        ( { n_model
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

                Setting ->
                    if ifClicked model.setting.close ( a, b ) then
                        ( { n_model
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

        _ ->
            ( model, [], env )


{-| updateModelRec
Default update function

Add your logic to handle LayerMsg here

-}
updateModelRec : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelRec env _ model =
    case env.msg of
        Tick new_time ->
            ( { model | time = posixToMillis new_time }
            , []
            , env
            )

        MouseDown x ( a, b ) ->
            if ifClicked model.level.ok ( a, b ) then
                levelokclicked env model

            else
                ( model, [], env )

        _ ->
            ( model, [], env )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    let
        choice =
            case model.choice of
                Setting ->
                    rendersetting env model.setting

                Help ->
                    renderhelp env model.help

                Level ->
                    renderlevel env model.level

                Card ->
                    rendercard env model.card

                Hall ->
                    renderHall env model
    in
    Canvas.group
        []
        [ renderBackground env model
        , renderMasking env model
        , choice
        ]
