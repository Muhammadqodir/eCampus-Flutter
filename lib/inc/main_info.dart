import 'dart:typed_data';

import 'package:ecampus_ncfu/utils/gui_utils.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../ecampus_icons.dart';

class MainInfoView {
  Widget getAvaterView(Uint8List userPic) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black26,
              spreadRadius: 0,
            )
          ],
        ),
        child: CircleAvatar(
          radius: 45.0,
          backgroundImage: Image.memory(userPic).image,
        ),
      ),
    );
  }

  Widget getAvaterViewSkeleton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black26,
      highlightColor: Colors.black87,
      child: circleSkeleton(radius: 45),
    );
  }

  Widget getUserNameView(BuildContext context, String userName) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
        bottom: 12,
      ),
      child: Text(
        userName,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget getUserNameViewSkeleton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black26,
      highlightColor: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 12,
        ),
        child: textSkeleton(
          width: getWidthPercent(
            context,
            80,
          ),
        ),
      ),
    );
  }

  Widget getRatingBarView(
    BuildContext context, {
    double averageRating = -1,
    int groupRating = -1,
    int instituteRating = -1,
    int studentsNumberInGroup = -1,
    int studentsNumberInInstitute = -1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                const Icon(
                  EcampusIcons.icons8_star,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                  ),
                  child: Text(
                    averageRating.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Text(
                  "Средний балл",
                  maxLines: 1,
                  softWrap: false,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Icon(
                  EcampusIcons.icons8_leaderboard,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                  ),
                  child: Text(
                    "$groupRating из $studentsNumberInGroup",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Text(
                  "Место в группе",
                  maxLines: 1,
                  softWrap: false,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Icon(
                  EcampusIcons.icons8_university,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                  ),
                  child: Text(
                    "$instituteRating из $studentsNumberInInstitute",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Text(
                  "Место в Институте",
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getRatingBarViewSkeleton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black26,
      highlightColor: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  const Icon(
                    EcampusIcons.icons8_star,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: textSkeleton(
                      width: 40,
                    ),
                  ),
                  Text(
                    "Средний балл",
                    maxLines: 1,
                    softWrap: false,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Icon(EcampusIcons.icons8_leaderboard),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: textSkeleton(
                      width: 55,
                    ),
                  ),
                  Text(
                    "Место в группе",
                    maxLines: 1,
                    softWrap: false,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Icon(
                    EcampusIcons.icons8_university,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: textSkeleton(width: 60),
                  ),
                  Text(
                    "Место в Институте",
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
