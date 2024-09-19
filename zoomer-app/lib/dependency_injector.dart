import 'package:get_it/get_it.dart';

import 'services/authentication_service.dart';
import 'services/golain_api_services.dart';

class AppDependencyInjector {
  static final getIt = GetIt.instance;
  static void setUpAppDependencies() {
    getAuthService();
    getApiService();
  }

  static void getApiService() {
    getIt.registerLazySingleton<GolainApiService>(() => GolainApiService());
  }

  static void getAuthService() {
    getIt.registerLazySingleton<AuthenticationService>(
        () => AuthenticationService());
  }
}
