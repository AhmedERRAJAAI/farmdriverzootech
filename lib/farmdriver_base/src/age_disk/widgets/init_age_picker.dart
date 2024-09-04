import 'package:flutter/material.dart';

class InitAgePicker extends StatefulWidget {
  final Function ageGetter;
  final int? initAge;
  final int? initAgeDays;
  const InitAgePicker({super.key, required this.ageGetter, this.initAge, this.initAgeDays});

  @override
  State<InitAgePicker> createState() => _InitAgePickerState();
}

class _InitAgePickerState extends State<InitAgePicker> {
  final _initAgePickerKey = GlobalKey<FormState>();

  TextEditingController ageWeekController = TextEditingController();
  TextEditingController ageDaysController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ageWeekController = TextEditingController(text: "${widget.initAge ?? "0"}");
    ageDaysController = TextEditingController(text: "${widget.initAgeDays ?? "1"}");
    return Scaffold(
      body: Form(
        key: _initAgePickerKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Age actuel",
                style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: ageWeekController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: "Age (Semaine)",
                  labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Champs requis";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: ageDaysController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: "Jour / Age",
                  labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Champs requis";
                  } else if (int.parse(val) > 7 || int.parse(val) < 0) {
                    return "0 < valeur < 7";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    if (_initAgePickerKey.currentState!.validate()) {
                      widget.ageGetter(int.parse(ageWeekController.text), int.parse(ageDaysController.text));
                      Navigator.of(context).pop();
                    }
                  },
                  style: OutlinedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
