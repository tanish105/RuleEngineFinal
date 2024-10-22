import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateRule extends StatefulWidget {
  const CreateRule({super.key});

  @override
  State<CreateRule> createState() => _CreateRuleState();
}

class _CreateRuleState extends State<CreateRule> {
  final TextEditingController _ruleController = TextEditingController();
  String _response = "";

  // Function to handle the API call
  Future<void> _submitRule() async {
    final ruleString = _ruleController.text;

    if (ruleString.isEmpty) {
      setState(() {
        _response = "Please enter a rule.";
      });
      return;
    }

    final url = Uri.parse('http://localhost:5000/createRule');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({"rule_string": ruleString});

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
        title: const Text("Rule Engine with AST"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Smaller text box by adjusting content padding
              TextField(
                controller: _ruleController,
                decoration: const InputDecoration(
                  labelText: 'Enter rule string',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Makes input box smaller
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitRule,
                child: const Text("Submit Rule"),
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
