import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'scan_qr_code_state.dart';

class ScanQrCodeCubit extends Cubit<ScanQrCodeState> {
  ScanQrCodeCubit() : super(ScanQrCodeInitial());
}
