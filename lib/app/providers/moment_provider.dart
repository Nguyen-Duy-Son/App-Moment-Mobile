import 'package:flutter/cupertino.dart';

class MomentProvider extends ChangeNotifier{
  late List<Map<String, dynamic>> options;

  List<Map<String, dynamic>> getListFriend(){
    options = [
      {'menu': 'Option 1'},
      {'menu': 'Option 2'},
      {'menu': 'Option 3'},
      {'menu': 'Option 1'},
      {'menu': 'Option 2'},
      {'menu': 'Option 3'},
    ];
    return options;
  }


}