import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/l10n/l10n.dart';

class AutoSwitchImageRow extends StatefulWidget {
  final List<String?> images; // Danh sách URL ảnh

  const AutoSwitchImageRow({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  _AutoSwitchImageRowState createState() => _AutoSwitchImageRowState();
}

class _AutoSwitchImageRowState extends State<AutoSwitchImageRow> {
  int _currentIndex = 0; // Vị trí ảnh hiện tại
  Timer? _timer; // Timer để chuyển ảnh tự động

  @override
  void initState() {
    super.initState();
    _startImageSwitchTimer();
  }

  /// Khởi động Timer để chuyển ảnh mỗi 3 giây
  void _startImageSwitchTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (widget.images.isNotEmpty) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.images.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy Timer khi widget bị hủy
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.images.isNotEmpty
        ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10), // Bo tròn ảnh
          child: Container(
            width: 30.w, // Kích thước ảnh
            height: 30.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle, // Hình tròn
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500), // Thời gian hiệu ứng
              child: Image.network(
                widget.images[_currentIndex] ?? '', // Hiển thị ảnh hiện tại
                key: ValueKey<int>(_currentIndex), // Đảm bảo widget sẽ được tái tạo mỗi khi ảnh thay đổi
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/images/moment-default.png'), // Ảnh mặc định nếu có lỗi
              ),
            ),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          S.of(context).history,
          style: AppTextStyles.of(context).regular24.copyWith(
            color: AppColors.of(context).neutralColor12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    )
        : const SizedBox();
  }
}
