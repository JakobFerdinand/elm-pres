module Pages.Overview exposing (Model, Msg, layout, page)

import Colors exposing (blue, green, orange)
import Effect exposing (Effect)
import Element exposing (..)
import Element.Font as Font
import Html.Attributes exposing (style)
import KeyListener
import Layout exposing (Layout)
import Logo
import Navigation exposing (navigate)
import Page exposing (Page)
import Route exposing (Route)
import Route.Path as Path exposing (Path(..))
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


type Model
    = Init Bool
    | WebFrameworks Bool


init : () -> ( Model, Effect Msg )
init () =
    ( Init False
    , Effect.none
    )



-- UPDATE


type Msg
    = NavigatePrevious
    | NavigateNext
    | DoNothing
    | MouseEnteredInfoBox
    | MouseLeftInfoBox


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case ( msg, model ) of
        ( NavigatePrevious, Init _ ) ->
            ( model, navigate Path.Home_ )

        ( NavigatePrevious, WebFrameworks _ ) ->
            ( Init False, Effect.none )

        ( NavigateNext, Init _ ) ->
            ( WebFrameworks False, Effect.none )

        ( NavigateNext, WebFrameworks _ ) ->
            ( model, navigate (Path.Language__Direction_ { direction = "forward" }) )

        ( MouseEnteredInfoBox, Init _ ) ->
            ( Init True, Effect.none )

        ( MouseLeftInfoBox, Init _ ) ->
            ( Init False, Effect.none )

        ( MouseEnteredInfoBox, WebFrameworks _ ) ->
            ( WebFrameworks True, Effect.none )

        ( MouseLeftInfoBox, WebFrameworks _ ) ->
            ( WebFrameworks False, Effect.none )

        ( DoNothing, _ ) ->
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
            { header = text "elm"
            , body =
                column [ spacing 20 ]
                    [ row [ moveLeft 25 ]
                        [ tangram
                        , column [ Font.size 44 ]
                            [ text "A delightful language"
                            , row []
                                [ text "for "
                                , el [ Font.color green ] <| text "reliable"
                                , text " webapps."
                                ]
                            ]
                        ]
                    , case model of
                        Init _ ->
                            viewOverview

                        WebFrameworks _ ->
                            viewFrameworks
                    ]
            }
    , info =
        Just
            { onMouseEnter = MouseEnteredInfoBox
            , onMouseLeave = MouseLeftInfoBox
            , showInfoBox =
                case model of
                    Init show ->
                        show

                    WebFrameworks show ->
                        show
            , infoBox =
                case model of
                    Init _ ->
                        viewOverviewInfo

                    WebFrameworks _ ->
                        viewFrameworksInfo
            }
    , previous = Just NavigatePrevious
    , next = Just NavigateNext
    }


tangram : Element msg
tangram =
    Logo.view
        "-350 -350 700 700"
        [ style "max-height" "500px"
        , style "max-width" "500px"
        ]
        Logo.start
        |> html
        |> el [ width (px 400), height (px 400) ]


viewOverview : Element msg
viewOverview =
    column []
        [ text "fast and friendly compiler"
        , text "small and simple"
        , text "JavaScript interop"
        ]


viewOverviewInfo : Element msg
viewOverviewInfo =
    column [ width fill, spacing 10 ]
        [ paragraph [ width fill ]
            [ text "The elm compiler is really fast and provieds great and friendly error messages."
            ]
        , paragraph [ width fill ]
            [ text "For more infos and exmaples take a look at the "
            , link [ Font.color blue ]
                { url = "/compiler"
                , label = text "slides about the compiler"
                }
            , text "."
            ]
        ]


viewFrameworks : Element msg
viewFrameworks =
    column []
        [ text "Not really comparable to web frameworks like Angular, React, Vue"
        ]


viewFrameworksInfo : Element msg
viewFrameworksInfo =
    column [ width fill, spacing 10 ]
        [ paragraph [ width fill ]
            [ text "Elm cannot really be compared to frameworks like Angular, React and Vue because even if you use them you are going to write TypeScript or Javascript."
            ]
        , paragraph [ width fill ]
            [ text "But if you use Elm you write Elm code. That is a completly different language."
            ]
        , paragraph [ width fill ]
            [ text "For more infos watch "
            , newTabLink [ Font.color blue ]
                { url = "https://www.youtube.com/watch?v=ukVqQGbxM9A&t=280s"
                , label = text "that talk from Richard Feldman"
                }
            , text " about Rust and Elm."
            ]
        ]
