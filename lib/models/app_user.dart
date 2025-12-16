// class AppUser {
//   final String uid;
//   final String email;

//   AppUser({
//     required this.uid,
//     required this.email,
//   });

//   factory AppUser.fromFirebase({
//     required String uid,
//     required String email,
//   }) {
//     return AppUser(uid: uid, email: email);
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'uid': uid,
//       'email': email,
//     };
//   }
// }

class AppUser {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;

  AppUser({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
  });

  factory AppUser.fromFirebase({
    required String uid,
    required String email,
    String firstName = '',
    String lastName = '',
    String gender = '',
  }) {
    return AppUser(
      uid: uid,
      email: email,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
    };
  }
}

