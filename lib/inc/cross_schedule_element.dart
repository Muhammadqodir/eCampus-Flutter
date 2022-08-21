import 'package:flutter/material.dart';

import '../utils/gui_utils.dart';
import '../utils/system_info.dart';

class CrossScheduleElement extends StatelessWidget {
  const CrossScheduleElement({
    Key? key,
    required this.current,
    required this.group,
    required this.lessonType,
    required this.para,
    required this.room,
    required this.roomId,
    required this.subName,
    required this.teacher,
    required this.teacherId,
    required this.timeStart,
    required this.timeEnd,
    this.heigth,
    this.width = double.infinity,
    this.radius = Radius.zero,
    this.backgroundColor = Colors.transparent,
    this.borderWidth = 0,
    this.splashColor = Colors.white,
    this.onPressed,
  }) : super(key: key);

  final String subName, room, timeStart, timeEnd, teacher, lessonType, group;
  final int para, teacherId, roomId;
  final bool current;
  final double? width, heigth;
  final double borderWidth;
  final Radius radius;
  final Color backgroundColor, splashColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SystemInfo().isAndroid
        ? InkWell(
            onTap: onPressed ?? () {},
            splashColor: splashColor,
            borderRadius: BorderRadius.all(radius),
            child: Ink(
              width: width,
              height: heigth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(radius),
                color: backgroundColor,
                border: Border.all(
                  width: borderWidth,
                  color: backgroundColor,
                ),
              ),
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text(
                                para.toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              lessonType,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Text(
                              "$timeStart-$timeEnd",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      subName,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      teacher,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Text(
                          room,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        Text(
                          group,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : CupertinoInkWell(
            onPressed: onPressed ?? () {},
            child: Container(
              height: heigth,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(radius),
                color: backgroundColor,
                border: Border.all(
                  width: borderWidth,
                  color: backgroundColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Text(
                              para.toString(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            lessonType,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            "$timeStart-$timeEnd",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    subName,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    teacher,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: [
                      Text(
                        room,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      Text(
                        group,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
