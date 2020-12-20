import 'dart:convert';

List<Programmer> programmerFromJson(String str) =>
    List<Programmer>.from(json.decode(str).map((x) => Programmer.fromJson(x)));

String programmerToJson(List<Programmer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Programmer {
  int id;
  String email;
  String firstName;
  String lastName;
  String technologies;
  int yearsExperience;

  Programmer(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.technologies,
      this.yearsExperience});

  factory Programmer.fromJson(Map<String, dynamic> json) => Programmer(
      id: json["id"],
      email: json["email"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      technologies: json["technologies"],
      yearsExperience: json["yearsExperience"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "technologies": technologies,
        "yearsExperience": yearsExperience
      };
}
