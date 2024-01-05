import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PremOptions extends StatefulWidget {
  const PremOptions({
    super.key,
    this.svgPath,
    required this.title,
    required this.description,
  });
  final String? svgPath;
  final String description;
  final String title;
  @override
  State<PremOptions> createState() => _PremOptionsState();
}

class _PremOptionsState extends State<PremOptions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15),
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: SvgPicture.asset(
                widget.svgPath ?? "images/user.svg",
                height: 24,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 13,
                              overflow: TextOverflow.ellipsis,
                            ),
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
