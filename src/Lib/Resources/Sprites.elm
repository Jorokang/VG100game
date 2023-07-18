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
    ]
