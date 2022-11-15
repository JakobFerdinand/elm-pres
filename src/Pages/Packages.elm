module Pages.Packages exposing (Model, Msg, page)

import Colors exposing (..)
import Component exposing (imageLink)
import Effect exposing (Effect)
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import KeyListener
import Layout exposing (Layout)
import Navigation exposing (navigate)
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
    case msg of
        NavigatePrevious ->
            ( model, navigate Path.Resouces )

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
    { title = "My favourite packages"
    , body =
        Slide
            { header = text "My favourite packages"
            , body = viewLinks
            }
    , previous = Just NavigatePrevious
    , next = Just NavigateNext
    }


viewLinks : Element msg
viewLinks =
    let
        frameworkLink { url, logo, description } =
            newTabLink
                [ height (px 250)
                , width (px 370)
                , Border.color lightgray
                , Border.rounded 10
                , Border.width 2
                , padding 8
                ]
                { url = url
                , label =
                    column [ height fill, width fill ]
                        [ el
                            [ centerY
                            , centerX
                            , Font.size 36
                            , Font.bold
                            ]
                          <|
                            text logo
                        , el [ alignBottom, centerX ] <|
                            text description
                        ]
                }
    in
    column [ centerX, height fill, spacing 50 ]
        [ row [ width fill, spacing 100 ]
            [ frameworkLink
                { url = "https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/"
                , logo = "elm-ui"
                , description = "No more CSS"
                }
            , frameworkLink
                { url = "https://elm-pages.com/"
                , logo = "elm-pages"
                , description = "prerender everything"
                }
            ]
        , row [ centerX, spacing 100 ]
            [ imageLink
                { url = "https://elm.land/"
                , images =
                    [ { imageUrl = "/elm-land-logo.png"
                      , imageDescription = "elm-land logo"
                      }
                    ]
                , description = "SPA: elm-land"
                }
            , imageLink
                { url = "https://lamdera.com/"
                , images =
                    [ { imageUrl = "/lamdera-logo.png"
                      , imageDescription = "lamdera logao"
                      }
                    ]
                , description = "full-stack web apps"
                }
            ]
        ]
