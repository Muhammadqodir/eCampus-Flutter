// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'api_cubit.dart';

class ApiState {
  eCampus api;
  bool isPremium;
  ApiState(
    this.api, {
    this.isPremium = false,
  });

  ApiState copyWith({
    eCampus? api,
    bool? isPremium,
  }) {
    return ApiState(
      api ?? this.api,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}
