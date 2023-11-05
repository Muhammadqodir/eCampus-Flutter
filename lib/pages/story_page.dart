import 'package:ecampus_ncfu/widgets/poll.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      backgroundColor: Colors.black,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                StoryView(
                  storyItems: [
                    StoryItem.pageImage(
                      url:
                          "https://i.pinimg.com/236x/f7/8a/e0/f78ae036a9310b8c24ab5d19ef67ea11.jpg",
                      imageFit: BoxFit.cover,
                      duration: const Duration(seconds: 20),
                      controller: controller,
                    ),
                  ],
                  controller: controller,
                  repeat: false,
                  onStoryShow: (s) {
                    print(s);
                  },
                  onComplete: () {
                    Navigator.of(context).pop();
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
                      options: [
                        "Вариант 1",
                        "Вариант 5",
                        "Вариант 2",
                        "Вариант 3"
                      ],
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
          ),
        ),
      ),
    );
  }
}
