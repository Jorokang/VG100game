module Scenes.Level.Card.Model exposing
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
import Canvas exposing (Renderable)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Card.CardUnique exposing (clickDetect)
import Scenes.Level.Card.Common exposing (CardStatus(..), EnvC, Model, nullModel)
import Scenes.Level.Card.Render exposing (renderHandCards, renderTestMessage)
import Scenes.Level.SceneInit exposing (LevelInit)


{-| initModel
Add components here
-}
initModel : EnvC -> LevelInit -> Model
initModel _ _ =
    nullModel


{-| updateModel
Default update function

Add your logic to handle msg here

-}
updateModel env model =
    case model.status of
        Active ->
            let
                ( checked_model, msg ) =
                    if model.click_status then
                        clickDetect model

                    else
                        ( model, [] )
            in
            case env.msg of
                MouseDown _ ( a, b ) ->
                    ( { checked_model | point = ( a, b ), click_status = True }, msg, env )

                _ ->
                    ( checked_model, msg, env )

        _ ->
            ( model, [], env )


{-| updateModelRec
Default update function

Add your logic to handle LayerMsg here

-}
updateModelRec : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelRec env msg model =
    case msg of
        LayerMsgPlayerTurn ->
            ( { model | status = Active, turn_status = model.turn_status + 1 }, [], env )

        LayerMsgEnemyTurn ->
            if model.turn_status > 0 then
                ( { model | status = Inactive, turn_status = 0 }, [], env )

            else
                ( { model | status = Inactive }, [], env )

        _ ->
            ( model, [], env )


{-| viewModel
Default view function

If you don't have components, remove viewComponent.

If you have other elements than components, add them after viewComponent.

-}
viewModel : EnvC -> Model -> Renderable
viewModel env model =
    Canvas.group
        []
        [ renderHandCards env model
        , renderTestMessage env model
        ]
