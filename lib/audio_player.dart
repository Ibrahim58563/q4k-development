// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:q4k/constants.dart';

class Audio extends StatefulWidget {
  final String subjectAudioName;
  final String url;
  const Audio({
    Key? key,
    required this.subjectAudioName,
    required this.url,
  }) : super(key: key);

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  late var duration = Duration.zero;
  var position = Duration.zero;
  int currentFileIndex = -1;

  // final List<String> files = [
  //   "https://cdn.islamic.network/quran/audio/128/ar.alafasy/1.mp3",
  //   "https://cdn.islamic.network/quran/audio/128/ar.alafasy/2.mp3",
  //   "https://cdn.islamic.network/quran/audio/128/ar.alafasy/3.mp3",
  //   "https://cdn.islamic.network/quran/audio/128/ar.alafasy/4.mp3",
  //   "https://cdn.islamic.network/quran/audio/128/ar.alafasy/5.mp3",
  //   "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6.mp3",
  //   "https://cdn.islamic.network/quran/audio/128/ar.alafasy/7.mp3",
  //   "https://cdn.islamic.network/quran/audio/128/ar.alafasy/8.mp3",
  //   "https://cdn.islamic.network/quran/audio/128/ar.alafasy/9.mp3",
  //   "https://cdn.islamic.network/quran/audio/128/ar.alafasy/10.mp3",
  //   "https://cdn.islamic.network/quran/audio/128/ar.alafasy/11.mp3",
  // ];

  // int getNextIndex() {
  //   if (files.length - 1 > currentFileIndex) {
  //     currentFileIndex++;
  //     log(currentFileIndex.toString(), name: "currentFileIndex");

  //     return currentFileIndex;
  //   } else {
  //     currentFileIndex = 0;
  //     log(currentFileIndex.toString(), name: "currentFileIndex");
  //     return currentFileIndex;
  //   }
  // }

  Future<void> loadFiles() async {
    setAudio();
    // log(await audioPlayer.setSourceUrl(widget.url.toString()).toString(), name: "files.length");
  }

  @override
  void initState() {
    super.initState();
    loadFiles();

    
    /// listen to states: playing, paused, stopped
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
        if (state == PlayerState.completed) {
          setAudio();
        }
      });
    });

    // listen to audio position
    audioPlayer.onPositionChanged.listen((newPosition) {
      position = newPosition;
    });

    // listion to audio duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
        audioPlayer.resume();
      });
    });
  }

  Future setAudio() async {
    audioPlayer.setVolume(1);
    // final file = files[getNextIndex()];
    await audioPlayer.setSourceUrl(widget.url.toString());
  }

  @override
  void dispose() async {
    audioPlayer.onPlayerStateChanged.listen((state) async {
      setState(() async {
        isPlaying = state == PlayerState.playing;

        if (state == PlayerState.playing) {
          await audioPlayer.dispose();
        }
      });
    });

    super.dispose();
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  double dropdownvalue = 1;

  List<double> speeds = <double>[0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];

  @override
  Future<void> setSpeed(double speed) => audioPlayer.setPlaybackRate(speed);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio Player"),
      ),
      body: Builder(
        builder: (context) {
          // if (currentFileIndex >= 0) {
            return Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: primaryColor,
                        width: 3,
                        style: BorderStyle.solid,
                      )),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: CachedNetworkImage(
                        imageUrl:
                            'https://i.pinimg.com/originals/10/07/4a/10074a71a0790c316b3b07d0bed67a6d.png'),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Slider(
                  thumbColor: primaryColor,
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds
                      .clamp(0, position.inSeconds)
                      .toDouble(),
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
                      InkWell(
                        onTap: () async {
                          await audioPlayer
                              .seek(Duration(seconds: position.inSeconds - 10));
                        },
                        child: Text("-10s"),
                      ),
                      DropdownButton(
                          items: speeds.map((double speeds) {
                            return DropdownMenuItem(
                              value: speeds,
                              child: Text(speeds.toString()),
                            );
                          }).toList(),
                          value: dropdownvalue,
                          onChanged: (double? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                              audioPlayer.setPlaybackRate(newValue);
                            });
                          }),
                      InkWell(
                        onTap: () async {
                          await audioPlayer
                              .seek(Duration(seconds: position.inSeconds + 10));
                        },
                        child: Text("+10s"),
                      ),
                      Text(formatTime(duration - position)),
                    ],
                  ),
                ),
                CircleAvatar(
                    backgroundColor: primaryColor,
                    radius: 35,
                    child: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: lightColor,
                      ),
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
            );
          // }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
    
  }

  String formatTime(Duration position) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(position.inHours);
    final minutes = twoDigits(position.inMinutes.remainder(60));
    final seconds = twoDigits(position.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
  
}
