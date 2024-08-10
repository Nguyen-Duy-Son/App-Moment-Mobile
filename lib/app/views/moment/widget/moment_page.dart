import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/config/enum.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../models/moment_model.dart';
import '../../../providers/list_moment_provider.dart';
import '../../suggested_friends/suggested_friends_view.dart';

// class MomentPage extends StatefulWidget {
//   const MomentPage({super.key, required, required this.pageViewController, required this.listMoment, required this.list });
//   final PageController pageViewController;
//   final List<MomentModel> listMoment;
//   final List<Widget> list;
//   @override
//   State<MomentPage> createState() => _MomentPageState();
// }
//
// class _MomentPageState extends State<MomentPage> {
//   bool isLoadingMore = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: widget.,
//     );
//   }
// }
