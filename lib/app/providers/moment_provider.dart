import 'package:flutter/cupertino.dart';
import 'package:hit_moments/app/datasource/network_services/moment_service.dart';
import 'package:hit_moments/app/models/moment_model.dart';

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

  Future<List<MomentModel>> getListMoment() async{
    final response = await MomentService().getListMoment();
    if(response is List<MomentModel>){
      return response;
    }else{
      return [];
    }

  }


}