module Component exposing (code)

import Colors exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font


code : List (Attribute msg) -> String -> Element msg
code attributes source =
    el
        (attributes
            ++ [ Background.color gray
               , Border.rounded 5
               , Font.color orange
               , Font.family
                    [ Font.external
                        { name = "Source Code Pro"
                        , url = "https://fonts.googleapis.com/css2?family=Source+Code+Pro&display=swap"
                        }
                    ]
               , padding 8
               ]
        )
    <|
        text source
