import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../Themes/MainThemes.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart' show ByteData, WidgetsFlutterBinding;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'dart:developer';

class FormView extends StatefulWidget {
  const FormView({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  final AnimationController? animationController;

  @override
  _FormViewState createState() => _FormViewState();
}

class _FormViewState extends State<FormView>
    with TickerProviderStateMixin {
  late Interpreter interpreter;
  bool isModelReady = false;
  late AnimationController animationController;
  final TextEditingController urlController = TextEditingController();
  final TextEditingController explanationController = TextEditingController();
  String status = "Valid"; // Default status

  @override
  void initState() {
    loadModel();
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    animationController.forward();
  }
  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/flatten.tflite');
      setState(() {
        isModelReady = true;
      });
      log('Model loaded successfully');
    } catch (e) {
      log('Failed to load model: $e');
    }
  }
  @override
  void dispose() {
    animationController.dispose();
    interpreter.close();
    urlController.dispose();
    explanationController.dispose();
    super.dispose();
  }
  Future<void> _handleFormSubmission() async {
    if (!isModelReady) {
      log('Model is not ready');
      return;
    }

    String inputText = explanationController.text;

    List<int> inputBytes = utf8.encode(inputText);
    var inputShape = interpreter.getInputTensor(0).shape;
    var inputType = interpreter.getInputTensor(0).type;
    var outputShape = interpreter.getOutputTensor(0).shape;
    var outputType = interpreter.getOutputTensor(0).type;

    print("Input shape: $inputShape, type: $inputType");
    print("Output shape: $outputShape, type: $outputType");

    // Ensure the input length matches the expected input shape
    int inputLength = inputShape[1];
    List<double> inputFloats = List<double>.filled(inputLength, 0.0);

    for (int i = 0; i < inputLength; i++) {
      if (i < inputBytes.length) {
        inputFloats[i] = inputBytes[i].toDouble();
      } else {
        inputFloats[i] = 0.0; // Pad with zeros if inputBytes is shorter
      }
    }
    print(inputFloats);

// Create inputs and outputs tensors
    var inputs = [inputFloats];
    var outputs = List.filled(1*1, 0.0).reshape([1,1]);
    // Perform inference
    //var inputs = [inputBytes];
    //var outputs = List<double>.filled(1, 0).reshape([1, 1]);
    print("input : $inputs");
    print("output : $outputs");
    interpreter.run(inputs, outputs);
    print(outputs);
    double result = outputs[0][0];
    String status = result > 0.5 ? 'Hoax' : 'Valid';
    print(result);
    log(status);

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('$status'),
        content: Text('Explanation: $inputText'),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: animationController,
              child: Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  30 * (1.0 - animationController.value),
                  0.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: MainAppTheme.white.withOpacity(1.0),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: MainAppTheme.grey.withOpacity(0.4),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Hoax Checker ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            getAppBarUI(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Form for Input URL
                  TextField(
                    controller: explanationController,
                    decoration: InputDecoration(
                      labelText: 'Input News Text',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: 16),
                  // Submit button
                  ElevatedButton(
                    onPressed: (){
                      log('Submit button pressed');
                      _handleFormSubmission();},
                    style: ElevatedButton.styleFrom(
                      primary: MainAppTheme.lightBlue,
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
