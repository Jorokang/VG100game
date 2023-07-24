module Scenes.Level.SceneInit exposing
    ( nullLevelInit
    , LevelInit
    , initCommonData
    , initLevel1, initLevel2, initLevel3
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
    { level_id : Int
    }


nullLevelInit : LevelInit
nullLevelInit =
    { level_id = 0
    }


initLevel1 : LevelInit
initLevel1 =
    { level_id = 1
    }


initLevel2 : LevelInit
initLevel2 =
    { level_id = 2
    }


initLevel3 : LevelInit
initLevel3 =
    { level_id = 3
    }


{-| Initialize common data
-}
initCommonData : Env -> LevelInit -> CommonData
initCommonData _ _ =
    nullCommonData
