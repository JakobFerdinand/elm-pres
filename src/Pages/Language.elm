module Pages.Language exposing (Model, Msg, layout, page)

import Browser.Navigation as Nav
import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE
import Chart.Item as CI
import Effect exposing (Effect)
import Element exposing (..)
import Element.Font as Font
import KeyListener
import Layout exposing (Layout)
import Page exposing (Page)
import Route exposing (Route)
import Route.Path as Path
import Shared
import Svg as S
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
    | ShowDiagram


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
    let
        navigate to =
            to
                |> Path.toString
                |> Nav.load
                |> Effect.fromCmd
    in
    case ( msg, model ) of
        ( NavigatePrevious, Init ) ->
            ( model, navigate Path.Home_ )

        ( NavigatePrevious, ShowDiagram ) ->
            ( Init, Effect.none )

        ( NavigateNext, Init ) ->
            ( ShowDiagram, Effect.none )

        ( NavigateNext, ShowDiagram ) ->
            ( model, navigate Path.Compiler )

        ( DoNothing, _ ) ->
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    KeyListener.subscription NavigatePrevious NavigateNext DoNothing



-- VIEW


view : Model -> View Msg
view model =
    { title = "Elm Language"
    , body =
        Slide
            { header = text "Elm Language"
            , body =
                column
                    [ spacing 20, width fill, height fill ]
                    (case model of
                        Init ->
                            [ text "comparison to others like C#, JavaScript and Haskell"
                            ]

                        ShowDiagram ->
                            [ viewChart ]
                    )
            }
    , previous = Just NavigatePrevious
    , next = Just NavigateNext
    }


viewChart : Element msg
viewChart =
    let
        data =
            [ { usability = 20, staticTypeSystem = 20, language = "JavaScript" }
            , { usability = 30, staticTypeSystem = 40, language = "TypeScript" }
            , { usability = 80, staticTypeSystem = 75, language = "C#" }
            , { usability = 50, staticTypeSystem = 98, language = "Haskell" }
            , { usability = 98, staticTypeSystem = 98, language = "Elm" }
            ]
    in
    C.chart
        [ CA.height 200
        , CA.width 300
        , CA.padding { top = 0, bottom = 0, left = 30, right = 10 }
        ]
        [ C.xAxis [ CA.color "#6bb6bb" ]
        , C.yAxis [ CA.color "#6bb6bb" ]
        , C.series .staticTypeSystem
            [ C.scatter .usability [ CA.opacity 0, CA.borderWidth 0 ]
                |> C.variation (\i d -> [ CA.size 150 ])
            ]
            data
        , C.eachDot <|
            \p dot ->
                [ C.label
                    [ CA.moveDown 5, CA.color (CI.getColor dot) ]
                    [ S.text (CI.getData dot).language ]
                    (CI.getCenter p dot)
                ]
        , C.labelAt .min
            CA.middle
            [ CA.moveLeft 5, CA.rotate 90 ]
            [ S.text "Useability" ]
        , C.labelAt
            CA.middle
            .min
            [ CA.moveDown 18 ]
            [ S.text "Static Type System" ]
        ]
        |> Element.html
        |> el
            [ width (fill |> maximum 800)
            , height fill
            , centerX
            , centerY
            ]
