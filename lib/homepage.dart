import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'analyze_page.dart';
import 'symptom_fields_provider.dart';
import 'models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var _predictionText = "";

  void _analyzeSymptoms() async {
    var symptomFieldsProvider =
        Provider.of<SymptomFieldsProvider>(context, listen: false);
    List<String> symptoms = symptomFieldsProvider.symptoms;

    try {
      var requestBody = {'symptoms': symptoms};

      var response = await http.post(
        Uri.parse('http://10.0.2.2:8000/predict/'),
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        var prediction = jsonDecode(response.body) as Map<String, dynamic>;

        // Extract the final prediction and confidence
        var finalPrediction = prediction['final_prediction'].toString();
        var finalConfidence = prediction['final_confidence'] as double;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnalyzePage(
              finalPrediction: finalPrediction,
              finalConfidence: finalConfidence,
            ),
          ),
        );
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (error) {
      print('Caught an error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var symptomFieldsProvider = Provider.of<SymptomFieldsProvider>(context);
    List<Widget> _autocompleteFields = symptomFieldsProvider.autocompleteFields;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Symptoms',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ..._autocompleteFields,
                    SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          symptomFieldsProvider.addSymptomField(
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Autocomplete<String>(
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<String>.empty();
                                      }
                                      return listItems.where((String item) {
                                        return item.contains(textEditingValue
                                            .text
                                            .toLowerCase());
                                      });
                                    },
                                    onSelected: (String selectedItem) {
                                      symptomFieldsProvider
                                          .addSymptom(selectedItem);
                                    },
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    var index = _autocompleteFields.length - 1;
                                    var symptom =
                                        symptomFieldsProvider.symptoms[index];
                                    symptomFieldsProvider
                                        .removeSymptom(symptom);
                                    symptomFieldsProvider
                                        .removeSymptomField(index);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text('Add symptom'),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: _analyzeSymptoms,
                        child: Text('Analyze'),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(_predictionText), // Display the predictions
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
