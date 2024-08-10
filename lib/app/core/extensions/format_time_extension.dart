import 'package:flutter/cupertino.dart';

import '../../l10n/l10n.dart';

class FormatTimeExtension{
  String formatTimeDifference(DateTime createdAt, BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${S.of(context).daysAgo}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${S.of(context).hoursAgo}';
    } else {
      return '${difference.inMinutes} ${S.of(context).minutesAgo}';
    }
  }
}