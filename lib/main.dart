import 'package:flutter/material.dart';
import 'bmicalculator.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BMI Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  String StatusBmi  = "";
  String Gender  = "";

  List<BMICalculator> bmi = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bmi.addAll(await BMICalculator.loadAll());

      if (bmi.isNotEmpty) {
        var totalbmi = bmi[bmi.length - 1];
        fullNameController.text = totalbmi.username;
        heightController.text = totalbmi.height.toString();
        weightController.text = totalbmi.weight.toString();
        double height = totalbmi.height / 100;
        var bmiValue = totalbmi.weight / (height * height);
        bmiController.text = bmiValue.toString();
        setState(() {
          Gender = totalbmi.gender;
          StatusBmi = totalbmi.status;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      labelText: "Your Full Name"),
                  controller: fullNameController,
                ),
                SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      labelText: "Height in cm; 170"),

                  controller: heightController,
                ),
                SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      labelText: "Weight in KG"),
                  controller: weightController,
                ),
                SizedBox(
                  //Use of SizedBox
                  height: 30,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "BMI value"),
                  controller: bmiController,
                  enabled: false,
                ),
                SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Male'),
                        value: 'Male',
                        groupValue: Gender,
                        onChanged: (value) {
                          setState(() {
                            Gender = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Female'),
                        value: 'Female',
                        groupValue: Gender,
                        onChanged: (value) {
                          setState(() {
                            Gender = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  //Use of SizedBox
                  height: 30,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.blue, // Background Color
                    ),
                    onPressed: () {
                      _addBMI();
                    },
                    child: Text("Caculate BMI and Save")),
                SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                Text(
                  "$StatusBmi",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
        ));
  }

  _addBMI() async {
    if (Gender  != "Male" && Gender  != "Female") {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(
            content: Text('Invalid gender!'),
          ),
        );
      });
      return;
    }
    var bmi = BMICalculator(fullNameController.text, double.parse(heightController.text),
        double.parse(weightController.text), Gender, "");

    double height = bmi.height / 100;

    var bmigender = bmi.weight / (height * height);

    setState(() {
      bmiController.text = bmigender.toString();

      if (bmi.gender == "Male") {
        if (bmigender <= 18.5) {
          StatusBmi = "Underweight. Careful during strong wind!";
        } else if (bmigender >= 18.5 && bmigender < 25) {
          StatusBmi = "That’s ideal! Please maintain";
        } else if (bmigender >= 25 && bmigender < 30) {
          StatusBmi = "Overweight! Work out please";
        } else {
          StatusBmi = "Whoa Obese! Dangerous mate!";
        }
      } else {
        if (bmigender <= 16) {
          StatusBmi = "Underweight. Careful during strong wind!";
        } else if (bmigender >= 16 && bmigender < 22) {
          StatusBmi = "That’s ideal! Please maintain";
        } else if (bmigender >= 22 && bmigender < 27) {
          StatusBmi = "Overweight! Work out please";
        } else {
          StatusBmi = "Whoa Obese! Dangerous mate!";
        }
      }
    });

    bmi.status = StatusBmi;

    await bmi.save();
  }
}