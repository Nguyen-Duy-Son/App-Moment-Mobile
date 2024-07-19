import 'package:hit_moments/app/core/base/base_connect.dart';
import 'package:hit_moments/app/core/config/api_url.dart';
import 'package:hit_moments/app/models/moment_model.dart';


class MomentService{

  Future<dynamic> getListMoment() async{
    try{
      final response = await BaseConnect.onRequest(
          ApiUrl.getListMoment,
          RequestMethod.GET
      );
      int statusCode = response['statusCode'];
      if(statusCode==200){
        final dataList = response['data']['moments'];
         return (dataList is List ? dataList:[])
             .map((e) => MomentModel.fromJson(e))
             .toList();
      }else{
        return [];
      }
    }catch(e){
      return e.toString();
    }


  }
}