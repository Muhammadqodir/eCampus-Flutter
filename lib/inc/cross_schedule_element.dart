import 'package:flutter/material.dart';

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
    this.backgroundColor = Colors.white,
    this.borderWidth = 0,
  }) : super(key: key);

  final String subName, room, timeStart, timeEnd, teacher, lessonType, group;
  final int para, teacherId, roomId;
  final bool current;
  final double? width, heigth;
  final double borderWidth;
  final Radius radius;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: heigth,
      child: Container(
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
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFDDF1EF),
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
                      )
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
    );
  }
}
