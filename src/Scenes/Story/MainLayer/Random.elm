module Scenes.Story.MainLayer.Random exposing (randomValue)

import Random exposing (initialSeed)
import Scenes.Hall.MainLayer.Common exposing (EnvC)
import Time exposing (toMillis, utc)


{-| Give a random value
-}
randomValue : EnvC -> Int
randomValue env =
    let
        number =
            Random.int 0 1000
    in
    Tuple.first (Random.step number (initialSeed (toMillis utc env.globalData.currentTimeStamp)))
