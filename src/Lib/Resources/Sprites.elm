module Lib.Resources.Sprites exposing (getResourcePath, allTexture)

{-|


# Textures

@docs getResourcePath, allTexture

-}


{-| Get the path of the resource.
-}
getResourcePath : String -> String
getResourcePath x =
    "assets/" ++ x


{-| allTexture

A list of all the textures.

Add your textures here. Don't worry if your list is too long. You can split those resources according to their usage.

Examples:

[
( "ball", getResourcePath "img/ball.png" ),
( "car", getResourcePath "img/car.jpg" )
][
( "ball", getResourcePath "img/ball.png" ),
( "car", getResourcePath "img/car.jpg" )
]

-}


allTexture : List ( String, String )
allTexture =
    [ ( "pattern_1", getResourcePath "img/pattern_1.png" )
    , ( "pattern_2", getResourcePath "img/pattern_2.png" )
    , ( "pattern_3", getResourcePath "img/pattern_3.png" )
    , ( "pattern_4", getResourcePath "img/pattern_4.png" )
    , ( "pattern_5", getResourcePath "img/pattern_5.png" )
    , ( "light_shade", getResourcePath "img/light_shade.png" )
    , ( "avatar", getResourcePath "img/avatar.png" )
    , ( "cardback", getResourcePath "img/cardback.svg" )
    , ( "room_background_1", getResourcePath "img/room_background_1.png" )
    , ( "family_painting_1", getResourcePath "img/family_painting_1.png" )
    , ( "family_painting_2", getResourcePath "img/family_painting_2.png" )
    , ( "button_hall", getResourcePath "img/button_hall.png" )
    , ( "trapped_effect", getResourcePath "img/trapped_effect.png" )
    , ( "scroll", getResourcePath "img/scroll.png" )
    , ( "pillow", getResourcePath "img/pillow.png" )
    , ( "e_1", getResourcePath "img/e_1.png" )
    , ( "e_2", getResourcePath "img/e_2.png" )
    , ( "e_3", getResourcePath "img/e_3.png" )
    , ( "e_4", getResourcePath "img/e_4.png" )
    , ( "e_5", getResourcePath "img/e_5.png" )
    , ( "e_6", getResourcePath "img/e_6.png" )
    , ( "e_7", getResourcePath "img/e_7.png" )
    , ( "e_8", getResourcePath "img/e_8.png" )
    , ( "e_9", getResourcePath "img/e_9.png" )
    , ( "e_10", getResourcePath "img/e_10.png" )
    , ( "e_11", getResourcePath "img/e_11.png" )
    , ( "e_12", getResourcePath "img/e_12.png" )
    , ( "candle_0", getResourcePath "img/candle_0.png" )
    , ( "candle_light_1", getResourcePath "img/candle_light_1.png" )
    , ( "candle_light_2", getResourcePath "img/candle_light_2.png" )
    , ( "candle_light_3", getResourcePath "img/candle_light_3.png" )
    , ( "candle_light_4", getResourcePath "img/candle_light_4.png" )
    , ( "candle_light_5", getResourcePath "img/candle_light_5.png" )
    , ( "candle_light_6", getResourcePath "img/candle_light_6.png" )
    , ( "candle_light_masking", getResourcePath "img/candle_light_masking.png" )
    , ( "help", getResourcePath "img/help.svg" )
    , ( "setting", getResourcePath "img/setting.svg" )
    , ( "close", getResourcePath "img/close.svg" )
    , ( "up", getResourcePath "img/up.svg" )
    , ( "down", getResourcePath "img/down.svg" )
    , ( "ok", getResourcePath "img/ok.svg" )
    , ( "level", getResourcePath "img/level.svg" )
    ]
