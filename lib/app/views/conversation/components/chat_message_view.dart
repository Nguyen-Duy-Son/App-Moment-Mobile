import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/providers/conversation_provider.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/constants/assets.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../l10n/l10n.dart';
import '../../../models/user_model.dart';

class ChatMessageView extends StatefulWidget {
  const ChatMessageView({super.key, required this.convaersationId, required this.receiver});

  final String convaersationId;
  final User receiver;
  @override
  State<ChatMessageView> createState() => _ChatMessageViewState();
}

class _ChatMessageViewState extends State<ChatMessageView> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConversationProvider>().getChatMessage(widget.convaersationId);
    });
  }



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
                  widget.receiver.fullName,
                  style: AppTextStyles.of(context).light20.copyWith(
                        color: AppColors.of(context).neutralColor12,
                        height: 0.9,
                      ),
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: !context.watch<ConversationProvider>().isLoadingChatMessage? Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: context.watch<ConversationProvider>().chatMessages.length,
                itemBuilder: (context, index) {
                  final message = context.watch<ConversationProvider>().chatMessages[index];
                  final bool isMe = context.watch<ConversationProvider>().chatMessages[0].id != widget.receiver.id;
                  return Container(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 4.h,
                        bottom: 4.h,
                        left: isMe ? 92.w : 8.w,
                        right: !isMe ? 0 : 8.w,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 4.h,
                        horizontal: 12.w,
                      ),
                      decoration: BoxDecoration(
                        color: isMe
                            ? AppColors.of(context).primaryColor3
                            : AppColors.of(context).neutralColor4, // if the message is from 'me', set the color to primaryColor5, otherwise set it to white
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        message.text,
                        style: AppTextStyles.of(context).regular20.copyWith(
                          color: AppColors.of(context).neutralColor12,
                        ),
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
                    hintText: S.of(context).titleSendMessage,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none
                    ),
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
                  // onTap: _sendMessage,
                ),
              ),
            ),
          ],
        ): const Center(
          child: CircularProgressIndicator(),
        )
      ),
    );
  }

  // void _sendMessage() {
  //   if (_controller.text.isNotEmpty) {
  //     final message = {
  //       'user_id': widget.user.id,
  //       'text': _controller.text,
  //       'sender':"me",
  //     };
  //     _channel.sink.add(json.encode(message));
  //     setState(() {
  //       messages.add(message);
  //       print(messages);
  //     });
  //     _controller.clear();
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   _channel.sink.close();
  //   _controller.dispose();
  //   super.dispose();
  // }
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