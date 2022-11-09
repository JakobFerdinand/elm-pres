module Layouts.Navigation exposing (layout)

import Colors exposing (gray, lightgray)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Html.Attributes as Attr
import View exposing (View)


layout : { page : View msg } -> View msg
layout { page } =
    { title = page.title
    , body =
        el
            [ htmlAttribute <| Attr.class "page"
            , width fill
            , height fill
            , inFront <| overlay page.previous page.next
            ]
            page.body
    , previous = page.previous
    , next = page.next
    }


overlay : Maybe msg -> Maybe msg -> Element msg
overlay previous next =
    let
        button : Maybe msg -> String -> Element msg
        button nav t =
            case nav of
                Just n ->
                    buttonContent
                        [ mouseOver
                            [ Background.color gray
                            ]
                        , Border.rounded 5
                        , padding 8
                        , pointer
                        , Events.onClick n
                        ]
                        t

                Nothing ->
                    buttonContent [ Font.color gray ] t

        buttonContent : List (Attribute msg) -> String -> Element msg
        buttonContent attr t =
            el attr <| text t
    in
    el
        [ alignRight
        , alignBottom
        , padding 50
        ]
    <|
        row
            [ alignLeft
            , alignTop
            , spacing 20
            ]
            [ button previous "<"
            , button next ">"
            ]
