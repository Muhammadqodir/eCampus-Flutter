import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:flutter/material.dart';

class SearchScheduleResult {
  String title;
  String url;
  int targetType;

  SearchScheduleResult(this.title, this.url, this.targetType);

  Widget getView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
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
