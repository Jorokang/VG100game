module Scenes.Level.Enemy.Model exposing
    ( initModel
    , updateModel, updateModelRec
    , viewModel
    )

{-| Model module

@docs initModel
@docs updateModel, updateModelRec
@docs viewModel

-}

import Canvas exposing (Renderable, empty, Point, group)
import Base exposing (GlobalData, Msg(..))
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Enemy.Common exposing (EnvC, Model, nullModel, initEnemy1, EnemyState(..))
import Scenes.Level.SceneInit exposing (LevelInit)
import Scenes.Level.Frame.Functions exposing (coorChange, point2Int)
import Time exposing (posixToMillis, utc)
import Canvas exposing (text)
import Scenes.Level.Enemy.Render exposing (renderEnemyBlock, renderNum, renderEnemyBody)
import Scenes.Level.Enemy.Random exposing (randomEnemy)
import Scenes.Level.Enemy.Update exposing (erodeRandomCell, erodeNearestCell)



{-| initModel
Add components here
-}
initModel : EnvC -> LevelInit -> Model
initModel _ _ =
    initEnemy1


{-| updateModel -}
updateModel : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env model =
    case env.msg of
        Tick newTime ->
            (   --{ model | time = Time.posixToMillis newTime }
                { model | time = Time.posixToMillis newTime }
                |> updateRandNum
            ,   []
            ,   env
            )
        KeyDown x ->
            ( erodeNearestCell model , [], env )
        _ ->
            ( model, [], env )

{-| update the random number in model -}
updateRandNum : Model -> Model
updateRandNum model =
    let
        ( randNum, seed ) =
            randomEnemy model.seed
    in
    { model |   randNum = randNum
            ,   seed = seed
    }

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
            [
                renderEnemyBody env model
            ]
    in
    group
    []
    rend

