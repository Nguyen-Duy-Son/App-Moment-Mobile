// import 'dart:convert';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hit_moments/app/providers/conversation_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// import '../../../core/constants/assets.dart';
// import '../../../core/extensions/theme_extensions.dart';
// import '../../../l10n/l10n.dart';
// import '../../../models/user_model.dart';
//
// class ChatMessageView extends StatefulWidget {
//   const ChatMessageView(
//       {super.key, required this.conversationId, required this.receiver});
//
//   final String conversationId;
//   final User receiver;
//
//   @override
//   State<ChatMessageView> createState() => _ChatMessageViewState();
// }
//
// class _ChatMessageViewState extends State<ChatMessageView> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   late WebSocketChannel channel; //channel variable for websocket
//   late bool connected;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       channelconnect();
//       context
//           .read<ConversationProvider>()
//           .getChatMessage(widget.conversationId);
//       _scrollToBottom();
//     });
//   }
//
//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }
//
//   channelconnect() {
//     //function to connect
//     try {
//       channel = WebSocketChannel.connect(
//         Uri.parse(
//             'https://api.hitmoments.com'), //connect to node.js server
//       );
//       print(channel.stream);
//       channel.stream.listen(
//         (message) {
//           if (kDebugMode) {
//             print(message);
//           }
//           setState(() {
//             if (message == "connected") {
//               connected = true;
//               setState(() {});
//               if (kDebugMode) {
//                 print("Connection establised.");
//               }
//             } else if (message == "send:success") {
//               if (kDebugMode) {
//                 print("Message send success");
//               }
//               setState(() {
//                 // msgtext.text = "";
//               });
//             } else if (message == "send:error") {
//               if (kDebugMode) {
//                 print("Message send error");
//               }
//             } else if (message.substring(0, 6) == "{'cmd'") {
//               if (kDebugMode) {
//                 print("Message data");
//               }
//               message = message.replaceAll(RegExp("'"), '"');
//               var jsondata = json.decode(message);
//               setState(() {
//                 //update UI after adding data to message model
//               });
//             }
//           });
//         },
//         onDone: () {
//           //if WebSocket is disconnected
//           if (kDebugMode) {
//             print("Web socket is closed");
//           }
//           setState(() {
//             connected = false;
//           });
//         },
//         onError: (error) {
//           if (kDebugMode) {
//             print(error.toString());
//           }
//         },
//       );
//     } catch (_) {
//       if (kDebugMode) {
//         print("error on connecting to websocket.");
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           appBar: AppBar(
//             automaticallyImplyLeading: true,
//             title: Container(
//               margin: EdgeInsets.only(top: 12.h),
//               child: Column(
//                 children: [
//                   Text(
//                     widget.receiver.fullName,
//                     style: AppTextStyles.of(context).light20.copyWith(
//                           color: AppColors.of(context).neutralColor12,
//                           height: 0.9,
//                         ),
//                   ),
//                 ],
//               ),
//             ),
//             centerTitle: true,
//           ),
//           body: StreamBuilder(
//             stream: channel.stream,
//             builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//               if (snapshot.hasData && snapshot.data == "send:success") {
//                 context
//                     .read<ConversationProvider>()
//                     .getChatMessage(widget.conversationId);
//               }
//               return !context.watch<ConversationProvider>().isLoadingChatMessage
//                   ? Column(
//                       children: [
//                         Expanded(
//                           child: ListView.builder(
//                             controller: _scrollController,
//                             scrollDirection: Axis.vertical,
//                             itemCount: context
//                                 .watch<ConversationProvider>()
//                                 .chatMessages
//                                 .length,
//                             itemBuilder: (context, index) {
//                               final message = context
//                                   .watch<ConversationProvider>()
//                                   .chatMessages[index];
//                               final bool isMe =
//                                   message.sender.id != widget.receiver.id;
//                               return Container(
//                                 alignment: isMe
//                                     ? Alignment.centerRight
//                                     : Alignment.centerLeft,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Container(
//                                       margin: EdgeInsets.only(
//                                         top: 4.h,
//                                         left: isMe ? 92.w : 8.w,
//                                         right: !isMe ? 0 : 8.w,
//                                       ),
//                                       padding: EdgeInsets.symmetric(
//                                         // vertical: 4.h,
//                                         horizontal: 12.w,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: isMe
//                                             ? AppColors.of(context)
//                                                 .primaryColor3
//                                             : AppColors.of(context)
//                                                 .neutralColor4,
//                                         borderRadius: BorderRadius.circular(15),
//                                       ),
//                                       child: Text(
//                                         message.text,
//                                         style: AppTextStyles.of(context)
//                                             .regular20
//                                             .copyWith(
//                                               color: AppColors.of(context)
//                                                   .neutralColor12,
//                                             ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.all(8.w),
//                           decoration: BoxDecoration(
//                             color: AppColors.of(context).neutralColor7,
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                           child: Form(
//                             child: TextFormField(
//                               controller: _controller,
//                               decoration: InputDecoration(
//                                 hintText: S.of(context).titleSendMessage,
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(50),
//                                     borderSide: BorderSide.none),
//                                 suffixIcon: GestureDetector(
//                                   onTap: _sendMessage,
//                                   child: Container(
//                                     width: 16.w,
//                                     margin: EdgeInsets.only(right: 12.w),
//                                     alignment: Alignment.center,
//                                     child: SvgPicture.asset(
//                                       Assets.icons.sendSVG,
//                                       color:
//                                           AppColors.of(context).neutralColor9,
//                                       width: 24.w,
//                                       height: 24.h,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               // onTap: ()=>sendmsg(),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   : const Center(
//                       child: CircularProgressIndicator(),
//                     );
//             },
//           )),
//     );
//   }
//
//   Future<void> _sendMessage() async {
//     if (_controller.text.isNotEmpty) {
//       final conversationProvider = context.read<ConversationProvider>();
//       conversationProvider.sendMessage(widget.conversationId, _controller.text);
//       if (conversationProvider.isSending != true) {
//         _controller.clear();
//         context
//             .read<ConversationProvider>()
//             .getChatMessage(widget.conversationId);
//         context.read<ConversationProvider>().getConversations();
//       }
//     }
//     _scrollToBottom();
//   }
// }

// if (isMe)
//   context.watch<ConversationProvider>().isSending!=true?Container(
//     alignment: Alignment.centerRight,
//     margin: EdgeInsets.only(
//       right: 8.w,
//       top: 4.h,
//     ),
//     child: Text(
//       'Đã gửi',
//       style: AppTextStyles.of(context)
//           .light14
//           .copyWith(
//             color: AppColors.of(context)
//                 .neutralColor12,
//           ),
//     ),
//   ):
//   Container(
//     alignment: Alignment.centerRight,
//     margin: EdgeInsets.only(
//       right: 8.w,
//       top: 4.h,
//     ),
//     child: Text(
//       'Gửi thất bại',
//       style: AppTextStyles.of(context)
//           .light14
//           .copyWith(
//             color: AppColors.of(context)
//                 .neutralColor12,
//           ),
//     ),
//   ),
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/providers/conversation_provider.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../core/constants/assets.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../l10n/l10n.dart';
import '../../../models/user_model.dart';

class ChatMessageView extends StatefulWidget {
  const ChatMessageView(
      {super.key, required this.conversationId, required this.receiver});

  final String conversationId;
  final User receiver;

  @override
  State<ChatMessageView> createState() => _ChatMessageViewState();
}

class _ChatMessageViewState extends State<ChatMessageView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late IO.Socket socket;
  final StreamController<String> _streamController = StreamController<String>();

  Stream<String> get messagesStream => _streamController.stream;

  @override
  void initState() {
    super.initState();
    connect();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      context
          .read<ConversationProvider>()
          .getChatMessage(widget.conversationId);
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void connect() {
    socket = IO.io('https://api.hitmoments.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.onConnect((_) {
      if (kDebugMode) {
        print('connect');
      }
      socket.emit('message', 'test');
    });

    socket.on('getOnlineUsers', (data) => handleOnlineUsers(data));

    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));

    socket.connect();
  }

  void handleOnlineUsers(dynamic data) {
    // Handle the list of online users
    print('Online users: $data');
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
          body: !context.watch<ConversationProvider>().isLoadingChatMessage
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        itemCount: context
                            .watch<ConversationProvider>()
                            .chatMessages
                            .length,
                        itemBuilder: (context, index) {
                          final message = context
                              .watch<ConversationProvider>()
                              .chatMessages[index];
                          final bool isMe =
                              message.sender.id != widget.receiver.id;
                          return Container(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 4.h,
                                    left: isMe ? 92.w : 8.w,
                                    right: !isMe ? 0 : 8.w,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    // vertical: 4.h,
                                    horizontal: 12.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? AppColors.of(context).primaryColor3
                                        : AppColors.of(context).neutralColor4,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    message.text,
                                    style: AppTextStyles.of(context)
                                        .regular20
                                        .copyWith(
                                          color: AppColors.of(context)
                                              .neutralColor12,
                                        ),
                                  ),
                                ),
                              ],
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
                                borderSide: BorderSide.none),
                            suffixIcon: GestureDetector(
                              onTap: _sendMessage,
                              child: Container(
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
                          ),
                          onTap: ()=>_sendMessage(),
                        ),
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final conversationProvider = context.read<ConversationProvider>();
      conversationProvider.sendMessage(widget.conversationId, _controller.text);
      if (conversationProvider.isSending != true) {
        _controller.clear();
        context
            .read<ConversationProvider>()
            .getChatMessage(widget.conversationId);
        context.read<ConversationProvider>().getConversations();

      }
    }
    _scrollToBottom();
  }
}
