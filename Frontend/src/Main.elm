module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import Json.Decode exposing (Decoder, field, list, string)



--MAIN


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : () -> ( Model, Cmd Msg )
init () =
    ( Loading, getChatPosts )



--UPDATE


type Model
    = Failure
    | Loading
    | Success Chat


type Msg
    = NoOp
    | GotChat (Result Http.Error Chat)


type alias UPost =
    { utag : String
    , user : String
    , msg : String
    , time : String
    }


type alias Chat =
    { room : String
    , posts : List UPost
    }


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


getChatPosts : Cmd Msg
getChatPosts =
    Http.get
        { url = "http://localhost/Main.php"
        , expect = Http.expectJson GotChat chatDecoder
        }


chatDecoder : Decoder Chat
chatDecoder =
    Json.Decode.map2 Chat
        (field "room" string)
        (field "posts" (list postDecoder))


postDecoder : Decoder UPost
postDecoder =
    Json.Decode.map4 UPost
        (field "tag" string)
        (field "username" string)
        (field "message" string)
        (field "time" string)



--VIEW


view : Model -> Browser.Document Msg
view model =
    case model of
        Failure ->
            { title = "", body = [ text "ERROR" ] }

        Loading ->
            { title = "", body = [ text "Loading" ] }

        Success value ->
            { title = value.room, body = [ Html.div [] <| List.map viewPosts value.posts ] }


viewPosts : UPost -> Html Msg
viewPosts post =
    Html.div [ class post.utag ]
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
