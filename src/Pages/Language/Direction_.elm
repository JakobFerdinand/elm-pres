module Pages.Language.Direction_ exposing (Model, Msg, layout, page)

import Browser.Navigation as Nav
import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE
import Chart.Item as CI
import Component exposing (code)
import Effect exposing (Effect)
import Element exposing (..)
import Element.Font as Font
import KeyListener
import Layout exposing (Layout)
import Navigation exposing (navigate)
import Page exposing (Page)
import Route exposing (Route)
import Route.Path as Path
import Shared
import Svg as S
import View exposing (Slide(..), View)


page : Shared.Model -> Route { direction : String } -> Page Model Msg
page shared route =
    Page.new
        { init = init route.params.direction
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


init : String -> () -> ( Model, Effect Msg )
init param () =
    ( case param of
        "backward" ->
            ShowDiagram

        "forward" ->
            Init

        _ ->
            Init
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
            ( model, navigate Path.NoRuntimeExceptions )

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
                            [ column [ padding 10, spacing 10 ]
                                [ text "Functional"
                                , code [] "sum a b =\n    a + b"
                                ]
                            , text "- Pure -> No side effects"
                            , text "- Relativly easy"
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
            [ { maintainability = 20, useability = 85, language = "JavaScript" }
            , { maintainability = 30, useability = 85, language = "Python" }
            , { maintainability = 40, useability = 85, language = "TypeScript" }
            , { maintainability = 75, useability = 75, language = "C#" }
            , { maintainability = 90, useability = 40, language = "Haskell" }
            , { maintainability = 90, useability = 90, language = "Elm" }
            ]
    in
    C.chart
        [ CA.height 200
        , CA.width 300
        , CA.padding { top = 0, bottom = 0, left = 30, right = 10 }
        , CA.range
            [ CA.lowest 10 CA.orLower
            , CA.highest 100 CA.orHigher
            ]
        , CA.domain
            [ CA.lowest 10 CA.orLower
            , CA.highest 100 CA.orHigher
            ]
        ]
        [ C.xAxis [ CA.color "#6bb6bb" ]
        , C.yAxis [ CA.color "#6bb6bb" ]
        , C.series .useability
            [ C.scatter .maintainability [ CA.opacity 0, CA.borderWidth 0 ]
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
            [ S.text "Maintainable" ]
        , C.labelAt
            CA.middle
            .min
            [ CA.moveDown 18 ]
            [ S.text "Useable" ]
        ]
        |> Element.html
        |> el
            [ width (fill |> maximum 800)
            , height fill
            , centerX
            , centerY
            ]
