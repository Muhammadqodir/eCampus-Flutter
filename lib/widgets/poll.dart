// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:ecampus_ncfu/inc/ontap_scale.dart';
import 'package:ecampus_ncfu/themes.dart';

class PollWidget extends StatefulWidget {
  const PollWidget({
    super.key,
    required this.poll,
  });

  final PollModel poll;

  @override
  State<PollWidget> createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.poll.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Column(
            children: widget.poll.options
                .map(
                  (e) => OnTapScaleAndFade(
                    lowerBound: 0.97,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
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

class PollModel {
  final String title;
  final List<String> options;
  final Map<String, int> stat;
  // final int pollId;

  PollModel({
    required this.title,
    required this.options,
    required this.stat,
    // required this.pollId,
  });
}
