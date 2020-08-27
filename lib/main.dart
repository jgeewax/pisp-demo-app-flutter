import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pispapp/controllers/app/account_controller.dart';
import 'package:pispapp/controllers/app/auth_controller.dart';
import 'package:pispapp/controllers/ephemeral/dashboard/dashboard_controller.dart';
import 'package:pispapp/repositories/firebase/auth_repository.dart';
import 'package:pispapp/repositories/firebase/user_data_repository.dart';
import 'package:pispapp/repositories/stubs/stub_account_repository.dart';
import 'package:pispapp/routes/app_pages.dart';
import 'package:pispapp/routes/app_navigator.dart';
import 'package:pispapp/ui/theme/light_theme.dart';
import 'controllers/app/account_controller.dart';
import 'controllers/app/auth_controller.dart';
import 'controllers/app/user_data_controller.dart';
import 'controllers/ephemeral/local_auth_controller.dart';
import 'models/user.dart';

Future<void> main() async {
  // Ensures flutter binding is created even before runApp() so
  // binary messenger can be used for async code
  WidgetsFlutterBinding.ensureInitialized();

  initAppControllers();

  final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
  if(currentUser != null) {
    final User user = User.fromFirebase(currentUser, LoginType.google);
    Get.find<AuthController>().setUser(user);
    final UserDataController _userDataController = Get.put(UserDataController(UserDataRepository(), user));
    await _userDataController.loadAuxiliaryInfoForUser();
  }

  runApp(LifecycleAwareApp());
}

// Wrapper class to allow app-wide lifecycle listening
class LifecycleAwareApp extends StatefulWidget {
  @override
  _LifecycleAwareAppState createState() => _LifecycleAwareAppState();
}

class _LifecycleAwareAppState extends State<LifecycleAwareApp>
    // ignore: prefer_mixin
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // Show verification screen when app first starts
    Get.find<LocalAuthController>().appWasResumed();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Get.find<LocalAuthController>().appWasResumed();
        break;
      case AppLifecycleState.paused:
        Get.find<LocalAuthController>().appWasPaused();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Get.find<AuthController>().user == null ? '/' : 'dashboard', // TODO(kkzeng): goes to phone number if needed
      theme: appThemeData,
      defaultTransition: Transition.fade,
      getPages: AppPages.pages,
    );
  }
}

// Initialize controllers which maintain global app state
void initAppControllers() {
  Get.put(AuthController(AuthRepository()));
  Get.put(AccountController(StubAccountRepository()));
  Get.put(DashboardController());
  Get.put(AppNavigator());
  Get.put(LocalAuthController());
}
