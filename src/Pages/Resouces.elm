module Pages.Resouces exposing (Model, Msg, layout, page)

import Browser.Navigation as Nav
import Effect exposing (Effect)
import Element exposing (..)
import Element.Region exposing (description)
import KeyListener
import Layout exposing (Layout)
import Logo
import Page exposing (Page)
import Route exposing (Route)
import Route.Path as Path
import Shared
import View exposing (Slide(..), View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


layout : Layout
layout =
    Layout.Navigation



-- INIT


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init () =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = NavigatePrevious
    | NavigateNext
    | DoNothing


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    let
        navigate to =
            to
                |> Path.toString
                |> Nav.load
                |> Effect.fromCmd
    in
    case msg of
        NavigatePrevious ->
            ( model, navigate Path.Architecture )

        NavigateNext ->
            ( model, navigate Path.End )

        DoNothing ->
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    KeyListener.subscription NavigatePrevious NavigateNext DoNothing



-- VIEW


view : Model -> View Msg
view model =
    { title = "ELM"
    , body =
        Slide
            { header = text "Resources"
            , body =
                viewLinks
            }
    , previous = Just NavigatePrevious
    , next = Just NavigateNext
    }


viewLinks : Element msg
viewLinks =
    let
        viewResource :
            { url : String
            , images :
                List
                    { imageUrl : String
                    , imageDescription : String
                    }
            , description : String
            }
            -> Element msg
        viewResource { url, images, description } =
            newTabLink []
                { url = url
                , label =
                    column [ width fill, spacing 5 ]
                        [ row [ width (fill |> maximum 250), spacing 5 ]
                            (images |> List.map viewImage)
                        , el [ centerX ] <| text description
                        ]
                }

        viewImage : { imageUrl : String, imageDescription : String } -> Element msg
        viewImage { imageUrl, imageDescription } =
            image [ width (fill |> maximum 250) ]
                { src = imageUrl
                , description = imageDescription
                }
    in
    column [ width fill, height fill, spacing 50 ]
        [ row [ width fill, spaceEvenly ]
            [ newTabLink []
                { url = "https://elm-lang.org/"
                , label =
                    column [ width fill, spacing 5 ]
                        [ Logo.elm []
                        , el [ centerX ] <| text "Elm Lang"
                        ]
                }
            , viewResource
                { url = "https://elmcraft.org/"
                , images =
                    [ { imageUrl = "/elmcraft-logo.png"
                      , imageDescription = "elmcraft logo"
                      }
                    ]
                , description = "Things built with elm: elmcraft.org"
                }
            , viewResource
                { url = "https://elm-radio.com/"
                , images =
                    [ { imageUrl = "/elm-radio-logo.svg"
                      , imageDescription = "elm-radio logo"
                      }
                    ]
                , description = "Podcast: elm-radio"
                }
            ]
        , row [ width fill, spaceEvenly ]
            [ viewResource
                { url = "https://elmprogramming.com/"
                , images =
                    [ { imageUrl = "elmprogramming-logo.png"
                      , imageDescription = "elmprogramming logo"
                      }
                    ]
                , description = "Tutorial: elmprogramming.com"
                }
            , viewResource
                { url = "https://elm-lang.org/community"
                , images =
                    [ { imageUrl = "slack-logo.svg"
                      , imageDescription = "slack logo"
                      }
                    , { imageUrl = "discord-logo.svg"
                      , imageDescription = "discord logo"
                      }
                    ]
                , description = "Community"
                }
            , viewResource
                { url = "https://exercism.org/tracks/elm"
                , images =
                    [ { imageUrl = "/exercism-logo.svg"
                      , imageDescription = "exercism logo"
                      }
                    ]
                , description = "Exercism"
                }
            ]
        ]
