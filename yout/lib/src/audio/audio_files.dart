import 'dart:math';

import 'package:audioplayers/audioplayers.dart';

const defaultPlayerCount = 4;

typedef OnError = void Function(Exception exception);

const yays = [
  'sounds/yay1.mp3',
  'sounds/yay2.mp3',
  'sounds/yay3.mp3',
];

class AudioFiles {
  AudioPlayer player = AudioPlayer();

  play() {
    const alarmAudioPath = "sounds/yay1.mp3";
    // When the file is missing we get this error:
    //  AudioPlayers Exception: AudioPlayerException(
    // 	PlatformException(4, MEDIA_ELEMENT_ERROR: Format error, null, null)
    player.play(AssetSource(alarmAudioPath));
  }

  yay() {
    // play a random yay
    final yay = yays[Random().nextInt(yays.length)];
    player.play(AssetSource(yay));
  }
}
