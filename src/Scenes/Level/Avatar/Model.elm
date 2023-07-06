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
import Scenes.Level.Avatar.Common exposing (EnvC, Model, nullModel, initAvatar1)
import Scenes.Level.Avatar.Render exposing (renderAvatar)
import Scenes.Level.SceneInit exposing (LevelInit)
import Scenes.Level.Avatar.Common exposing (AvatarStatus(..))
import Scenes.Level.Avatar.Update exposing (setAvatarPos, moveAvatar)


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
    case model.status of
        AvatarAcitve ->
            ( model
                |> setAvatarPos
                |> moveAvatar
            , []
            , env
            )
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
    let
        rend =
            [ renderAvatar env model ]
    in
    Canvas.group
        []
        rend
