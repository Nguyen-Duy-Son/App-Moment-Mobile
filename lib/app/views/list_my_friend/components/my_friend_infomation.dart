// import 'package:flutter/material.dart';
//
// import '../../../models/user_model.dart';
//
// class MyFriendInfomationScreen extends StatefulWidget {
//   final User user;
//
//   MyFriendInfomationScreen({
//     required this.user,
//   });
//
//   @override
//   State<MyFriendInfomationScreen> createState() => _MyFriendInfomationScreenState();
// }
//
// class _MyFriendInfomationScreenState extends State<MyFriendInfomationScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Padding(
//           padding: EdgeInsets.only(top: 15.w),
//           child: const BackButton(
//             color: ColorConstants.neutralLight90,
//           ),
//         ),
//         title: Padding(
//           // Padding around the title for a similar effect
//           padding: EdgeInsets.only(top: 15.w),
//           child: Text(
//             AppLocalizations.of(context)!.friend,
//             style: AppTextStyles.of(context).bold32,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           // Padding(
//           //   padding: EdgeInsets.only(top: 15.w, right: 15.w),
//           //   child:
//           //   Stack(
//           //     clipBehavior: Clip.none,
//           //     children: [
//           //
//           //       InkWell(
//           //         onTap: () {
//           //           // showDialog(
//           //           //   context: context,
//           //           //   useSafeArea: true,
//           //           //   builder: (context) {
//           //           //     return ListFriendRequests(users: usersF);
//           //           //   },
//           //           // );
//           //
//           //         },
//           //         child: ClipRRect(
//           //           borderRadius: BorderRadius.circular(200),
//           //           child: Container(
//           //             decoration: const BoxDecoration(
//           //               color: ColorConstants.neutralLight70,
//           //             ),
//           //             padding: EdgeInsets.all(8.w),
//           //             child: SvgPicture.asset(
//           //               Assets.icons.bell,
//           //               width: 22.w,
//           //               height: 22.w,
//           //             ),
//           //           ),
//           //         ),
//           //       ),
//           //       Positioned(
//           //         right: 1.w,
//           //         top: -5.w,
//           //         child: Container(
//           //           alignment: Alignment.center,
//           //           decoration: BoxDecoration(
//           //             color: Colors.red,
//           //             borderRadius: BorderRadius.circular(50),
//           //           ),
//           //           width: 17.w,
//           //           height: 17.w,
//           //           child: Text(
//           //             '${friend.friendRequests?.length ?? 0}',
//           //             style: TextStyle(
//           //               color: ColorConstants.neutralLight10,
//           //               fontSize: 13.w,
//           //             ),
//           //             textAlign: TextAlign.center,
//           //           ),
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),
//           PopupMenuButton(
//             offset: const Offset(
//               -16,
//               64,
//             ),
//             shape: const TooltipShape(),
//             constraints:
//             BoxConstraints.expand(width: 0.8.sw, height: 0.4.sh),
//             padding: EdgeInsets.only(
//               top: 15.w,
//               right: 15.w,
//             ),
//             onOpened: () {
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 setState(() {
//                   checkOpacity = true;
//                 });
//               });
//             },
//             onCanceled: () {
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 setState(() {
//                   checkOpacity = false;
//                 });
//               });
//             },
//             icon: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(50),
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       color: ColorConstants.neutralLight70,
//                     ),
//                     padding: EdgeInsets.all(8.w),
//                     child: SvgPicture.asset(
//                       Assets.icons.bell,
//                       width: 20.w,
//                       height: 20.w,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   right: 1.w,
//                   top: -3.w,
//                   child: Container(
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       color: ColorConstants.accentRed,
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     width: 20.w,
//                     height: 20.w,
//                     child: Text(
//                       '${Provider.of<UserProvider>(context, listen: false).friendRequests.length ?? 0}',
//                       style: AppTextStyles.of(context).light16,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             itemBuilder: (_) =>
//                 _buildFriendRequestMenu(Provider.of<UserProvider>(context, listen: false).friendRequests),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             SizedBox(height: 16),
//             Text(widget.user.fullName, style: TextStyle(fontSize: 24)),
//             SizedBox(height: 16),
//             Text('Email: ${widget.user.email}'),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle message button press
//               },
//               child: Text('Message'),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle delete friend button press
//               },
//               child: Text('Delete Friend'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }