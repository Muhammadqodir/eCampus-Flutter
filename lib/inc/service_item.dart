import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceItem extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final String title;
  final String subTitle;

  ServiceItem({
    required this.icon,
    required this.backgroundColor,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(15)),
            child: Icon(icon),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
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
            Icons.arrow_forward_ios_outlined,
            color: Colors.grey,
          ),
        ],
      ),
    );
    // TODO: implement build
    throw UnimplementedError();
  }
}
