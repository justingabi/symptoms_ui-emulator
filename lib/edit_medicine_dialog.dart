import 'package:app/models/medicine_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'medicine_provider.dart';

class EditMedicineDialog extends StatefulWidget {
  final Medicine medicine;
  final int index;

  EditMedicineDialog({required this.medicine, required this.index});

  @override
  _EditMedicineDialogState createState() => _EditMedicineDialogState();
}

class _EditMedicineDialogState extends State<EditMedicineDialog> {
  final _formKey = GlobalKey<FormState>();
  late Medicine _editedMedicine;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    super.initState();
    _editedMedicine = Medicine.copy(widget.medicine);
    _selectedStartDate = _editedMedicine.startDate;
    _selectedEndDate = _editedMedicine.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Edit Medication Order',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Medication',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _editedMedicine.name,
                        onSaved: (value) => _editedMedicine.name = value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a medicine';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Instructions',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          initialValue: _editedMedicine.instructions,
                          onSaved: (value) =>
                              _editedMedicine.instructions = value,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Start Date',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              readOnly: true,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate:
                                      _selectedStartDate ?? DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 365)),
                                ).then((selectedDate) {
                                  if (selectedDate != null) {
                                    setState(() {
                                      _selectedStartDate = selectedDate;
                                    });
                                  }
                                });
                              },
                              controller: TextEditingController(
                                text: _selectedStartDate != null
                                    ? _selectedStartDate
                                        .toString()
                                        .split(' ')[0]
                                    : '',
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'End Date',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              readOnly: true,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate:
                                      _selectedEndDate ?? DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 365)),
                                ).then((selectedDate) {
                                  if (selectedDate != null) {
                                    setState(() {
                                      _selectedEndDate = selectedDate;
                                    });
                                  }
                                });
                              },
                              controller: TextEditingController(
                                text: _selectedEndDate != null
                                    ? _selectedEndDate.toString().split(' ')[0]
                                    : '',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Quantity',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              initialValue:
                                  _editedMedicine.quantity?.toString() ?? '',
                              onSaved: (value) => _editedMedicine.quantity =
                                  int.tryParse(value ?? ''),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Refills',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              initialValue:
                                  _editedMedicine.refills?.toString() ?? '',
                              onSaved: (value) => _editedMedicine.refills =
                                  int.tryParse(value ?? ''),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            child: Text('Save'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                _editedMedicine.startDate = _selectedStartDate;
                                _editedMedicine.endDate = _selectedEndDate;
                                Provider.of<MedicineProvider>(context,
                                        listen: false)
                                    .editMedicine(
                                        widget.index, _editedMedicine);
                                Navigator.pop(context);
                              }
                            },
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
          ),
        ),
      ),
    );
  }
}
