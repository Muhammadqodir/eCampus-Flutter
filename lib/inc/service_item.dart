import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceItem extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final String title;
  final String subTitle;
  final bool commingSoon;

  ServiceItem({
    required this.icon,
    required this.backgroundColor,
    required this.title,
    required this.subTitle,
    this.commingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    commingSoon
                        ? Expanded(
                            child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: CustomColors.error,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 1),
                                child: Text(
                                  "Скоро!",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                            ],
                          ))
                        : const SizedBox(),
                  ],
                ),
                Text(
                  subTitle,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          ),
          Icon(
            EcampusIcons.icons8_forward,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }
}
