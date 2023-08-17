import 'package:flutter/material.dart';

class AvaList extends StatelessWidget {
  const AvaList({Key? key, required this.list}) : super(key: key);

  final Map<String, dynamic> list;

  String getAuthorInitials(String authorName) {
    List<String> split = authorName.split(" ");
    if (split.length < 2) {
      return "??";
    }
    return split[0][0] + split[1][0];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: list.keys
              .take(5)
              .map(
                (e) => Container(
                  width: 14,
                  height: 14,
                  transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.amber,
                    border: Border.all(width: 1.5, color: Colors.white),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    getAuthorInitials(e),
                    style: const TextStyle(
                      fontSize: 5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        Text(
          "+${list.length}",
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontSize: 10, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
