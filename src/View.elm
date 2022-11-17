module View exposing
    ( View, map
    , none, fromString
    , toBrowserDocument
    , InfoBox, Slide(..)
    )

{-|

@docs View, map
@docs none, fromString
@docs toBrowserDocument

-}

import Browser
import Colors exposing (darkgray, lightgray)
import Component exposing (heading)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Time exposing (Month(..))


type alias InfoBox msg =
    { onMouseEnter : msg
    , onMouseLeave : msg
    , showInfoBox : Bool
    , infoBox : Element msg
    }


type alias View msg =
    { title : String
    , body : Slide msg
    , info : Maybe (InfoBox msg)
    , previous : Maybe msg
    , next : Maybe msg
    }


type Slide msg
    = Header (Element msg)
    | Slide
        { header : Element msg
        , body : Element msg
        }


{-| Used internally by Elm Land to create your application
so it works with Elm's expected `Browser.Document msg` type.
-}
toBrowserDocument : View msg -> Browser.Document msg
toBrowserDocument view =
    { title = view.title
    , body =
        [ layout
            [ width fill
            , height fill
            , padding 60
            , Background.color darkgray
            , Font.color lightgray
            , Font.family
                [ Font.external
                    { name = "Source Sans 3"
                    , url = "https://fonts.googleapis.com/css2?family=Source+Sans+3&display=swap"
                    }
                ]
            , Font.size 36
            , scrollbarY
            ]
          <|
            case view.body of
                Header header ->
                    header

                Slide { header, body } ->
                    column
                        [ spacing 50
                        , width fill
                        , height fill
                        , scrollbarY
                        ]
                        [ heading header
                        , body
                        ]
        ]
    }


{-| Used internally by Elm Land to wire up your pages together.
-}
map : (msg1 -> msg2) -> View msg1 -> View msg2
map fn view =
    { title = view.title
    , body =
        case view.body of
            Header header ->
                Header (Element.map fn header)

            Slide { header, body } ->
                Slide
                    { header = Element.map fn header
                    , body = Element.map fn body
                    }
    , info = view.info |> Maybe.map (mapInfoBox fn)
    , previous = view.previous |> Maybe.map fn
    , next = view.next |> Maybe.map fn
    }


mapInfoBox : (msg1 -> msg2) -> InfoBox msg1 -> InfoBox msg2
mapInfoBox fn infoBox =
    { onMouseEnter = fn infoBox.onMouseEnter
    , onMouseLeave = fn infoBox.onMouseLeave
    , showInfoBox = infoBox.showInfoBox
    , infoBox = infoBox.infoBox |> Element.map fn
    }


{-| Used internally by Elm Land whenever transitioning between
authenticated pages.
-}
none : View msg
none =
    { title = ""
    , body = Header <| Element.none
    , info = Nothing
    , next = Nothing
    , previous = Nothing
    }


{-| If you customize the `View` module, anytime you run `elm-land add page`,
the generated page will use this when adding your `view` function.

That way your app will compile after adding new pages, and you can see
the new page working in the web browser!

-}
fromString : String -> View msg
fromString moduleName =
    { title = moduleName
    , body = Header <| Element.text moduleName
    , info = Nothing
    , next = Nothing
    , previous = Nothing
    }
