module Scenes.Level.SceneInit exposing
    ( nullLevelInit
    , LevelInit
    , initCommonData
    , initLevel1, initLevel2, initLevel3, initLevel4
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
    , selected_cards : List Int
    , rand_num : Int
    }


nullLevelInit : LevelInit
nullLevelInit =
    { level_id = 0
    , selected_cards = []
    , rand_num = 0
    }


initLevel1 : List Int -> LevelInit
initLevel1 list =
    { level_id = 1
    , selected_cards = list
    , rand_num = 0
    }


initLevel2 : List Int -> LevelInit
initLevel2 list =
    { level_id = 2
    , selected_cards = list
    , rand_num = 0
    }


initLevel3 : List Int -> LevelInit
initLevel3 list =
    { level_id = 3
    , selected_cards = list
    , rand_num = 0
    }

initLevel4 : List Int -> LevelInit
initLevel4 list =
    { level_id = 4
    , selected_cards = list
    , rand_num = 0
    }

{-| Initialize common data
-}
initCommonData : Env -> LevelInit -> CommonData
initCommonData _ _ =
    nullCommonData
