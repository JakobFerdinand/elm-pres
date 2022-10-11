module Logo exposing (elm)

import Element exposing (..)
import Html.Attributes as HtmlAtt
import Svg
import Svg.Attributes as SvgAtt


elm : List (Attribute msg) -> Element msg
elm attributes =
    el attributes <|
        html <|
            Svg.svg [ HtmlAtt.width 323, HtmlAtt.height 323 ]
                [ Svg.path [ SvgAtt.fill "#F0AD00", SvgAtt.d "m162 153 70-70H92z" ] []
                , Svg.path [ SvgAtt.fill "#7FD13B", SvgAtt.d "m9 0 70 70h153L162 0zM247 85l77 76-77 77-76-77z" ] []
                , Svg.path [ SvgAtt.fill "#60B5CC", SvgAtt.d "M323 144V0H180z" ] []
                , Svg.path [ SvgAtt.fill "#5A6378", SvgAtt.d "M153 162 0 9v305z" ] []
                , Svg.path [ SvgAtt.fill "#F0AD00", SvgAtt.d "m256 247 67 67V179z" ] []
                , Svg.path [ SvgAtt.fill "#60B5CC", SvgAtt.d "M162 171 9 323h305z" ] []
                ]
