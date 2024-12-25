import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/custom/widgets/app_bar_widget.dart';
import 'package:hit_moments/app/l10n/l10n.dart';
import 'package:hit_moments/app/views/history/widgets/calendar_month.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late int _currentYear;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentYear = DateTime.now().year;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: S.of(context).history,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: ListView.builder(
            itemCount: 12,
            itemBuilder: (context, index) {
              int month = index+1;
              int totalDay = DateTime(_currentYear, month+1, 0).day;
              // tạo thành 1 string gồm tháng và năm
              String monthYear = "${S.of(context).month} $month, $_currentYear";
              return CustomGridWidget(
                totalDay: totalDay,
                month: month,
                monthYear: monthYear,
              );
            },
          ),
        ),
      ),
    );
  }
}
