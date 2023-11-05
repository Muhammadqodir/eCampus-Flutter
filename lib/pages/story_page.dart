import 'package:ecampus_ncfu/widgets/poll.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({
    Key? key,
    required this.models,
  }) : super(key: key);

  final List<StoryItem> models;

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  StoryController controller = StoryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StoryView(
            storyItems: [],
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: PollWidget(
              poll: PollModel(
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
          ),
        ],
      ),
    );
  }
}
