import 'package:ecampus_ncfu/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeacherReview {
  String id;
  String author;
  String date;
  List<String> likes = [];
  String message;
  String target;
  String authorName = "";

  TeacherReview(this.id, this.author, this.date, this.message, this.target);

  setAuthorName(String name) {
    authorName = name;
  }

  setLikes(List<String> l) {
    likes.addAll(l);
  }

  addLike(String like) {
    likes.add(like);
  }

  String getAuthorInitials(){
    List<String> split = authorName.split(" ");
    if(split.length < 2){
      return "??";
    }
    return split[0][0] + split[1][0];
  }

  Widget getView(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              getAuthorInitials(),
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(width: 12,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  authorName,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  message,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    date,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
