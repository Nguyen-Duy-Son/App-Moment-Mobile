import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/providers/conversation_provider.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../core/constants/assets.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../l10n/l10n.dart';
import '../../../models/message_model.dart';
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
  late String senderId;

  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      callApi();
      print('id: ${getUserId()}');
      connect();
    });
  }

  void callApi() async {
    if(widget.conversationId.isNotEmpty){
      context.read<ConversationProvider>().getChatMessage(widget.conversationId);
    }
    else{
      context.read<ConversationProvider>().getChatMessageByReceiverId(widget.receiver.id);
    }
    // messages =
    //     Provider.of<ConversationProvider>(context, listen: false).messages;
    // var chatMessages =
    //     Provider.of<ConversationProvider>(context, listen: false).chatMessages;
    // var filteredMessages = chatMessages
    //     .where((element) => element.sender.id != widget.receiver.id);
    // if (filteredMessages.isNotEmpty) {
    //   senderId = filteredMessages.first.sender.id;
    // }
  }

  void connect() async{
    socket = IO.io('https://api.hitmoments.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query':{
        'userId': getUserId(),
      }
    });
    socket.on(
        'connection',
        (data) => {
              print('Connected to the server'),
            });
    socket.onConnect((_) {
      print('Connected to the server'); // Debug print
    });
    socket.on('newMessage', (data) {
      print('newMessage event triggered'); // Debug print
      messages.add(Message.fromJson(data));
      _streamController.add(data);
    });

    socket.onDisconnect((_) {
      print('Disconnected from the server'); // Debug print
    });
    socket.on('fromServer', (_) {
      print('fromServer event triggered'); // Debug print
    });

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
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<String>(
                stream: messagesStream,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    // var messageData = jsonDecode(snapshot.data!);
                    // var message = ChatMessage.fromJson(messageData);
                    // print('message: $message');
                    // context.read<ConversationProvider>().sendMessage(widget.conversationId,widget.receiver.id,_controller.text);
                    // context.read<ConversationProvider>().getChatMessage(widget.conversationId);
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return !context
                          .watch<ConversationProvider>()
                          .isLoadingChatMessage
                      ? SingleChildScrollView(
                          reverse: true,
                          child: ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: context
                                .watch<ConversationProvider>()
                                .messages
                                .length,
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
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 4.h,
                                        left: isMe ? 92.w : 8.w,
                                        right: !isMe ? 0 : 8.w,
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
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : const Center(child: CircularProgressIndicator());
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final conversationProvider = context.read<ConversationProvider>();
      conversationProvider.sendMessage(
          widget.conversationId, widget.receiver.id, _controller.text);
      if (conversationProvider.isSending != true) {
        socket.emit('newMessage', {
          'text': _controller.text,
        });
        context
            .read<ConversationProvider>()
            .getChatMessage(widget.conversationId);
        context.read<ConversationProvider>().getConversations();
      }
      _controller.clear();
    }
  }
}
