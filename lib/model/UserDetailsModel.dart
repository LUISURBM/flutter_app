class UserDetailsModel{
  final String name;
  final String skill;
  final String education;

  UserDetailsModel({this.name, this.skill, this.education});

  factory UserDetailsModel.fromJson(final json){
    return UserDetailsModel(
      name: json["name"],
      education: json["education"],
      skill: json["skill"]
    );
  }
}