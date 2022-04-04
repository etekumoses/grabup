import 'package:flutter/material.dart';

class TrimmerView extends StatefulWidget {
  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String _value;

    return _value;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Video"),
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: LinearProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: FloatingActionButton(
                        heroTag: "btn1",
                        child: _isPlaying
                            ? Icon(
                                Icons.pause,
                                size: 40.0,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.play_arrow,
                                size: 40.0,
                                color: Colors.white,
                              ),
                        onPressed: () async {},
                      ),
                    ),
                    Expanded(
                      child: FloatingActionButton(
                        heroTag: "btn2",
                        onPressed: _progressVisibility
                            ? null
                            : () async {
                                _saveVideo().then((outputPath) {
                                  print('OUTPUT PATH: $outputPath');
                                  Navigator.pop(context, outputPath);
                                });
                              },
                        child: Icon(Icons.send),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
