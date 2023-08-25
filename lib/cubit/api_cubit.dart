import 'package:bloc/bloc.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';

part 'api_state.dart';

class ApiCubit extends Cubit<ApiState> {
  ApiCubit() : super(ApiState(eCampus("")));

  void setApiToken(String token){
    emit(ApiState(eCampus(token)));
  }

  void setApi(eCampus api){
    emit(ApiState(api));
  }
}
