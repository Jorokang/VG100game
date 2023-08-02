module Scenes.Hall.SceneInit exposing
    ( nullHallInit
    , HallInit
    , initCommonData
    , initHallLoose
    , initHallWin
    )

{-| SceneInit

@docs nullHallInit
@docs HallInit
@docs initCommonData
@docs initHallLoose
@docs initHallWin

-}

import Lib.Env.Env exposing (Env)
import Scenes.Hall.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias HallInit =
    { status : Int
    , level_id : Int
    }


{-| HallInit data
-}
levelHallInit : Int -> HallInit
levelHallInit level =
    { status = 1
    , level_id = level
    }


{-| Initialize null hall
-}
nullHallInit : HallInit
nullHallInit =
    { status = -1
    , level_id = -1
    }


{-| Initialize loose hall
-}
initHallLoose : HallInit
initHallLoose =
    { status = 0
    , level_id = -1
    }


{-| Initialize win hall
-}
initHallWin : HallInit
initHallWin =
    { status = 1
    , level_id = -1
    }


{-| Initialize common data
-}
initCommonData : Env -> HallInit -> CommonData
initCommonData _ _ =
    nullCommonData
