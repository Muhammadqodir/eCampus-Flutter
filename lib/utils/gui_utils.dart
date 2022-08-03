import 'package:flutter/material.dart';

Widget TextSkeleton({double height = 20, double width = double.infinity, Color color = Colors.black26}){
  return SizedBox(
            width: width,
            height: height,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
            ));
}

Widget CircleSkeleton({double radius = 20, Color color = Colors.black26}){
  return SizedBox(
          width: radius*2,
          height: radius*2,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        );
}