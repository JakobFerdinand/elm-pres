module Pages.Overview exposing (Model, Msg, layout, page)

import Colors exposing (green, orange)
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
    = Init
    | WebFrameworks


init : () -> ( Model, Effect Msg )
init () =
    ( Init
    , Effect.none
    )



-- UPDATE


type Msg
    = NavigatePrevious
    | NavigateNext
    | DoNothing


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case ( msg, model ) of
        ( NavigatePrevious, Init ) ->
            ( model, navigate Path.Home_ )

        ( NavigatePrevious, WebFrameworks ) ->
            ( Init, Effect.none )

        ( NavigateNext, Init ) ->
            ( WebFrameworks, Effect.none )

        ( NavigateNext, WebFrameworks ) ->
            ( model, navigate (Path.Language__Direction_ { direction = "forward" }) )

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
                        Init ->
                            viewOverview

                        WebFrameworks ->
                            viewFrameworks
                    ]
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


viewFrameworks : Element msg
viewFrameworks =
    column []
        [ text "Not really compareable to web frameworks like Angular, React, Vue"
        ]
