// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingModel _$RatingModelFromJson(Map<String, dynamic> json) => RatingModel(
      json['fullName'] as String,
      (json['ball'] as num).toDouble(),
      json['ratGroup'] as int,
      json['ratInst'] as int,
      json['maxPosGroup'] as int,
      json['maxPosInst'] as int,
      json['isCurrent'] as bool,
    );

Map<String, dynamic> _$RatingModelToJson(RatingModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'ratGroup': instance.ratGroup,
      'ratInst': instance.ratInst,
      'ball': instance.ball,
      'isCurrent': instance.isCurrent,
      'maxPosInst': instance.maxPosInst,
      'maxPosGroup': instance.maxPosGroup,
    };
