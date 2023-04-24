class UserInfoClass {
  UserInfoClass({
    required this.email,
    required this.password,
    required this.imagePath,
  });
  String email;
  String password;
  String imagePath;
}

//test data for user
final UserInfoClass userInfo = UserInfoClass(
    email: 'b@gmail.com',
    password: 'password',
    imagePath: 'assets/avaters/Avatar 1.jpg');
