import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:msap/features/login/login_page.dart';
import 'dart:developer';
import '../features/home/grades.dart';
import '../services/golain_api_services.dart';
import '../services/authentication_service.dart';
import 'dependency_injector.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  late bool isLoggedIn;
  GolainApiService golainApiService = GolainApiService();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState;
    checkAuth();

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(handleConnectivityChange);
  }

// Adjust this method to handle a list of ConnectivityResult
  void handleConnectivityChange(List<ConnectivityResult> resultList) {
    // Loop through the list and check if connected to mobile or Wi-Fi
    for (var result in resultList) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        // When internet is connected, sync the data
        golainApiService
            .syncEvaluationDataWithServer(); // Call your sync method here
        golainApiService.syncHiveDataWithApi();
        break; // Exit loop after first match
      }
    }
  }

  void checkAuth() async {
    print("Checking the checkAuth Log");
    try {
      await authenticationService.init();
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      isLoading = false;
    });
    if (authenticationService.userManager.currentUser == null) {
      setState(() {
        isLoggedIn = false;
      });
    } else {
      setState(() {
        apiService.setUserToken(
            authenticationService.userManager.currentUser!.token.accessToken!);
        log(authenticationService.userManager.currentUser!.token.accessToken
            .toString());
        isLoggedIn = true;
      });
    }
  }

  final AuthenticationService authenticationService =
      AppDependencyInjector.getIt.get();

  final GolainApiService apiService = AppDependencyInjector.getIt.get();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      home: (isLoading)
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : (isLoggedIn)
              ? HomeScreen()
              : LoginPage(),
    );
  }
}
