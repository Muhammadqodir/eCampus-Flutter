import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:map_launcher/map_launcher.dart';

class MapMarkerModel {
  String title = "";
  String subTitle = "";
  Coords coords = Coords(0, 0);
  IconData icon = EcampusIcons.icons8_gym;
  Color color = Colors.black;

  MapMarkerModel(this.title, this.subTitle, this.coords, this.icon, this.color);

  Widget getView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color,
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
            EcampusIcons.icons8_forward,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }
}
