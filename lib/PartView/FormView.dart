import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Themes/MainThemes.dart';
import 'package:pukulenam/Models/Fraud.dart';
import 'package:http/http.dart' as http;

class FormView extends StatefulWidget {
  const FormView({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  final AnimationController? animationController;

  @override
  _FormViewState createState() => _FormViewState();
}

class _FormViewState extends State<FormView> with TickerProviderStateMixin {
  late AnimationController animationController;
  final TextEditingController explanationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    explanationController.dispose();
    super.dispose();
  }


  Future<FraudData> fetchFraud(String fraudNews) async {
    final response = await http.post(
      Uri.parse('https://pukul-enam-server-model-api-73t3gncdha-et.a.run.app/classification'),
      headers: {
        'Authorization': 'Bearer 2837b4e5c8ce7a7be2d39ada35aaa334',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'text': fraudNews}), // Ensure the key is correct based on API requirements
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return FraudData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load fraud data : ${response.body}');
    }
  }

  Future<void> _handleFormSubmission() async {
    try {
      String inputText = explanationController.text;
      FraudData fraudData = await fetchFraud(inputText);
      String resultPercentage = (fraudData.Result[0] * 100).toStringAsFixed(2) + '%';
      String status = fraudData.Sentiment == 'positive' ? 'Valid' : 'Hoax';
      Color statusColor = fraudData.Sentiment == 'positive' ? Colors.green : Colors.red;

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Center(
            child: Text(
              '$status',
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Hoax Percentage: ${resultPercentage}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Entities:', style: TextStyle(fontSize: 16)),
              ...fraudData.Entities.map((entity) => Text('- $entity', style: TextStyle(fontSize: 14))),
              SizedBox(height: 16),
              InkWell(
                child: Text(
                  'Search Validation News',
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
                onTap: () {
                  String query = inputText.split(' ').take(30).join(' ');
                  String googleSearchUrl = 'https://www.google.com/search?q=$query';
                  launch(googleSearchUrl);
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to load news. Please try again later.'),
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
                    onPressed: _handleFormSubmission,
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