module Scenes.Teaching.SceneInit exposing
    ( nullTeachingInit
    , TeachingInit
    , initCommonData
    )

{-| SceneInit

@docs nullTeachingInit
@docs TeachingInit
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.Teaching.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias TeachingInit =
    {}


{-| Null TeachingInit data
-}
nullTeachingInit : TeachingInit
nullTeachingInit =
    {}


{-| Initialize common data
-}
initCommonData : Env -> TeachingInit -> CommonData
initCommonData _ _ =
    nullCommonData
