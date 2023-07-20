module Scenes.Hall.MainLayer.Common exposing
    ( Model, nullModel, EnvC
    , Button, ButtonStatus(..), HallStatus(..), initModelLoose, initModelWin
    )

{-| Common module

@docs Model, nullModel, EnvC

-}

import Canvas exposing (Point)
import Lib.Env.Env as Env
import Scenes.Hall.LayerBase exposing (CommonData)


type HallStatus
    = Active
    | Stopped
    | Inactive


type ButtonStatus
    = ButtonActive
    | ButtonPressed
    | ButtonInactive


type alias Button =
    { status : ButtonStatus
    , pos : Point
    , size : Point
    , text : String
    }


{-| Model
Add your own data here.
-}
type alias Model =
    { status : HallStatus
    , btn_1 : Button
    , time : Int
    , click_pos : Point
    , hall_name : String
    }


initButtonLevel : Button
initButtonLevel =
    { status = ButtonActive
    , pos = ( 200, 200 )
    , size = ( 100, 50 )
    , text = "Level"
    }


nullModel : Model
nullModel =
    { status = Active
    , btn_1 = initButtonLevel
    , time = 0
    , click_pos = ( -1, -1 )
    , hall_name = "Hall"
    }


initModelWin : Model
initModelWin =
    { status = Active
    , btn_1 = initButtonLevel
    , time = 0
    , click_pos = ( -1, -1 )
    , hall_name = "You defeat the enemy in Level 1 !"
    }


initModelLoose : Model
initModelLoose =
    { status = Active
    , btn_1 = initButtonLevel
    , time = 0
    , click_pos = ( -1, -1 )
    , hall_name = "You lost all light."
    }


{-| Convenient type alias for the environment
-}
type alias EnvC =
    Env.EnvC CommonData
