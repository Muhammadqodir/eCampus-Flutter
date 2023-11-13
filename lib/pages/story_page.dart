import 'package:ecampus_ncfu/cubit/api_cubit.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/inc/cross_button.dart';
import 'package:ecampus_ncfu/models/story_model.dart';
import 'package:ecampus_ncfu/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_view/story_view.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({
    Key? key,
    required this.models,
  }) : super(key: key);

  final List<StoryModel> models;

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  StoryController controller = StoryController();
  int selectedIndex = 0;
  List<StoryItem> items = [];
  @override
  void initState() {
    super.initState();
    items = widget.models
        .map(
          (e) => StoryItem.pageImage(
            url: e.url,
            imageFit: BoxFit.cover,
            duration: const Duration(seconds: 20),
            controller: controller,
          ),
        )
        .toList();
  }

  void viewStory(int id) async {
    ApiResponse<String> res = await context
        .read<ApiCubit>()
        .state
        .api
        .viewStory(widget.models[selectedIndex].id);
    if (res.isSuccess) {
      print("ViewSoty: " + res.data!);
    }else{
      print("ViewSoty: "+res.message);
    }
  }

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
                  storyItems: items,
                  controller: controller,
                  repeat: false,
                  onStoryShow: (s) {
                    viewStory(widget.models[selectedIndex].id);
                    try {
                      setState(() {
                        selectedIndex = items.indexOf(s);
                      });
                    } catch (e) {}
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
                // if (widget.models[selectedIndex].poll != null)
                //   Positioned(
                //     bottom: 0,
                //     left: 0,
                //     right: 0,
                //     child: Padding(
                //       padding: const EdgeInsets.all(12),
                //       child: PollWidget(
                //         poll: PollModel(
                //           title: widget.models[selectedIndex].poll!.title,
                //           options: widget.models[selectedIndex].poll!.options,
                //           stat: {},
                //         ),
                //       ),
                //     ),
                //   ),
                if (widget.models[selectedIndex].link != "")
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: CrossButton(
                        height: 50,
                        onPressed: () {
                          try {
                            launchUrlString(
                              widget.models[selectedIndex].link,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {}
                        },
                        backgroundColor: primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Перейти",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                            ),
                            const Icon(CupertinoIcons.arrow_up_right),
                          ],
                        ),
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
