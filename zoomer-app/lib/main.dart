import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:msap/dependency_injector.dart';
import 'package:msap/firebase_options.dart';
import 'package:msap/models/evalutiondata.dart';
import 'package:msap/models/student.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  AppDependencyInjector.setUpAppDependencies();

  //Hive
  await Hive.initFlutter();
  Hive.registerAdapter(StudentAdapter());
  Hive.registerAdapter(EvaluationDataAdapter());
  // await Hive.openBox<Student>('students');

  // firebase initialize
  await Firebase.initializeApp(
    name: 'MSAP',
    options: const FirebaseOptions(
      apiKey: "AIzaSyCzuZuxqrGyVeUP0bmkpbisoDr21pV7564",
      appId: "1:750365490230:android:293f4edd2dbc391d126c97",
      messagingSenderId: "750365490230",
      projectId: "msap-9d5c4",
    ),
  );

  runApp(const MyApp());
}
