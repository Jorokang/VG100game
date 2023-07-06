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
import Scenes.Level.Avatar.Update exposing (loc2Pos, setAvatarPos, updateModelActive, updateModelMoving, updateModelSelected)
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
updateModelRec env _ model =
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
    Canvas.group
        []
        rend
