import 'package:bloc/bloc.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
part 'api_state.dart';

class ApiCubit extends Cubit<ApiState> {
  ApiCubit() : super(ApiState(eCampus("", "undefined", "undefined")));

  void setApiData(String token, String login, String password) {
    emit(ApiState(eCampus(login, password, token)));
  }

  void setApi(eCampus api) {
    emit(ApiState(api));
  }

  void setPremium(bool ispremium) {
    emit(state.copyWith(isPremium: ispremium));
  }

  eCampus getApi() {
    return state.api;
  }
}
