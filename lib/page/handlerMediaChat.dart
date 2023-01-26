import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:d_invite/components/topBar.dart';
import 'package:d_invite/const/config.dart';
import 'package:d_invite/const/designHelper.dart';

class MediaChat extends StatefulWidget {
  final file;
  final type;
  final userId;
  final from;
  final chatroom;
  final invit;

  MediaChat(
      {this.file,
      this.type,
      this.userId,
      this.from,
      this.chatroom,
      this.invit});

  @override
  _MediaChatState createState() =>
      _MediaChatState(file, type, userId, from, chatroom, invit);
}

class _MediaChatState extends State<MediaChat> {
  var file;
  var type;
  var userId;
  var from;
  var chatroom;
  var invit;
  _MediaChatState(
      this.file, this.type, this.userId, this.from, this.chatroom, this.invit);
  var send;

  _sendMsg() async {
    var uri = Uri.parse('${base_url}api/sendMsg');
    var req = new http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', file));
    req.fields['user_one'] = userId['id'].toString();
    req.fields['chat_id'] = chatroom['id'].toString();
    req.fields['msg'] = '';
    req.fields['sentTo'] = from
        ? chatroom['user_satu_id'].toString()
        : chatroom['user_dua_id'].toString();
    req.fields['invitId'] = invit.toString();
    req.fields['type'] = type;
    final res = await req.send();
    var respon;
    if (res.statusCode == 200) {
      respon = String.fromCharCodes(await res.stream.toBytes());
      print(respon);
      setState(() {
        send = respon;
      });
      Navigator.pop(context);
    } else {
      print('erorr');
    }
  }

  _sendVideoMsg() async {
    final dir = await getApplicationDocumentsDirectory();
    final thumbnail = await VideoThumbnail.thumbnailFile(
      thumbnailPath: dir.path,
      video: file,
      imageFormat: ImageFormat.PNG,
      quality: 25,
    );
    FormData formData = FormData.fromMap({
      'user_one': userId['id'],
      'chat_id': chatroom['id'],
      'type': type,
      'invitId': invit,
      'sentTo': from ? chatroom['user_satu_id'] : chatroom['user_dua_id']
    });
    formData.files.addAll([
      MapEntry('image', await MultipartFile.fromFile(file)),
      MapEntry('thumbnail', await MultipartFile.fromFile(thumbnail))
    ]);
    Dio().post('${base_url}api/sendMsg', data: formData).then((value) {
      print(value);
      Navigator.pop(context);
    }).catchError((e) => print(e));
  }

  VideoPlayerController _controller;
  Future<void> _initializeVP;
  var value = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(file);
    _initializeVP = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(gradientOne),
      floatingActionButton: type == 'fromchat'
          ? null
          : FloatingActionButton(
              onPressed: () {
                type == 'video' ? _sendVideoMsg() :
                _sendMsg();
              },
              child: Icon(Icons.send)),
      body: SafeArea(
        child: type == 'fromchat' || type == 'video'
            ? Stack(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: FutureBuilder(
                          future: _initializeVP,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          })),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                          value = 0.0;
                        } else {
                          _controller.play();
                          value = -100.0;
                        }
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0),
                      ),
                      child: !_controller.value.isPlaying
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _controller.play();
                                  value = -100.0;
                                });
                              },
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 50,
                              ))
                          : null,
                    ),
                  ),
                  AnimatedContainer(
                      curve: Curves.easeInOut,
                      transform: Matrix4.translationValues(0, value, 0),
                      duration: Duration(milliseconds: 350),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(gradientOne),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25))),
                      child: MyTopBarWithBack(
                        title: "Kembali",
                      ))
                ],
              )
            : type == 'image'
                ? Column(
                    children: [
                      Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Color(gradientOne),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25))),
                          child: MyTopBarWithBack(
                            title: "Kembali",
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(child: Image.file(File(file))))
                    ],
                  )
                : null,
      ),
    );
  }
}
