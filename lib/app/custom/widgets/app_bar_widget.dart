import 'package:flutter/material.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppBarWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTextStyles.of(context)
                .regular32
                .copyWith(color: AppColors.of(context).neutralColor12),
          ),
          const SizedBox(width: 35),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
