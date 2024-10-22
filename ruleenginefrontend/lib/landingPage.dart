import 'package:flutter/material.dart';
import 'package:ruleenginefrontend/combineRule.dart';
import 'package:ruleenginefrontend/createRule.dart';
import 'package:ruleenginefrontend/evaluateRule.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String? _selectedOption; // This will hold the current value of the dropdown

  // Navigate to the respective page based on the dropdown value
  void _navigateToSelectedPage(String? value) {
    switch (value) {
      case 'Create Rule':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateRule()),
        );
        break;
      case 'Combine Rules':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CombineRule()),
        );
        break;
      case 'Evaluate Rules':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EvaluateRule()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rule Engine with AST"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Wrap the introductory text in a SizedBox to constrain the width
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85, // Set a width that fits nicely
              child: const Text(
                "I have developed a simple 3-tier rule engine application (Simple UI, API, Backend, Data) to determine user eligibility based on attributes like age, department, income, spend, etc. The system can use Abstract Syntax Tree (AST) to represent conditional rules and allow for dynamic creation, combination, and modification of these rules.",
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(fontSize: 16),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Add background and padding to the DropdownButton
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white, // Set the background color
                borderRadius: BorderRadius.circular(8), // Rounded corners
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4,
                    offset: Offset(0, 2), // Shadow for depth
                  ),
                ],
              ),
              child: DropdownButton<String>(
                value: _selectedOption,
                hint: const Text("Choose an option"),
                items: <String>['Create Rule', 'Combine Rules', 'Evaluate Rules']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedOption = value;
                  });
                  _navigateToSelectedPage(value);
                },
                underline: Container(), // Remove the default underline
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black), // Set icon color
                dropdownColor: Colors.white, // Color of the dropdown menu
              ),
            ),
          ],
        ),
      ),
    );
  }
}
