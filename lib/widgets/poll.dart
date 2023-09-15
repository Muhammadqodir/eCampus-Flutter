import 'package:ecampus_ncfu/inc/ontap_scale.dart';
import 'package:ecampus_ncfu/themes.dart';
import 'package:flutter/material.dart';

class PollWidget extends StatefulWidget {
  const PollWidget({
    super.key,
    required this.title,
    required this.options,
    required this.pollId,
    required this.stat,
  });

  final String title;
  final List<String> options;
  final Map<String, int> stat;
  final int pollId;

  @override
  State<PollWidget> createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Column(
            children: widget.options
                .map(
                  (e) => OnTapScaleAndFade(
                    lowerBound: 0.95,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: primaryColor.withAlpha(100),
                      ),
                      child: Text(
                        e,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    onTap: () {},
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
