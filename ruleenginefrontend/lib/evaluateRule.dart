import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EvaluateRule extends StatefulWidget {
  const EvaluateRule({super.key});

  @override
  State<EvaluateRule> createState() => _CombineRuleState();
}

class _CombineRuleState extends State<EvaluateRule> {
  final TextEditingController _ruleController = TextEditingController();
  final TextEditingController _dataController = TextEditingController(); // Controller for data input
  String _response = "";

  // Function to handle the API call
  Future<void> _submitRule() async {
    final ruleString = _ruleController.text;
    final dataString = _dataController.text;

    if (ruleString.isEmpty || dataString.isEmpty) {
      setState(() {
        _response = "Please enter both a rule and data.";
      });
      return;
    }

    // Assuming the rule entered is a simple string like "salary > 50000"
    // And data is a key-value JSON-like string, e.g., "salary:1000000"
    final ruleNode = {
      "node_type": "operand",
      "value": ruleString,
      "left": null,
      "right": null
    };

    // Parsing the input data into a Map
    Map<String, dynamic> dataMap = {};
    List<String> dataEntries = dataString.split(',');
    for (var entry in dataEntries) {
      List<String> keyValue = entry.split(':');
      if (keyValue.length == 2) {
        dataMap[keyValue[0].trim()] = keyValue[1].trim();
      }
    }

    final url = Uri.parse('http://localhost:5000/evaluateRules');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "rule": ruleNode,
      "data": dataMap
    }); // Sending the rule and data as required

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        setState(() {
          _response = "Success: ${response.body}";
        });
      } else {
        setState(() {
          _response = "Error: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _response = "Failed to connect to the API: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluate Rule with Data"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rule input field
              TextField(
                controller: _ruleController,
                decoration: const InputDecoration(
                  labelText: 'Enter rule: ',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Makes input box smaller
                ),
              ),
              const SizedBox(height: 20),
              // Data input field
              TextField(
                controller: _dataController,
                decoration: const InputDecoration(
                  labelText: 'Enter data',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Makes input box smaller
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitRule,
                child: const Text("Submit Rule and Data"),
              ),
              const SizedBox(height: 20),

              // Expanding response box to make it scrollable when large content
              Container(
                height: 500, // Set a height for the response box
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _response.isEmpty ? 'No response yet' : _response,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
