import QtQuick
import org.kde.plasma.private.mpris as Mpris

QtObject {

    property var mpris2Model: Mpris.Mpris2Model {
    }

    readonly property string trackName: mpris2Model.currentPlayer?.track
    readonly property string albumName: mpris2Model.currentPlayer?.album
    readonly property string artistName: mpris2Model.currentPlayer?.artist
    readonly property int playbackStatus: mpris2Model.currentPlayer?.playbackStatus ?? 0
    readonly property bool isPlaying: root.playbackStatus === Mpris.PlaybackStatus.Playing

    property url cover: mpris2Model.currentPlayer?.artUrl


    function nextTrack() {
        mpris2Model.currentPlayer.Next();
    }
    function playPause() {
        mpris2Model.currentPlayer.PlayPause();
    }
    function prevTrack() {
        mpris2Model.currentPlayer.Previous();
    }




}
