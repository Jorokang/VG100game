module Scenes.Level.SceneInit exposing
    ( nullLevelInit
    , LevelInit
    , initCommonData
    )

{-| SceneInit

@docs nullLevelInit
@docs LevelInit
@docs initCommonData

-}

import Lib.Env.Env exposing (Env)
import Scenes.Level.LayerBase exposing (CommonData, nullCommonData)


{-| Init Data
-}
type alias LevelInit =
    {}


{-| Null LevelInit data
-}
nullLevelInit : LevelInit
nullLevelInit =
    {}


{-| Initialize common data
-}
initCommonData : Env -> LevelInit -> CommonData
initCommonData _ _ =
    nullCommonData
