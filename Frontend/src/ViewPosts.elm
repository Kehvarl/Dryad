module ViewPosts exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import Json.Decode exposing (Decoder, field, list, string)



--MODEL


type alias UPost =
    { utag : String
    , ucolor : String
    , user : String
    , msg : String
    , time : String
    }


type alias Chat =
    { room : String
    , posts : List UPost
    }


type Model
    = Failure
    | Loading String
    | Success Chat



--MAIN


main : Program String Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : String -> ( Model, Cmd Msg )
init room =
    ( Loading room, getChatPosts room )



--UPDATE


type Msg
    = NoOp
    | GotChat (Result Http.Error Chat)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GotChat result ->
            case result of
                Ok chat ->
                    ( Success chat, Cmd.none )

                Err error ->
                    Debug.log (Debug.toString error)
                        ( Failure, Cmd.none )


getChatPosts : String -> Cmd Msg
getChatPosts room =
    Http.get
        { url = "http://localhost/Main.php?room=" ++ room
        , expect = Http.expectJson GotChat chatDecoder
        }


chatDecoder : Decoder Chat
chatDecoder =
    Json.Decode.map2 Chat
        (field "room" string)
        (field "posts" (list postDecoder))


postDecoder : Decoder UPost
postDecoder =
    Json.Decode.map5 UPost
        (field "tag" string)
        (field "color" string)
        (field "username" string)
        (field "message" string)
        (field "time" string)



--VIEW


view : Model -> Html Msg
view model =
    case model of
        Failure ->
            text "ERROR"

        Loading chat ->
            text ("Loading " ++ chat)

        Success value ->
            viewChat value.room value.posts


viewChat : String -> List UPost -> Html Msg
viewChat room uPostList =
    Html.div []
        [ Html.span [ class "roon" ] [ text room ]
        , Html.div [ class "display" ] <| List.map viewPosts uPostList
        ]


viewPosts : UPost -> Html Msg
viewPosts post =
    Html.div [ class post.utag, Html.Attributes.style "color" post.ucolor ]
        [ span
            [ class "username" ]
            [ text (post.user ++ ": ") ]
        , span
            [ class "message" ]
            [ text post.msg ]
        , span
            [ class "time" ]
            [ text (" - " ++ post.time) ]
        , span
            [ class "tag" ]
            [ text (" " ++ post.utag) ]
        ]
