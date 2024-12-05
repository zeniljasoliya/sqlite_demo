// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserData {
  int? id;
  String username;
  UserData({
    this.id,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] != null ? map['id'] as int : null,
      username: map['username'] as String,
    );
  }
}
