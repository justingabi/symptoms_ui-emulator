import 'package:app/add_medicine_dialog.dart';
import 'package:app/symptom_fields_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'medicine_provider.dart';
import 'package:app/models/medicine_model.dart';
import 'medicine_card.dart';

class Cpoeform extends StatelessWidget {
  final String finalPrediction;
  final double finalConfidence;

  Cpoeform({
    required this.finalPrediction,
    required this.finalConfidence,
  });

  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);

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
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
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
                  'Physician Order',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                if (medicineProvider.medicines.isEmpty)
                  Text('\n\nNo Orders\n\n')
                else
                  Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: medicineProvider.medicines.length,
                        itemBuilder: (ctx, index) => MedicineCard(
                          medicine: medicineProvider.medicines[index],
                          index: index,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Comment Section',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                    ],
                  ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Submit action here riqi
                      },
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
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
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
