import 'package:ecampus_ncfu/models/rating_model.dart';
import 'package:flutter/material.dart';

double getWidthPercent(BuildContext context, int percent){
  return MediaQuery.of(context).size.width * (percent/100);
}

double getHeightPercent(BuildContext context, int percent){
  return MediaQuery.of(context).size.height * (percent/100);
}

RatingModel getMyRating(List<RatingModel> models){
  RatingModel model = RatingModel("undefined", -1, -1, -1, -1, -1, true);
  models.forEach((element) {
    if(element.isCurrent){
      model = element;
    }
  });
  return model;
}