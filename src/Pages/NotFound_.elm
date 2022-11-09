module Pages.NotFound_ exposing (page)

import Colors exposing (lightgray)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import View exposing (View)


page : View msg
page =
    { title = "Not found"
    , body =
        column
            [ centerX
            , centerY
            , spacing 30
            ]
            [ column []
                [ el
                    [ Font.size 70
                    , centerX
                    , rotate <| degrees 90
                    ]
                  <|
                    text ":("
                , el [ centerX ] <| text "404 Not Found"
                ]
            , link
                [ centerX
                , padding 8
                , Border.rounded 5
                , mouseOver
                    [ Background.color lightgray
                    ]
                ]
                { url = "/"
                , label = text "Return Home"
                }
            ]
    , previous = Nothing
    , next = Nothing
    }
