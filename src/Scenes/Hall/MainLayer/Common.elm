module Scenes.Hall.MainLayer.Common exposing (ButtonStatus(..), HallStatus(..), Model, Button, nullModel, EnvC)

{-| Common module

@docs Model, nullModel, EnvC

-}

import Lib.Env.Env as Env
import Scenes.Hall.LayerBase exposing (CommonData)
import Canvas exposing (Point)

type HallStatus
    =   Active
    |   Stopped
    |   Inactive

type ButtonStatus
    =   ButtonActive
    |   ButtonPressed
    |   ButtonInactive

type alias Button =
    {
        status : ButtonStatus
    ,   pos : Point
    ,   size : Point
    ,   text : String
    }

{-| Model
Add your own data here.
-}
type alias Model =
    {
        status : HallStatus
    ,   btn_1 : Button
    ,   time : Int
    }

initButtonLevel : Button
initButtonLevel =
    {
        status = ButtonActive
    ,   pos = ( 200, 200 )
    ,   size = ( 100, 50 )
    ,   text = "Level"
    }

nullModel : Model
nullModel =
    {
        status = Active
    ,   btn_1 = initButtonLevel
    ,   time = 0
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
