class Login {
  final String email;
  final String pass;
  final String phonenumber;
  final String name;

  Login(this.email, this.pass, this.name, this.phonenumber);

  Login.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        pass = json['password'],
        name = json['name'],
        phonenumber = json['phonenumber'];


  Map<String, dynamic> toJson() => {
        'email': email,
        'pass': pass,
        'name': name,
        'phonnumber' : phonenumber,
      };
}