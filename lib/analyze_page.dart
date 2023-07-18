// analyze_page.dart
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:app/add_medicine_dialog.dart';
import 'package:app/symptom_fields_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'medicine_provider.dart';
import 'medicine_model.dart';
import 'medicine_card.dart';

class AnalyzePage extends StatelessWidget {
  final String finalPrediction;
  final double finalConfidence;

  AnalyzePage({
    required this.finalPrediction,
    required this.finalConfidence,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analyze Page'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Diagnosis',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Prognosis: $finalPrediction',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Confidence score: ${finalConfidence.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<SymptomFieldsProvider>(context, listen: false)
                        .reset();
                    Navigator.pop(context);
                  },
                  child: Text('Analyze Again'),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Physician Order Entry',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Consumer<MedicineProvider>(
                  builder: (context, provider, child) {
                    if (provider.medicines.isEmpty) {
                      return Text('No Orders');
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.medicines.length,
                        itemBuilder: (ctx, index) => MedicineCard(
                          medicine: provider.medicines[index],
                          index: index,
                        ),
                      );
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (ctx) => AddMedicineDialog(),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text('Add Medicine'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
