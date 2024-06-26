import 'package:flutter/material.dart';
import 'package:vcard_app/pages/contact_details_page.dart';
import 'package:vcard_app/pages/form_page.dart';
import 'package:vcard_app/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:vcard_app/pages/scan_page.dart';
import 'package:vcard_app/providers/contact_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ContactProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName : (constext)=> HomePage(),
        ScanPage.routeName : (constext)=> ScanPage(),
        FormPage.routeName : (constext)=> FormPage(),
        ContactDetailsPage.routeName : (constext)=> ContactDetailsPage(),
      },
    );
  }
}
