// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecampus_ncfu/widgets/poll.dart';

class StoryModel {
  String title;
  String url;
  PollModel poll;
  String views;
  StoryModel({
    required this.title,
    required this.url,
    required this.poll,
    required this.views,
  });
}