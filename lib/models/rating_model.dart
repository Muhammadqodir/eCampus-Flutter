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

  factory RatingModel.fromJson(Map<String, dynamic> json) => _$RatingModelFromJson(json);

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
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  '17',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 250,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Иванов Иван Иванович',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                EcampusIcons.icons8_star,
                                size: 21,
                              ),
                              Text(
                                '89.21',
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                EcampusIcons.icons8_university,
                                size: 21,
                              ),
                              Text('280 из 890')
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
