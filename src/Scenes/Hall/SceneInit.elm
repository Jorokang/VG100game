module Scenes.Hall.SceneInit exposing
    ( nullHallInit
    , HallInit
    , initCommonData
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
    {}


{-| Null HallInit data
-}
nullHallInit : HallInit
nullHallInit =
    {}


{-| Initialize common data
-}
initCommonData : Env -> HallInit -> CommonData
initCommonData _ _ =
    nullCommonData
