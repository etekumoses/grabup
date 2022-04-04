import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MyVideoThumbNail extends StatefulWidget {

  final String url;
  MyVideoThumbNail(this.url);

  @override
  _MyVideoThumbNailState createState() => _MyVideoThumbNailState();
}

class _MyVideoThumbNailState extends State<MyVideoThumbNail> {

  VideoPlayerController _videoPlayerController1;

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(widget.url);
    await _videoPlayerController1.initialize();
  }

  @override
  void initState() {

    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {

    super.dispose();
    _videoPlayerController1.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: VideoPlayer(_videoPlayerController1),
    );
  }
}
