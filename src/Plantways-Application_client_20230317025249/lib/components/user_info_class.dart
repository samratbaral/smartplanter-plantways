class UserInfoClass {
  UserInfoClass({
    required this.username,
    required this.email,
    required this.password,
    required this.imagePath,
  });
  String username;
  String email;
  String password;
  String imagePath;
}

//test data for user
final UserInfoClass userInfo = UserInfoClass(
    username: 'username',
    email: 'email@gmail.com',
    password: 'password',
    imagePath: 'assets/avaters/Avatar 1.jpg');
