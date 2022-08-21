import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/material.dart';

import '../utils/gui_utils.dart';
import '../utils/system_info.dart';

class CrossNotificationElement extends StatelessWidget {
  const CrossNotificationElement({
    Key? key,
    required this.activityKindColor,
    required this.dateOfReading,
    required this.image,
    required this.message,
    required this.title,
    required this.activityKindIcon,
    this.heigth,
    this.width = double.infinity,
    this.radius = Radius.zero,
    this.backgroundColor = Colors.transparent,
    this.borderWidth = 0,
    this.splashColor = Colors.white,
    this.onPressed,
  }) : super(key: key);

  final String title, message, dateOfReading, activityKindColor, activityKindIcon;
  final Image image;
  final void Function()? onPressed;
  final double? width, heigth;
  final double borderWidth;
  final Radius radius;
  final Color backgroundColor, splashColor;

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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Stack(
                          children: <Widget>[
                            ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(24), // Image radius
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: HexColor.fromHex(activityKindColor).withAlpha(200),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: image,
                                  ),
                                ),
                              ),
                            ),
                            dateOfReading == "unread"
                                ? Positioned(
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 12,
                                        minHeight: 12,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                message,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                ],
              ),
            ),
          )
        : Column(
            children: [
              CupertinoInkWell(
                onPressed: (() {}),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Stack(
                        children: <Widget>[
                          ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(24), // Image radius
                              child: Container(
                                decoration: BoxDecoration(
                                  color: HexColor.fromHex(activityKindColor).withAlpha(200),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: image,
                                ),
                              ),
                            ),
                          ),
                          dateOfReading == "unread"
                              ? Positioned(
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              message,
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 1,
              )
            ],
          );
  }
}
