import 'package:app/lottie_cover.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/medicine_provider.dart';
import 'package:app/symptom_fields_provider.dart';
import 'cpoe_analyze_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MedicineProvider>(
          create: (context) => MedicineProvider(),
        ),
        ChangeNotifierProvider<SymptomFieldsProvider>(
          create: (context) => SymptomFieldsProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Analyze(),
    );
  }
}
