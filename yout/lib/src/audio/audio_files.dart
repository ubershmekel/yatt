import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

const defaultPlayerCount = 4;

typedef OnError = void Function(Exception exception);

const yays = [
  'sounds/yay1.mp3',
  'sounds/yay2.mp3',
  'sounds/yay3.mp3',
];

Random rng = Random();

class AudioFiles {
  AudioPlayer player = AudioPlayer();

  AudioFiles() {
    // player.onPlayerStateChanged.listen((it) {
    //   switch (it) {
    //     case PlayerState.stopped:
    //       debugPrint('Player stopped!');

    //       break;
    //     case PlayerState.completed:
    //       debugPrint('Player complete!');
    //       break;
    //     default:
    //       debugPrint('Player state: $it');
    //       break;
    //   }
    // });
    // player.onLog.listen((msg) => debugPrint('AudioPlayers Log: $msg'));
  }

  play() {
    const alarmAudioPath = "sounds/yay1.mp3";
    // When the file is missing we get this error:
    //  AudioPlayers Exception: AudioPlayerException(
    // 	PlatformException(4, MEDIA_ELEMENT_ERROR: Format error, null, null)
    player.play(AssetSource(alarmAudioPath));
  }

  yay() async {
    // play a random yay
    final yay = yays[rng.nextInt(yays.length)];
    debugPrint('yay ... $yay');
    await player.play(
      AssetSource(yay),
      volume: 1.0,
      mode: PlayerMode.lowLatency,
    );
  }
}
