import 'package:flutter/material.dart';
import 'package:hercules/styles/app_colors.dart';
import 'package:hercules/config/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _helpButtonTapCount = 0;

  // Show the 'Help Asked' message after 3 or more quick taps
  void _onHelpButtonTapped() {
    _helpButtonTapCount++; // Increase count

    if (_helpButtonTapCount >= 3) {
      _showHelpMessage();
      _helpButtonTapCount = 0; // Reset tap count
    }
  }

  void _showHelpMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Help Asked')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Removes the grey background
        elevation: 0, // Removes shadow effect
        leading: Padding(
          padding: EdgeInsets.all(8.0), // Optional padding for better spacing
          child: ClipOval(
            child: Image.asset(
              'assets/hercules_logo.png',
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black), // Set icon color if needed
            onPressed: () {
              print('Notification clicked');
            },
          ),
        ],
      ),

      body: GestureDetector(
        onTap: _onHelpButtonTapped,
        child: Center(
          child: Stack(
            children: [
              // Positioned "OPTIONS" dropdown above the HELP button
              Positioned(
                top: 50, // Positioned near the top of the screen
                left: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12), // Add padding inside the box
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300, // Light grey background for dropdown
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8.0,
                      ),
                    ],
                  ),
                  child: DropdownButton<String>(
                    hint: Center( // Center align the text
                      child: Text(
                        'OPTIONS',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    underline: SizedBox(), // Remove default underline
                    onChanged: (value) {},
                    items: <String>[
                      '🟣 Rape',  // Purple Circle for Rape
                      '🟠 Mugging', // Orange Circle for Mugging
                      '🟡 Riot', // Yellow Circle for Riot
                      '🔵 Fire', // Blue Circle for Fire
                      '🟢 Domestic Abuse' // Green Circle for Domestic Abuse
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold, // Keep text bold
                            color: Colors.black, // Keep text black
                          ),
                        ),
                      );
                    }).toList(),
                    style: TextStyle(color: Colors.black),
                    iconEnabledColor: Colors.black,
                    iconDisabledColor: Colors.black,
                    dropdownColor: Colors.grey.shade300, // Light grey background
                    isExpanded: true,
                  ),
                ),
              ),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Bigger "HELP!" Button
                    Container(
                      height: 350, // Increased size for Help button
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 12.0, // Increased blur for the shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'HELP!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 70, // Bigger font size for visibility
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Instructions text (optional)
                    Text(
                      'Tap quickly 3 or more times to ask for help.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
