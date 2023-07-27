module Scenes.Teaching.MainLayer.Model exposing
    ( initModel
    , updateModel, updateModelRec
    , viewModel
    )

{-| Model module

@docs initModel
@docs updateModel, updateModelRec
@docs viewModel

-}

import Canvas exposing (Renderable, empty, group)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Teaching.MainLayer.Common exposing (EnvC, Model, nullModel)
import Scenes.Teaching.SceneInit exposing (TeachingInit)
import Time exposing (posixToMillis)
import Scenes.Teaching.MainLayer.Render exposing (renderAvatar, renderShadow, renderSpirit)
import Scenes.Teaching.MainLayer.Update exposing (updateAnima, updateSpirit)
import Base exposing (Msg(..))


{-| initModel
Add components here
-}
initModel : EnvC -> TeachingInit -> Model
initModel _ _ =
    nullModel


{-| updateModel
Default update function

Add your logic to handle msg here

-}
updateModel : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env model =
    case env.msg of
        Tick new_time ->
            ( {model | time = posixToMillis new_time }
                |> updateAnima
                |> updateSpirit
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
        rend = [ renderAvatar env model
                , renderShadow env model
                , renderSpirit env model
                ]
    in
    Canvas.group
    []
    rend