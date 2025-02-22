import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.private.mpris as Mpris

Item {

    property var mpris2Model: Mpris.Mpris2Model {
    }
    property var indexPlayer: mpris2Model.currentPlayer
    readonly property string trackName: mpris2Model.currentPlayer?.track
    readonly property string albumName: mpris2Model.currentPlayer?.album
    readonly property string artistName: mpris2Model.currentPlayer?.artist
    readonly property int playbackStatus: mpris2Model.currentPlayer?.playbackStatus ?? 0
    readonly property bool isPlaying: root.playbackStatus === Mpris.PlaybackStatus.Playing

    property bool coverByNetwork: Plasmoid.configuration.coverByNetwork
    property bool coverMprisIsImage: false
    property url coverMpris: mpris2Model.currentPlayer?.artUrl
    property url cover: coverMprisIsImage ? coverMpris : coverByNetwork ? onlineCover : coverMpris

    property url onlineCover

    Image {
        id: cov
        source: coverMpris
        visible: false
        sourceSize.width: 16
        sourceSize.height: 16
        retainWhileLoading: false
        onStatusChanged: {
            if (cov.status === Image.Ready){
                coverMprisIsImage = true
            }
        }
    }

    function nextTrack() {
        mpris2Model.currentPlayer.Next();
    }
    function playPause() {
        mpris2Model.currentPlayer.PlayPause();
    }
    function prevTrack() {
        mpris2Model.currentPlayer.Previous();
    }

    onCoverByNetworkChanged: {
        if (coverByNetwork) {
            getCover.start()
        }
    }
    onTrackNameChanged: {
        onlineCover = ""
        coverMprisIsImage = coverByNetwork ? false : true
        getCover.start()
    }

    Component.onCompleted: {
        if (coverByNetwork){getCoverArt(artistName, albumName)}
    }

    Timer {
        id: getCover
        interval: 100
        running: false
        repeat: false
        onTriggered: if (coverByNetwork){getCoverArt(artistName, albumName)}
    }

    function getUrl(apiUrl){
        var xhr = new XMLHttpRequest();

        xhr.open("GET", apiUrl, true);
        xhr.responseType = "json";

        xhr.onload = function() {
            if (xhr.status === 200) {
                var data = xhr.response;
                var frontImage = data.images.find(function(image) {
                    return image.front === true || image.types.includes("Front");
                });
                if (frontImage && frontImage.thumbnails && frontImage.thumbnails.large) {
                    var largeImageUrl = frontImage.thumbnails.large;
                    console.log("URL de la imagen large:", largeImageUrl);
                    onlineCover = largeImageUrl

                } else {
                    console.error("No se encontró la imagen large");
                }
            } else {
                console.error("Error al cargar la API de la image:", xhr.status);
            }
        };

        xhr.send();
    }

    function getCoverArt(artist, album) {
        var query = 'artist:"' + artist + '" AND release:"' + album + '"';
        var mbUrl = "https://musicbrainz.org/ws/2/release/?query=" + query + "&fmt=json";
        console.log("Consultando MusicBrainz en:", mbUrl);

        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText);
                    if (response.releases && response.releases.length > 0) {
                        var mbid = response.releases[0].id;
                        console.log("MBID encontrado:", mbid);
                        var coverUrl = "https://coverartarchive.org/release/" + mbid;
                        console.log("URL de la portada:", coverUrl);
                        getUrl(coverUrl.toString())
                    } else {
                        console.log("No se encontraron lanzamientos.");
                    }
                } else {
                    console.log("Error en la consulta: " + xhr.status);
                }
            }
        };
        xhr.open("GET", mbUrl);
        xhr.setRequestHeader("User-Agent", "MiAplicacion/1.0 (contacto@ejemplo.com)"); // 🔹 Agregar User-Agent
        xhr.send();
    }

}
