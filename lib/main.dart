import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/providers/user_provider.dart';

import '../screens/add_user_screen.dart';
import '../utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Users',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          scaffoldBackgroundColor: bgScaffold,
          primaryColor: primaryColor,
          useMaterial3: true,
        ),
        home: const AddUserScreen(),
      ),
    );
  }
}
