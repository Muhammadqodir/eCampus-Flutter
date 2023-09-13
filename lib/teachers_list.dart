import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecampus_ncfu/pages/teachers_page.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class TeachersList {
  List<DocumentSnapshot> documentList;

  late BehaviorSubject<List<DocumentSnapshot>> movieController;

  TeachersList(
    this.documentList,
  ) {
    movieController = BehaviorSubject<List<DocumentSnapshot>>();
  }

  Stream<List<DocumentSnapshot>> get movieStream => movieController.stream;

  String searchQ = "";
  Future fetchFirstList({String q = ""}) async {
    searchQ = "";
    try {
      documentList = (await FirebaseFirestore.instance
              .collection("teachers")
              .orderBy("fullName")
              .where("fullName", isGreaterThanOrEqualTo: q.capitalize())
              .limit(10)
              .get())
          .docs;
      print("Result: "+documentList.length.toString());
      movieController.sink.add(documentList);
    } on SocketException {
      movieController.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      movieController.sink.addError(e);
    }
  }

/*This will automatically fetch the next 10 elements from the list*/
  fetchNextMovies() async {
    try {
      List<DocumentSnapshot> newDocumentList = (await FirebaseFirestore.instance
              .collection("teachers")
              .orderBy("fullName")
              .where("fullName", isGreaterThanOrEqualTo: searchQ.capitalize)
              .startAfterDocument(documentList[documentList.length - 1])
              .limit(10)
              .get())
          .docs;
      print("Next:"+newDocumentList.length.toString());
      documentList.addAll(newDocumentList);
      movieController.sink.add(documentList);
    } on SocketException {
      movieController.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      movieController.sink.addError(e);
    }
  }

  void dispose() {
    movieController.close();
  }

  @override
  bool operator ==(covariant TeachersList other) {
    if (identical(this, other)) return true;

    return listEquals(other.documentList, documentList) &&
        other.movieController == movieController;
  }

  @override
  int get hashCode => documentList.hashCode ^ movieController.hashCode;
}
