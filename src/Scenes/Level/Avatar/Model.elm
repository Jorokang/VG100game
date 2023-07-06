module Scenes.Level.Avatar.Model exposing
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
import Scenes.Level.Avatar.Common exposing (AvatarStatus(..), EnvC, Model, initAvatar1, nullModel)
import Scenes.Level.Avatar.Render exposing (renderAvatar, renderMovingHint, renderStr)
import Scenes.Level.Avatar.Update exposing (loc2Pos, setAvatarPos, setAvatarStill, updateModelActive, updateModelMoving, updateModelSelected)
import Scenes.Level.Frame.Functions exposing (addPoint, negPoint, scalePointLength)
import Scenes.Level.SceneInit exposing (LevelInit)
import String


{-| initModel
Add components here
-}
initModel : EnvC -> LevelInit -> Model
initModel _ _ =
    initAvatar1


{-| updateModel
Default update function

Add your logic to handle msg here

-}
updateModel : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env model =
    let
        n_model =
            setAvatarPos model
    in
    case model.status of
        AvatarAcitve ->
            updateModelActive env n_model

        AvatarSelected ->
            updateModelSelected env n_model

        AvatarMoving ->
            updateModelMoving env n_model

        _ ->
            ( n_model, [], env )


{-| updateModelRec
Default update function

Add your logic to handle LayerMsg here

-}
updateModelRec : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelRec env lmsg model =
    case lmsg of
        LayerMsgEnemyTurn ->
            ( { model | status = AvatarStopped }
                |> setAvatarStill
            , []
            , env
            )

        LayerMsgPlayerTurn ->
            ( { model | status = AvatarAcitve }
            , []
            , env
            )

        LayerIntMsg x ->
            case x of
                1 ->
                    ( { model | status = AvatarAcitve }
                    , []
                    , env
                    )

                0 ->
                    ( { model | status = AvatarStopped }
                        |> setAvatarStill
                    , []
                    , env
                    )

                _ ->
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
        str =
            case model.status of
                AvatarAcitve ->
                    "Active"

                AvatarInactive ->
                    "Inactive"

                AvatarMoving ->
                    "Moving"

                AvatarSelected ->
                    "Selevted"

                AvatarStopped ->
                    "Stopped"

        rend =
            [ renderAvatar env model
            , renderMovingHint env model
            , renderStr env ("Avatar status : " ++ str) ( 500, 400 )
            ]
    in
    case model.status of
        AvatarInactive ->
            Canvas.empty

        _ ->
            Canvas.group
                []
                rend
