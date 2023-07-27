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
import Scenes.Hall.MainLayer.Common exposing (Choice(..), EnvC, Hallname(..), Model, initModelLose, initModelWin, nullModel)
import Scenes.Hall.MainLayer.Render exposing (renderBackground, renderHall, renderHandCards, renderMasking, renderStr, rendercard, renderhelp, renderlevel, rendersetting)
import Scenes.Hall.MainLayer.Update exposing (ifClicked, ifquit, incard, inhall, inhelp, inlevel, insetting, levelokclicked)
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
            in
            case model.choice of
                Hall ->
                    case model.hall_name of
                        Normal ->
                            inhall env n_model ( a, b )

                        Win ->
                            ifquit env n_model ( a, b )

                        Lose ->
                            ifquit env n_model ( a, b )

                Level ->
                    inlevel env n_model ( a, b )

                Help ->
                    inhelp env n_model ( a, b )

                Card ->
                    incard env n_model ( a, b )

                Setting ->
                    insetting env n_model ( a, b )

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
                    renderHandCards env model

                Hall ->
                    case model.hall_name of
                        Normal ->
                            renderHall env model

                        Win ->
                            renderStr env ( 500, 500 ) "You Win the fight"

                        Lose ->
                            renderStr env ( 500, 500 ) "You lose all lights"
    in
    Canvas.group
        []
        [ renderBackground env model
        , renderMasking env model
        , choice
        ]
