import 'package:daily_discipleship/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class HymnAudioPlayer extends StatefulWidget {
  final String storagePath;
  const HymnAudioPlayer({super.key, required this.storagePath});

  @override
  State<HymnAudioPlayer> createState() => _HymnAudioPlayerState();
}

class _HymnAudioPlayerState extends State<HymnAudioPlayer> {
  final audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isDraggingSlider = false;
  double _sliderValue = 0.0;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    setAudio();

    audioPlayer.positionStream.listen((newPosition) {
      // debugPrint("new position: $newPosition");
      setState(() {
        position = newPosition;
      });
    });

    audioPlayer.durationStream.listen((newDuration) {
      // debugPrint("new duration: $newDuration");
      setState(() {
        duration = newDuration ?? Duration.zero;
      });
    });

    audioPlayer.playerStateStream.listen((playerState) async {
      if (playerState.processingState == ProcessingState.completed) {
        debugPrint("Song completed!");
        isPlaying = false;
        await audioPlayer.seek(Duration.zero);
        await audioPlayer.pause();
      }
    });
  }

  Future setAudio() async {
    debugPrint(widget.storagePath);
    String audioUrl = await StorageService().getDownloadURL(widget.storagePath);
    debugPrint(audioUrl);
    await audioPlayer.setUrl(audioUrl);
  }

  @override
  void dispose() {
    audioPlayer.dispose(); // Dispose of the audio player
    super.dispose(); // Call the superclass's dispose method
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          min: 0,
          max: duration.inMilliseconds.toDouble(),
          value: isDraggingSlider
              ? _sliderValue
              : position.inMilliseconds.toDouble(),
          onChanged: (value) {
            setState(() {
              isDraggingSlider = true;
              _sliderValue = value;
            });
          },
          onChangeEnd: (value) async {
            isDraggingSlider = false;
            final seekPosition = Duration(milliseconds: value.toInt());
            await audioPlayer.seek(seekPosition);
          },
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(position)),
                Text(formatTime(duration))
              ],
            )),
        CircleAvatar(
            radius: 35,
            child: IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 50,
                onPressed: () async {
                  if (isPlaying) {
                    setState(() {
                      isPlaying = false;
                    });
                    debugPrint("audio player paused");
                    await audioPlayer.pause();
                  } else {
                    setState(() {
                      isPlaying = true;
                    });
                    debugPrint("audio player playing");
                    await audioPlayer.play();
                  }
                }))
      ],
    );
  }
}

String formatTime(Duration duration) {
  String twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
}
