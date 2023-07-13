module Scenes.Hall.SceneInit exposing
    ( nullHallInit
    , HallInit
    , initCommonData
    , initHallLoose, initHallWin
    )

{-| SceneInit

@docs nullHallInit
@docs HallInit
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.Hall.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias HallInit =
    {
        status : Int
    }


{-| HallInit data
-}
nullHallInit : HallInit
nullHallInit =
    {
        status = -1
    }

initHallLoose : HallInit
initHallLoose =
    {
        status = 0
    }

initHallWin : HallInit
initHallWin =
    {
        status = 1
    }


{-| Initialize common data
-}
initCommonData : Env -> HallInit -> CommonData
initCommonData _ _ =
    nullCommonData
