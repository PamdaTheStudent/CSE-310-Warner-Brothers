import 'package:flutter/material.dart';
import 'directions_screen.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  String? startBox;
  String? endBox;

  @override
  Widget build(BuildContext context) {
    bool canProceed = startBox != null && endBox != null;

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Route'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Start Box Selection
              Text(
                'Select Start Location',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    startBox = startBox == null ? 'Box A' : null;
                  });
                },
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: startBox != null ? Colors.cyan : Colors.grey,
                      width: 2,
                    ),
                    color: startBox != null
                        ? Colors.cyan.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      startBox ?? 'Tap to Select Start',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: startBox != null ? Colors.cyan : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              // End Box Selection
              Text(
                'Select End Location',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    endBox = endBox == null ? 'Box B' : null;
                  });
                },
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: endBox != null ? Colors.cyan : Colors.grey,
                      width: 2,
                    ),
                    color: endBox != null
                        ? Colors.cyan.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      endBox ?? 'Tap to Select End',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: endBox != null ? Colors.cyan : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              // Next Button
              ElevatedButton(
                onPressed: canProceed
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DirectionsScreen(
                              startBox: startBox!,
                              endBox: endBox!,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.cyan,
                  disabledBackgroundColor: Colors.grey,
                ),
                child: const Text(
                  'Get Directions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
