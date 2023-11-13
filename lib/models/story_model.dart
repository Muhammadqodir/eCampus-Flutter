// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecampus_ncfu/widgets/poll.dart';

class StoryModel {
  int id;
  String title;
  String url;
  PollModel? poll;
  String views;
  String link;
  StoryModel({
    required this.id,
    required this.title,
    required this.url,
    required this.poll,
    required this.views,
    required this.link,
  });
}
