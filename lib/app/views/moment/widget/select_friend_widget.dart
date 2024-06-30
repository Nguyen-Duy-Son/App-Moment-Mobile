import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/custom/widgets/popup_menu_select.dart';

import '../../../core/extensions/theme_extensions.dart';
import '../../../custom/widgets/scale_on_tap_widget.dart';
import 'dialog_select_friend.dart';

class SelectFriendWidget extends StatefulWidget {
  const SelectFriendWidget({super.key});

  @override
  State<SelectFriendWidget> createState() => _SelectFriendWidgetState();
}

class _SelectFriendWidgetState extends State<SelectFriendWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isChangeColor = false;
  Future<void> _showDialogSelectFriend(BuildContext context) async{
    showDialog(
      context: context,
      builder: (context) {
        return DialogSelectFriend(
            options:  [
              {'menu': 'Option 1'},
              {'menu': 'Option 2'},
              {'menu': 'Option 3'},
              {'menu': 'Option 1'},
              {'menu': 'Option 2'},
              {'menu': 'Option 3'},
            ],
          isBack: () {
            setState(() {
              _isChangeColor = !_isChangeColor;
            });
            if(!_isChangeColor){
              _controller..reverse(from: 0.5);

            }else{
              _controller..forward(from: 0.0);
            }
          },
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      upperBound: 0.5,
    );
  }
  @override
  Widget build(BuildContext context) {
    return ScaleOnTapWidget(
      onTap: (isSelect) {
        setState(() {
          _isChangeColor = !_isChangeColor;
        });
        if(!_isChangeColor){
          _controller..reverse(from: 0.5);

        }else{
          _controller..forward(from: 0.0);
        }
        _showDialogSelectFriend(context);

      },
        child: Container(
            padding: EdgeInsets.only(left: 24,top: 4, right: 24,),
            decoration: BoxDecoration(
                color: AppColors.of(context).neutralColor6,
                borderRadius: BorderRadius.all(Radius.circular(100)),
                border: Border.all(
                    color: _isChangeColor?AppColors.of(context).primaryColor8:AppColors.of(context).neutralColor6,
                    width: 1
                )
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Tất cả",
                  style: AppTextStyles.of(context).regular24.copyWith(
                      color: AppColors.of(context).neutralColor11
                  ),),
                SizedBox(width: 8,),
                Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: RotationTransition(
                   turns: Tween(begin: 1.0, end: 0.0).animate(_controller),
                    child: SvgPicture.asset("assets/icons/Down.svg",
                      color: AppColors.of(context).neutralColor10,),
                  ),
                )
              ],
            )
        )


    );
  }
}
