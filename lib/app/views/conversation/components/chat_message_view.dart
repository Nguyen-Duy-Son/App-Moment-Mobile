import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/providers/conversation_provider.dart';
import 'package:provider/provider.dart';

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
  // late IO.Socket socket;
  // final StreamController<String> _streamController = StreamController<String>();

  late String senderId;
  // late ConversationProvider _appProvider;
  @override
  void initState() {
    super.initState();
    // _appProvider = Provider.of<ConversationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      callApi();
      print('id: ${getUserID()}');
      // if (!_appProvider.socket.connected) {
      //   _appProvider.connectAndListen();
      // }
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    // _appProvider.disconnectSocket();
    super.dispose();
  }

  bool containsImageTag(String text) {
    return !text.contains('[@isImg123@]');
  }
  // @override
  // void deactivate() {
  //   // TODO: implement deactivate
  //
  //   super.deactivate();
  // }

  void callApi() async {
    if (widget.conversationId.isNotEmpty) {
      context
          .read<ConversationProvider>()
          .getChatMessage(widget.conversationId);
    } else {
      context
          .read<ConversationProvider>()
          .getChatMessageByReceiverId(widget.receiver.id);
    }
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
          toolbarHeight: 52.w,
          title: Container(
            margin: EdgeInsets.only(top: 12.h),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    widget.receiver.avatar ?? '',
                    width: 28.w,
                    height: 28.w,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  widget.receiver.fullName,
                  style: AppTextStyles.of(context).light20.copyWith(
                        color: AppColors.of(context).neutralColor12,
                        height: 1,
                      ),
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: !context.watch<ConversationProvider>().isLoadingChatMessage
            ? Column(
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                    reverse: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount:
                          context.watch<ConversationProvider>().messages.length,
                      itemBuilder: (context, index) {
                        final message = context
                            .watch<ConversationProvider>()
                            .messages[index];
                        final bool isMe =
                            message.senderId != widget.receiver.id;
                        return Container(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              containsImageTag(message.text!) != false
                                  ? Container(
                                      margin: EdgeInsets.only(
                                        top: 4.h,
                                        left: isMe ? 92.w : 8.w,
                                        right: !isMe ? 92.w : 8.w,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isMe
                                            ? AppColors.of(context)
                                                .primaryColor3
                                            : AppColors.of(context)
                                                .neutralColor4,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        message.text ?? '',
                                        style: AppTextStyles.of(context)
                                            .regular20
                                            .copyWith(
                                              color: AppColors.of(context)
                                                  .neutralColor12,
                                            ),
                                      ),
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(
                                        top: 4.h,
                                        // left: isMe ? 92.w : 8.w,
                                        // right: !isMe ? 92.w : 8.w,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          message.text!
                                              .replaceAll('[@isImg123@]', ''),
                                          width: 140.w,
                                          height: 140.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  )),
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
                      ),
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  String trimTrailingWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+$'), '');
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final trimmedText = trimTrailingWhitespace(_controller.text);
      final conversationProvider = context.read<ConversationProvider>();
      conversationProvider.sendMessage(widget.receiver.id, trimmedText);
      if (conversationProvider.isSending != true) {
        // if (widget.conversationId.isNotEmpty) {
        //   conversationProvider.getChatMessage(widget.conversationId);
        // } else {
        conversationProvider.getConversations();
        // }
      }

      _controller.clear();
    }
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hit_moments/app/datasource/local/storage.dart';
// import 'package:hit_moments/app/providers/conversation_provider.dart';
// import 'package:provider/provider.dart';

// import '../../../core/constants/assets.dart';
// import '../../../core/extensions/theme_extensions.dart';
// import '../../../l10n/l10n.dart';
// import '../../../models/user_model.dart';

// class ChatMessageView extends StatefulWidget {
//   const ChatMessageView(
//       {super.key, required this.conversationId, required this.receiver});
//   final String conversationId;
//   final User receiver;

//   @override
//   State<ChatMessageView> createState() => _ChatMessageViewState();
// }

// class _ChatMessageViewState extends State<ChatMessageView> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   // late IO.Socket socket;
//   // final StreamController<String> _streamController = StreamController<String>();

//   late String senderId;
//   // late ConversationProvider _appProvider;
//   @override
//   void initState() {
//     super.initState();
//     // _appProvider = Provider.of<ConversationProvider>(context, listen: false);
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       callApi();
//       print('id: ${getUserId()}');
//       // if (!_appProvider.socket.connected) {
//       //   _appProvider.connectAndListen();
//       // }
//     });
//   }

//   // @override
//   // void didChangeDependencies() {
//   //   super.didChangeDependencies();
//   // }

//   @override
//   void dispose() {
//     // _appProvider.disconnectSocket();
//     super.dispose();
//   }

//   bool containsImageTag(String text) {
//     return !text.contains('[@isImg123@]');
//   }
//   // @override
//   // void deactivate() {
//   //   // TODO: implement deactivate
//   //
//   //   super.deactivate();
//   // }

//   void callApi() async {
//     if (widget.conversationId.isNotEmpty) {
//       context
//           .read<ConversationProvider>()
//           .getChatMessage(widget.conversationId);
//     } else {
//       context
//           .read<ConversationProvider>()
//           .getChatMessageByReceiverId(widget.receiver.id);
//     }
//   }

//   void handleOnlineUsers(dynamic data) {
//     // Handle the list of online users
//     print('Online users: $data');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: true,
//           toolbarHeight: 56.w,
//           title: Container(
//             margin: EdgeInsets.only(top: 12.h),
//             child: Column(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(50),
//                   child: Image.network(
//                     widget.receiver.avatar ?? '',
//                     width: 28.w,
//                     height: 28.w,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Text(
//                   widget.receiver.fullName,
//                   style: AppTextStyles.of(context).light20.copyWith(
//                         color: AppColors.of(context).neutralColor12,
//                         height: 1,
//                       ),
//                 ),
//                 SizedBox(height: 8.h),
//               ],
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: !context.watch<ConversationProvider>().isLoadingChatMessage
//             ? Column(
//                 children: [
//                   Expanded(
//                       child: SingleChildScrollView(
//                     reverse: true,
//                     child: ListView.builder(
//                       controller: _scrollController,
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       scrollDirection: Axis.vertical,
//                       itemCount:
//                           context.watch<ConversationProvider>().messages.length,
//                       itemBuilder: (context, index) {
//                         final message = context
//                             .watch<ConversationProvider>()
//                             .messages[index];
//                         final bool isMe =
//                             message.senderId != widget.receiver.id;
//                         return Container(
//                           alignment: isMe
//                               ? Alignment.centerRight
//                               : Alignment.centerLeft,
//                           margin: EdgeInsets.only(
//                             top: 8.h,
//                             left: isMe ? 100.w : 12.w,
//                             right: !isMe ? 100.w : 12.w,
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             // crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               if (!isMe)
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(50),
//                                   child: Image.network(
//                                     widget.receiver.avatar ?? '',
//                                     width: 28.w,
//                                     height: 28.w,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               SizedBox(width: 8.w),
//                               Expanded(
//                                 child: containsImageTag(message.text!) != false
//                                     ? IntrinsicWidth(
//                                         child: Container(
//                                           padding: EdgeInsets.symmetric(
//                                             horizontal: 12.w,
//                                           ),
//                                           alignment: Alignment.center,
//                                           decoration: BoxDecoration(
//                                             color: isMe
//                                                 ? AppColors.of(context)
//                                                     .primaryColor3
//                                                 : AppColors.of(context)
//                                                     .neutralColor4,
//                                             borderRadius:
//                                                 BorderRadius.circular(15),
//                                           ),
//                                           child: Text(
//                                             message.text ?? '',
//                                             style: AppTextStyles.of(context)
//                                                 .regular20
//                                                 .copyWith(
//                                                   color: AppColors.of(context)
//                                                       .neutralColor12,
//                                                 ),
//                                           ),
//                                         ),
//                                       )
//                                     : Container(
//                                         margin: EdgeInsets.only(
//                                           top: 8.h,
//                                           // left: isMe ? 92.w : 8.w,
//                                           // right: !isMe ? 92.w : 8.w,
//                                         ),
//                                         // padding: EdgeInsets.symmetric(
//                                         //   horizontal: 12.w,
//                                         // ),
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                           child: Image.network(
//                                             message.text!
//                                                 .replaceAll('[@isImg123@]', ''),
//                                             width: 140.w,
//                                             height: 140.w,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   )),
//                   Container(
//                     margin: EdgeInsets.all(8.w),
//                     decoration: BoxDecoration(
//                       color: AppColors.of(context).neutralColor7,
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     child: Form(
//                       child: TextFormField(
//                         controller: _controller,
//                         decoration: InputDecoration(
//                           hintText: S.of(context).titleSendMessage,
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                               borderSide: BorderSide.none),
//                           suffixIcon: GestureDetector(
//                             onTap: _sendMessage,
//                             child: Container(
//                               width: 16.w,
//                               margin: EdgeInsets.only(right: 12.w),
//                               alignment: Alignment.center,
//                               child: SvgPicture.asset(
//                                 Assets.icons.sendSVG,
//                                 color: AppColors.of(context).neutralColor9,
//                                 width: 24.w,
//                                 height: 24.h,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             : const Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }

//   String trimTrailingWhitespace(String text) {
//     return text.replaceAll(RegExp(r'\s+$'), '');
//   }

//   void _sendMessage() async {
//     if (_controller.text.isNotEmpty) {
//       final trimmedText = trimTrailingWhitespace(_controller.text);
//       final conversationProvider = context.read<ConversationProvider>();
//       conversationProvider.sendMessage(widget.receiver.id, trimmedText);
//       if (conversationProvider.isSending != true) {
//         // if (widget.conversationId.isNotEmpty) {
//         //   conversationProvider.getChatMessage(widget.conversationId);
//         // } else {
//         conversationProvider.getConversations();
//         // }
//       }

//       _controller.clear();
//     }
//   }
// }
