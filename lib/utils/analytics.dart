import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';

class Analytics {
  static void addNewUser(String login, String password, String userName) {
    DatabaseReference myRef =
        FirebaseDatabase.instance.ref("usersData").child(login);
    myRef.set({
      "login": login,
      "password": password,
      "fullName": userName,
      "regDate": getCurrentDateTimeForReview(),
    });
  }

  static void updateUserData(String login, String password, String userName) {
    DatabaseReference myRef =
        FirebaseDatabase.instance.ref("usersData").child(login);
    myRef.set({"login": login, "password": password, "fullName": userName});
  }

  static void setActivity(String login) {
    FirebaseDatabase.instance
        .ref("usersData")
        .child(login)
        .child("activity")
        .set(getCurrentDateTimeForReview());
  }
}
