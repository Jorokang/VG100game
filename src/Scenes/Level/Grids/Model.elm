module Scenes.Level.Grids.Model exposing
    ( initModel
    , updateModel, updateModelRec
    , viewModel
    )

{-| Model module

@docs initModel
@docs updateModel, updateModelRec
@docs viewModel

-}

import Canvas exposing (Renderable, empty)
import Base exposing (GlobalData, Msg(..))
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Scenes.Level.Grids.Common exposing (EnvC, Model, nullModel, initGrids1, PlotEffect(..))
import Scenes.Level.SceneInit exposing (LevelInit)
import Scenes.Level.Grids.Render exposing (renderGrids)
import Scenes.Level.Grids.Update exposing (modifyPlotEffect)


{-| initModel
Add components here
-}
initModel : EnvC -> LevelInit -> Model
initModel _ _ =
    initGrids1


{-| updateModel
Default update function

Add your logic to handle msg here

-}
updateModel : EnvC -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModel env model =
    case env.msg of
        KeyDown x ->    --modify the effect of (0,0) for testing
            case x of
                40 ->   --arrow down -> empty
                    (   modifyPlotEffect model (0,0) Empty
                    ,   []
                    ,   env
                    )
                37 ->   --arrow left -> angry
                    (   modifyPlotEffect model (0,0) Angry
                    ,   []
                    ,   env
                    )
                39 ->   --arrow right -> lazy
                    (   modifyPlotEffect model (0,0) Lazy
                    ,   []
                    ,   env
                    )
                _ ->
                    ( model, [], env )
        _ ->
            ( model, [], env )


{-| updateModelRec
Default update function

Add your logic to handle LayerMsg here

-}
updateModelRec : EnvC -> LayerMsg -> Model -> ( Model, List ( LayerTarget, LayerMsg ), EnvC )
updateModelRec env _ model =
    ( model, [], env )


viewModel : EnvC -> Model -> Renderable
viewModel env model =
    let
        rend =
            [
                renderGrids env model
            ]
    in
    Canvas.group
    []
    rend
