import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:personal_financial/presentationColor/providers/theme_provider.dart';
import 'package:personal_financial/presentationColor/styles/app_themes.dart';
import 'package:personal_financial/servicesColor/service_locator.dart';
import 'package:personal_financial/servicesColor/storage/storage_service.dart';
import 'package:personal_financial/setting/colors.dart';
import 'package:personal_financial/setting/security.dart';
import 'package:personal_financial/setting/setting.dart';
import 'package:personal_financial/views/get_start.dart';
import 'package:personal_financial/views/login.dart';
import 'package:personal_financial/views/register.dart';
import 'package:personal_financial/views/saving_add.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/addInOut.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runZonedGuarded<Future<void>>(() async {
    setUpServiceLocator();

    final StorageService storageService = getIt<StorageService>();
    await storageService.init();

    runApp(MyApp(
      storageService: storageService,
    ));
  }, (e, _) => throw e);
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  const MyApp({
    Key? key,
    required this.storageService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ThemeProvider(storageService),
          )
        ],
        child: Consumer<ThemeProvider>(
          builder: (c, themeProvider, home) => MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) => const GetStartPage(),
              '/register': (context) => const RegisterPage(),
              '/login': (context) => const LoginPage(),
              '/home': (context) => const MyHomePage(),
              '/setting': (context) => const SettingPage(),
              '/security': (context) => const SecurityPage(),
              '/color': (context) => const ColorPage(),
              '/saving_add': (context) => SavingAdd(
                    onSubmit: (String value) {},
                  ),
              '/add': (context) => const AddInOut(),
            },
            debugShowCheckedModeBanner: false,
            title: 'Finance',
            theme: AppThemes.main(
                primaryColor: themeProvider.selectedPrimaryColor),
            themeMode: themeProvider.selectedThemeMode,
            builder: EasyLoading.init(),
          ),
        ));
  }
}
