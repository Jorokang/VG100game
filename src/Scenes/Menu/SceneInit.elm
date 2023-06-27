module Scenes.Menu.SceneInit exposing
    ( nullMenuInit
    , MenuInit
    , initCommonData
    )

{-| SceneInit

@docs nullMenuInit
@docs MenuInit
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.Menu.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias MenuInit =
    {}


{-| Null MenuInit data
-}
nullMenuInit : MenuInit
nullMenuInit =
    {}


{-| Initialize common data
-}
initCommonData : Env -> MenuInit -> CommonData
initCommonData _ _ =
    nullCommonData
