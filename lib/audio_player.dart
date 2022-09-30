import 'dart:io';
import 'package:path/path.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart';

class Audio extends StatefulWidget {
  final String subjectAudioName;

  const Audio({super.key, required this.subjectAudioName});

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  AudioPlayer audioPlayer = new AudioPlayer();
  bool isPlaying = false;
  late var duration = Duration.zero;
  var position = Duration.zero;

  late Future<ListResult> futureFiles;

  @override
  void initState() {
    super.initState();
    setAudio();

    // futureFiles = FirebaseStorage.instance
    //     .ref('/material/software_engineering/audio')
    //     .listAll();

    /// listen to states: playing, paused, stopped
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    // Future <String> _uploadphotofile(mFileImage) async {
    //     final  Reference storageReference = FirebaseStorage.instance.ref('/material/software_engineering/audio').child("products");
    //     UploadTask uploadTask = storageReference.child('/material/software_engineering/audio').;

    //     String url = await (await uploadTask).ref.getDownloadURL();
    //     return url;
    //   }
    // listion to audio duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    // listen to audio position
    audioPlayer.onPositionChanged.listen((newPosition) {
      position = newPosition;
    });
  }

  static Future<File> loadFirebase(String url) async {
    final refAudio = FirebaseStorage.instance.ref().child(url);
    final bytes = await refAudio.getData();

    return _storeFile(url, bytes!);
  }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future setAudio() async {
    try {
      audioPlayer.setReleaseMode(ReleaseMode.loop);
      final url = '112.mp3';
      final file = await loadFirebase(url);
      await audioPlayer.setSourceUrl(url);

      // String url = await ref.getDownloadURL();
      // print('Url' + url);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (value) async {
              final position = Duration(seconds: value.toInt());
              await audioPlayer.seek(position);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(position)),
                Text(formatTime(duration - position)),
              ],
            ),
          ),
          CircleAvatar(
              radius: 35,
              child: IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 50,
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                  } else {
                    await audioPlayer.resume();
                  }
                },
              )),
        ],
      ),
    );
  }

  String formatTime(Duration position) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
}
