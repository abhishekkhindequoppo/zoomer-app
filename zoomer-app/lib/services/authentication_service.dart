import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oidc/oidc.dart';
import 'package:oidc_default_store/oidc_default_store.dart';

class AuthenticationService {
  dynamic zitadelIssuer;
  late String zitadelClientId;
  late Map<String, dynamic> userInfo = {};

  final String callbackUrlScheme = 'com.ZOOMMER.msap';
  // final baseUri = Uri.base;
  late OidcUserManager userManager;

  AuthenticationService() {
    zitadelIssuer = Uri.parse(dotenv.env["ZITADEL_ENDPOINT"]!);
    zitadelClientId = dotenv.env["ZITADEL_CLIENT_ID"]!;
  }

  Future init() {
    var redirectUri = Uri(scheme: callbackUrlScheme, path: '/');
    redirectUri = Uri(
      scheme: "zoommerabcd",
      path: '/',
    );

    log(redirectUri.toString());
    userManager = OidcUserManager.lazy(
      discoveryDocumentUri:
          OidcUtils.getOpenIdConfigWellKnownUri(zitadelIssuer),
      clientCredentials:
          OidcClientAuthentication.none(clientId: zitadelClientId),
      store: OidcDefaultStore(),
      settings: OidcUserManagerSettings(
        redirectUri: redirectUri,
        // the same redirectUri can be used as for post logout too.
        postLogoutRedirectUri: redirectUri,
        scope: [
          'openid',
          'profile',
          'email',
          'offline_access',
          'urn:zitadel:iam:org:id:280676431762030597' //TODO: set env
        ],
      ),
    );
    return userManager.init();
  }

  Future login() async {
    print('Attempting login');
    try {
      final user = await userManager.loginAuthorizationCodeFlow();
      if (user == null) {
        print("Login failed");
        return null;
      } else {
        userInfo = user.userInfo;
        String? name = userInfo['name'];
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString('school_name', name!);
        if (name != null) {
          print('User logged in: $name');
        } else {
          print('Name not found in user info');
        }

        return user;
      }
    } catch (e) {
      print('Login error: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await userManager.logout();
      log('Logged out');
    } catch (e) {}
  }
}
