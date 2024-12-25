import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hit_moments/app/core/enum/load_status.dart';
import 'package:hit_moments/app/datasource/network_services/forgot_password_service.dart';
import 'package:meta/meta.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {

  ForgotPasswordCubit() : super(const ForgotPasswordState());

  void onChangePassword(String password) {
    emit(state.copyWith(password: password.trim()));
  }
  Future<void> sendVerifyEmail(String email) async {
    emit(state.copyWith(sendVerifyEmailStatus: LoadStatus.LOADING));
    try {
      // Call API
      final response = await ForgotPasswordService.forgotPassword(email);
      if(response["statusCode"]==200){
        emit(state.copyWith(sendVerifyEmailStatus: LoadStatus.SUCCESS));
        return;
      }
      else{
        emit(state.copyWith(sendVerifyEmailStatus: LoadStatus.FAILURE, msgSendVerifyEmail: response["message"]));
        return;
      }
    } catch (e) {
      emit(state.copyWith(sendVerifyEmailStatus: LoadStatus.FAILURE, msgSendVerifyEmail: e.toString()));
      return;
    }
  }

}