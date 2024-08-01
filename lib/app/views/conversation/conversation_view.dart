import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/providers/conversation_provider.dart';
import 'package:hit_moments/app/views/conversation/components/chat_message_view.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/theme_extensions.dart';
import '../../l10n/l10n.dart';

class ConversationView extends StatefulWidget {
  const ConversationView({super.key});

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<ConversationProvider>().getConversations();
    });
  }
  String compareTime(DateTime inputTime) {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(inputTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} giây trước';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else {
      return '${difference.inDays} ngày trước';
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).message,
          style: AppTextStyles.of(context).bold32.copyWith(
                color: AppColors.of(context).neutralColor12,
              ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<ConversationProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.conversations.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatMessageView(
                                  conversationId: provider.conversations[index].id,
                                  receiver: provider.conversations[index].user,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 32.w,
                              vertical: 12.w,
                            ),
                            margin: EdgeInsets.only(top: 8.w),
                            decoration: BoxDecoration(
                              color: AppColors.of(context).neutralColor3,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.network(
                                    provider.conversations[index].user.avatar!,
                                    width: 40.w,
                                    height: 40.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Expanded(
                                  // Add this
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            provider.conversations[index].user.fullName,
                                            style: AppTextStyles.of(context)
                                                .regular20
                                                .copyWith(
                                                  color: AppColors.of(context)
                                                      .neutralColor12,
                                                ),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          provider.conversations[index].lastMessage
                                              ?.createdAt ==
                                              null ? SizedBox():
                                              Text(
                                              compareTime(provider.conversations[index].lastMessage!.createdAt!),
                                                style: AppTextStyles.of(context)
                                                  .light16
                                                  .copyWith(
                                                color: AppColors.of(context)
                                                    .neutralColor11,
                                              ),

                                              )
                                        ],
                                      ),
                                      provider.conversations[index].lastMessage
                                                  ?.text ==
                                              null
                                          ? Text(
                                              "Chưa có câu trả lời nào",
                                              style: AppTextStyles.of(context)
                                                  .light16
                                                  .copyWith(
                                                    color: AppColors.of(context)
                                                        .neutralColor11,
                                                  ),
                                            )
                                          : Text(
                                              provider.conversations[index]
                                                  .lastMessage!.text!,
                                              style: AppTextStyles.of(context)
                                                  .light16
                                                  .copyWith(
                                                    color: AppColors.of(context)
                                                        .neutralColor11,
                                                  ),
                                            ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
