// app/views/moment/moment_view.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/custom/widgets/icon_on_tap_scale.dart';
import 'package:hit_moments/app/providers/list_moment_provider.dart';
import 'package:hit_moments/app/views/moment/widget/grid_view_moment.dart';
import 'package:hit_moments/app/views/moment/widget/moment_page.dart';
import 'package:hit_moments/app/views/moment/widget/moment_widget.dart';
import 'package:hit_moments/app/views/moment/widget/select_friend_widget.dart';
import 'package:hit_moments/app/views/suggested_friends/suggested_friends_view.dart';
import 'package:provider/provider.dart';

import '../../models/moment_model.dart';

class MomentView extends StatefulWidget {
  const MomentView({super.key});

  @override
  State<MomentView> createState() => _MomentViewState();
}

class _MomentViewState extends State<MomentView> {
  List<MomentModel> listMoment = [];

  PageController pageViewController = PageController();
  List<Widget> _list = [];
  @override
  void initState() {
    super.initState();

    context.read<ListMomentProvider>().getListFriendOfUser();
    context.read<ListMomentProvider>().getWeather('21.0314268', '105.7792771');
    pageViewController.addListener(() {
      if (pageViewController.position.atEdge) {
        print('Cuối cùng');
        bool isBottom = pageViewController.position.pixels != 0;
        if (isBottom) {
          context.read<ListMomentProvider>().loadMoreListMoment();
        }
      }
    });

    // Initialize the moments list
    setPageView();
  }

  Future<void> setPageView() async {
    await context.read<ListMomentProvider>().getListMoment();
    if (context.read<ListMomentProvider>().getListMomentStatus == ModuleStatus.success) {
      listMoment = context.read<ListMomentProvider>().momentList;
      _list = listMoment.map((e) => MomentWidget(momentModel: e, pageViewController: pageViewController)).toList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final listMomentProvider = context.watch<ListMomentProvider>();
    if(listMomentProvider.loadMoreStatus==ModuleStatus.success){
      listMoment = context.read<ListMomentProvider>().momentList;
      _list = listMoment.map((e) => MomentWidget(momentModel: e, pageViewController: pageViewController)).toList();
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.w, bottom: 8.w),
            child: IconOnTapScale(
              icon1Path: Assets.icons.plusSVG,
              backGroundColor: AppColors.of(context).neutralColor6,
              icon1Color: AppColors.of(context).neutralColor10,
              iconHeight: 15.w,
              iconWidth: 15.w,
              onPress: () {},
            ),
          ),
          backgroundColor: Colors.white,
          title: SelectFriendWidget(
            friendSelected: (friendSelected) {
              context.read<ListMomentProvider>().getListMomentByUserID(friendSelected);
            },
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: IconOnTapScale(
                icon1Path: Assets.icons.layersSVG,
                backGroundColor: AppColors.of(context).neutralColor6,
                icon1Color: AppColors.of(context).neutralColor10,
                iconHeight: 20.w,
                iconWidth: 20.w,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return GridViewMoment(
                        listMoment: listMoment,
                        onSelected: (moment, index) {
                          pageViewController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                          );
                        },
                      );
                    },
                  ));
                },
              ),
            ),
          ],
        ),
        body: _list.isEmpty
            ? Center(
          child: Text(
            "Không có bài đăng nào!",
            style: AppTextStyles.of(context).regular20.copyWith(
              color: AppColors.of(context).neutralColor11,
            ),
          ),
        )
            : Column(
          children: [
            Expanded(
              child: PageView(
                children: [
                  ..._list,
                  if (listMomentProvider.loadMoreStatus == ModuleStatus.fail)
                    SuggestedFriendsView(),
                ],
                controller: pageViewController,
                scrollDirection: Axis.vertical,
              ),
            ),
            if (listMomentProvider.loadMoreStatus == ModuleStatus.loading)
              CupertinoActivityIndicator(
                color: Colors.red,
                radius: 15,
              ),
          ],
        )
      ),
    );
  }
}
