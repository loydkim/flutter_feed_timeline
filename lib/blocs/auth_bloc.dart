import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

//유저 정보를 여기에 담아서 모든 페이지에서 provider로 공유?
class AuthBloc {
  final authService = AuthService();
  final fb = FacebookLogin();

  Stream<auth.User> get currentUser => authService.currentUser;

  loginFacebook() async {
    print('Starting Facebook Login');

    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);

    switch (res.status) {
      case FacebookLoginStatus.Success:
        print('It worked');

        //Get Token
        final FacebookAccessToken fbToken = res.accessToken;

        //Convert to Auth Credential
        final auth.AuthCredential credential =
            auth.FacebookAuthProvider.credential(fbToken.token);

        //User Credential to Sign in with Firebase
        final result = await authService.signInWithCredentail(credential);

        print('${result.user.displayName} is now logged in');

        break;
      case FacebookLoginStatus.Cancel:
        print('The user canceled the login');
        break;
      case FacebookLoginStatus.Error:
        print('There was an error');
        break;
    }
  }

  logout() {
    authService.logout();
  }
}

//any interaction with firebase here

class AuthService {
  final _auth = auth.FirebaseAuth.instance;

  //user들이 로그인했는지 아웃했는지를 모니터링?
  Stream<auth.User> get currentUser => _auth.authStateChanges();
  //generic fuction으로 페이스북으로 하든 구글로 로그인 하든 관계없이 firebase에 사인할 수 있도록
  Future<auth.UserCredential> signInWithCredentail(
          auth.AuthCredential credential) =>
      _auth.signInWithCredential(credential);
  Future<void> logout() => _auth.signOut();
}
