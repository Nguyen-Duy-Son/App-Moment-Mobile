import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/constants/assets.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../l10n/l10n.dart';
import '../../../models/user_model.dart';

class ChatMessageView extends StatefulWidget {
  const ChatMessageView({super.key, required this.user});

  final User user;

  @override
  State<ChatMessageView> createState() => _ChatMessageViewState();
}

class _ChatMessageViewState extends State<ChatMessageView> {
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );
  late WebSocketChannel channel; //channel variable for websocket
  late bool connected; // boolean value to track connection status

  String myid = "4321";
  String friendid = "1234";
  String token = "addauthkeyifrequired"; //auth key

  List<MessageData> msglist = [];

  TextEditingController msgtext = TextEditingController();

  @override
  void initState() {
    connected = false;
    msgtext.text = "";
    channelconnect();
    super.initState();
  }

  channelconnect() {
    //function to connect
    try {
      channel = WebSocketChannel.connect(
        Uri.parse('ws://10.0.2.2:6060/$myid'), //connect to node.js server
      );
      channel.stream.listen(
            (message) {
          if (kDebugMode) {
            print(message);
          }
          setState(() {
            if (message == "connected") {
              connected = true;
              setState(() {});
              if (kDebugMode) {
                print("Connection establised.");
              }
            } else if (message == "send:success") {
              if (kDebugMode) {
                print("Message send success");
              }
              setState(() {
                msgtext.text = "";
              });
            } else if (message == "send:error") {
              if (kDebugMode) {
                print("Message send error");
              }
            } else if (message.substring(0, 6) == "{'cmd'") {
              if (kDebugMode) {
                print("Message data");
              }
              message = message.replaceAll(RegExp("'"), '"');
              var jsondata = json.decode(message);

              msglist.add(MessageData(
                //on message recieve, add data to model
                msgtext: jsondata["msgtext"],
                userid: jsondata["userid"],
                isme: false,
              ));
              setState(() {
                //update UI after adding data to message model
              });
            }
          });
        },
        onDone: () {
          //if WebSocket is disconnected
          if (kDebugMode) {
            print("Web socket is closed");
          }
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          if (kDebugMode) {
            print(error.toString());
          }
        },
      );
    } catch (_) {
      if (kDebugMode) {
        print("error on connecting to websocket.");
      }
    }
  }

  Future<void> sendmsg(String sendmsg, String id) async {
    if (connected == true) {
      String msg =
          "{'auth':'$token','cmd':'send','userid':'$id', 'msgtext':'$sendmsg'}";
      setState(() {
        msgtext.text = "";
        msglist.add(MessageData(msgtext: sendmsg, userid: myid, isme: true));
      });
      channel.sink.add(msg); //send message to reciever channel
    } else {
      channelconnect();
      if (kDebugMode) {
        print("Websocket is not connected.");
      }
    }
  }
  List<Map<String, dynamic>> messages = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Container(
            margin: EdgeInsets.only(top: 12.h),
            child: Column(
              children: [
                Text(
                  widget.user.fullName,
                  style: AppTextStyles.of(context).light20.copyWith(
                        color: AppColors.of(context).neutralColor12,
                        height: 0.9,
                      ),
                ),
                !connected?Text(
                  "1 giờ trước",
                  style: AppTextStyles.of(context).light14.copyWith(
                        color: AppColors.of(context).neutralColor12,
                      ),
                ):Text(
                  "Đang hoạt động",
                  style: AppTextStyles.of(context).light14.copyWith(
                        color: AppColors.of(context).neutralColor12,
                      ),

                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final bool isMe = message['sender'] == 'me';
                  return Container(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 5.h,
                        horizontal: 10.w,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 15.w,
                      ),
                      decoration: BoxDecoration(
                        color: isMe
                            ? AppColors.of(context).primaryColor5
                            : Colors.white, // if the message is from 'me', set the color to primaryColor5, otherwise set it to white
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        message['text'],
                        style: AppTextStyles.of(context).regular20,
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.of(context).neutralColor7,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Form(
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: S.of(context).sendMessage,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none),
                    suffixIcon: Container(
                      width: 16.w,
                      margin: EdgeInsets.only(right: 12.w),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        Assets.icons.sendSVG,
                        color: AppColors.of(context).neutralColor9,
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                  ),
                  onTap: _sendMessage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = {
        'user_id': widget.user.id,
        'text': _controller.text,
        'sender':"me",
      };
      _channel.sink.add(json.encode(message));
      setState(() {
        messages.add(message);
        print(messages);
      });
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}

class MessageData {
  //message data model
  String msgtext, userid;
  bool isme;

  MessageData(
      {required this.msgtext, required this.userid, required this.isme});
}
// return Scaffold(
//     appBar: AppBar(
//       title: Text("My ID: $myid - Chat App Example"),
//       leading: Icon(Icons.circle,
//           color: connected ? Colors.greenAccent : Colors.redAccent),
//       //if app is connected to node.js then it will be gree, else red.
//       titleSpacing: 0,
//     ),
//     body: Stack(
//       children: [
//         Positioned(
//             top: 0,
//             bottom: 70,
//             left: 0,
//             right: 0,
//             child: Container(
//                 padding: const EdgeInsets.all(15),
//                 child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         const Text("Your Messages",
//                             style: TextStyle(fontSize: 20)),
//                         Column(
//                           children: msglist.map((onemsg) {
//                             return Container(
//                                 margin: EdgeInsets.only(
//                                   //if is my message, then it has margin 40 at left
//                                   left: onemsg.isme ? 40 : 0,
//                                   right: onemsg.isme
//                                       ? 0
//                                       : 40, //else margin at right
//                                 ),
//                                 child: Card(
//                                     color: onemsg.isme
//                                         ? Colors.blue[100]
//                                         : Colors.red[100],
//                                     //if its my message then, blue background else red background
//                                     child: Container(
//                                       width: double.infinity,
//                                       padding: const EdgeInsets.all(15),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(onemsg.isme
//                                               ? "ID: ME"
//                                               : "ID: ${onemsg.userid}"),
//                                           Container(
//                                             margin: const EdgeInsets.only(
//                                                 top: 10, bottom: 10),
//                                             child: Text(
//                                                 "Message: ${onemsg.msgtext}",
//                                                 style: const TextStyle(
//                                                     fontSize: 17)),
//                                           ),
//                                         ],
//                                       ),
//                                     )));
//                           }).toList(),
//                         )
//                       ],
//                     )))),
//         Positioned(
//           //position text field at bottom of screen
//
//           bottom: 0, left: 0, right: 0,
//           child: Container(
//               color: Colors.black12,
//               height: 70,
//               child: Row(
//                 children: [
//                   Expanded(
//                       child: Container(
//                         margin: const EdgeInsets.all(10),
//                         child: TextField(
//                           controller: msgtext,
//                           decoration: const InputDecoration(
//                               hintText: "Enter your Message"),
//                         ),
//                       )),
//                   Container(
//                       margin: const EdgeInsets.all(10),
//                       child: ElevatedButton(
//                         child: const Icon(Icons.send),
//                         onPressed: () {
//                           if (msgtext.text != "") {
//                             sendmsg(msgtext.text,
//                                 recieverid); //send message with webspcket
//                           } else {
//                             if (kDebugMode) {
//                               print("Enter message");
//                             }
//                           }
//                         },
//                       ))
//                 ],
//               )),
//         )
//       ],
//     ));