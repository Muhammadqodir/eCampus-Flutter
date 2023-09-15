import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/utils/gui_utils.dart';
import 'package:ecampus_ncfu/widgets/poll.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  StoryController controller = StoryController();
  List<StoryItem> items = [
    StoryItem.pageImage(
      url:
          "https://i.pinimg.com/1200x/7f/ed/78/7fed782d743fa1279ab2990aeb7e9fae.jpg",
      controller: StoryController(),
      imageFit: BoxFit.cover,
      duration: const Duration(seconds: 15),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StoryView(
            storyItems: items,
            controller: controller,
            repeat: true,
            onStoryShow: (s) {
              print(s);
            },
            onComplete: () {
              print("Story: Completed");
            },
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) {
                Navigator.pop(context);
              }
            },
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: PollWidget(
              title: "Вопросс",
              options: ["Вариант 1", "Вариант 5", "Вариант 2", "Вариант 3"],
              pollId: 45,
              stat: {
                "Вариант 1": 5,
                "Вариант 4": 5,
                "Вариант 2": 5,
                "Вариант 3": 5,
              },
            ),
          ),
        ],
      ),
    );
  }
}
