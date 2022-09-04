import 'dart:ui';

import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rating_model.g.dart';

@JsonSerializable()
class RatingModel {
  String fullName = "";
  int ratGroup = -1;
  int ratInst = -1;
  double ball = -1;
  bool isCurrent = false;
  int maxPosInst = -1;
  int maxPosGroup = -1;

  RatingModel.buildDefault();

  RatingModel(this.fullName, this.ball, this.ratGroup, this.ratInst,
      this.maxPosGroup, this.maxPosInst, this.isCurrent);

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);

  Map<String, dynamic> toJson() => _$RatingModelToJson(this);

  Widget getView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  ratGroup.toString(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                EcampusIcons.icons8_star,
                                size: 22,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                ball.toStringAsFixed(2),
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                EcampusIcons.icons8_university,
                                size: 22,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                '${ratInst} из ${maxPosInst}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
