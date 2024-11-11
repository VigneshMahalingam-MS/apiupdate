class User {
  final String fname;
  final String lname;
  final String email;
  // final String phone;
  // final String password;

  User({
    required this.fname,
    required this.lname,
    required this.email,
    // required this.phone,
    // required this.password
  });
  User.copy(User user)
      : fname = user.fname,
        lname = user.lname,
        email = user.email;

  Map<String, dynamic> toJson() {
    return {
      'fname': fname,
      'lname': lname,
      'email': email
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fname: json['fname'],
      lname: json['lname'],
       email: json['email'],
      // phone: json['phone'],
      // password: json['password']
    );
  }
}
