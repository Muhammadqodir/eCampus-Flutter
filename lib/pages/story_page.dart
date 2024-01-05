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
  bool firstOpen = true;
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
    ApiResponse<String> res =
        await context.read<ApiCubit>().state.api.viewStory(id);
    if (res.isSuccess) {
      print("ViewSoty: " + res.data!);
    } else {
      print("ViewSoty: " + res.message);
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: StoryView(
                      storyItems: items,
                      controller: controller,
                      repeat: false,
                      onStoryShow: (s) {
                        if (widget.models[items.indexOf(s)].views.contains(
                                context.read<ApiCubit>().state.api.login) &&
                            firstOpen) {
                          controller.next();
                          if (widget.models.length - 1 == items.indexOf(s)) {
                            setState(() {
                              firstOpen = false;
                            });
                          }
                        } else {
                          print("StoryId: " +
                              widget.models[items.indexOf(s)].id.toString());
                          viewStory(widget.models[items.indexOf(s)].id);
                          try {
                            setState(() {
                              selectedIndex = items.indexOf(s);
                              firstOpen = false;
                            });
                          } catch (e) {}
                        }
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
                  ),
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
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: CrossButton(
                        height: 50,
                        onPressed: () async {
                          try {
                            launchUrlString(
                              widget.models[selectedIndex].link,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {}
                          ApiResponse<String> res = await context
                              .read<ApiCubit>()
                              .state
                              .api
                              .answerStory(widget.models[selectedIndex].id,
                                  "referral_click");
                          if (res.isSuccess) {
                            print("ClickSoty: " + res.data!);
                          } else {
                            print("ClickSoty: " + res.message);
                          }
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
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.eye,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          ";"
                              .allMatches(widget.models[selectedIndex].views)
                              .length
                              .toString(),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const Expanded(
                          child: Row(
                            children: [],
                          ),
                        ),
                      ],
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
