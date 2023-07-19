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
import Color
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Hall.MainLayer.Common exposing (EnvC, Model, initModelLose, initModelWin, nullModel, Choice(..))
import Scenes.Hall.MainLayer.Render exposing (renderButton, renderStr, renderTime)
import Scenes.Hall.MainLayer.Update exposing (btn_1_clicked, checkopen)
import Scenes.Hall.SceneInit exposing (HallInit)
import Scenes.Level.Frame.Functions exposing (addPoint, coorChange, nullCoorData, point2Int)
import Time exposing (posixToMillis)
import Set exposing (Set)
import Scenes.Hall.MainLayer.Render exposing (rendersetting, renderhelp, rendercard, renderlevel, renderButtons)



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
            case checkopen n_model ( a, b ) of
                Level ->
                    btn_1_clicked env n_model

                Help ->
                    btn_1_clicked env n_model

                Card ->
                    btn_1_clicked env n_model

                Setting ->
                    ( n_model, [], env )

                Hall ->
                    ( n_model, [], env )

        _ ->
            ( model, [], env )


{-| updateModelRec
Default update function

Add your logic to handle LayerMsg here

-}
updateModelRec : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelRec env _ model =
    ( model, [], env )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
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
            renderButtons env model
        
