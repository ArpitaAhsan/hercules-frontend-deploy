import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hercules/services/api_service.dart';
import 'package:hercules/styles/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _helpButtonTapCount = 0;

  // Emergency types with circle colors only (no hex strings)
  Map<String, String> emergencyTypes = {
    '🟣 Rape': 'purple',
    '🟡 Mugging': 'yellow',
    '🟤 Riot': 'brown',
    '🟠 Fire': 'orange',
    '🟢 Domestic Abuse': 'green',
    '🔴 General Emergency': 'red',
  };

  String _selectedEmergencyType = '🔴 General Emergency'; // Default circle to General Emergency

  Map<String, int> _tapCounts = {
    '🟣 Rape': 0,
    '🟡 Mugging': 0,
    '🟤 Riot': 0,
    '🟠 Fire': 0,
    '🟢 Domestic Abuse': 0,
    '🔴 General Emergency': 0,
  };

  Color selectedColor = Colors.red; // Default to red (General Emergency)

  Future<void> _onHelpButtonTapped() async {
    _helpButtonTapCount++;
    if (_helpButtonTapCount >= 3) {
      _helpButtonTapCount = 0;
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final latitude = prefs.getDouble('latitude');
      final longitude = prefs.getDouble('longitude');

      if (userId != null && latitude != null && longitude != null) {
        String emergencyType = 'General Emergency';

        // Use color name from emergencyTypes map, matching NearbyPage colors
        final alertColor = emergencyTypes[_selectedEmergencyType]!;

        final logResponse = await ApiService.logEmergencyAlert(
          userId: userId,
          emergencyType: emergencyType,
          alertColor: alertColor,
          location: {
            'type': 'Point',
            'coordinates': [longitude, latitude],
          },
        );

        if (!logResponse.containsKey('error')) {
          await ApiService.updateEmergencyStatus(
            userId: userId,
            isEmergency: true,
            emergencyAlertColor: alertColor,
          );

          await ApiService.triggerEmergency(userId);

          if (mounted) {
            Navigator.pushReplacementNamed(context, '/nearby');
          }
        } else {
          print("❌ Error: ${logResponse['error']}");
        }
      } else {
        print("⚠️ User ID or location not found.");
      }
    }
  }

  Future<void> _handleEmergency(String emergencyType) async {
    _tapCounts[emergencyType] = (_tapCounts[emergencyType] ?? 0) + 1;

    if (_tapCounts[emergencyType]! >= 2) {
      _tapCounts[emergencyType] = 0;

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final latitude = prefs.getDouble('latitude');
      final longitude = prefs.getDouble('longitude');
      final color = emergencyTypes[emergencyType]!; // Use color name here

      if (userId != null && latitude != null && longitude != null) {
        final location = {
          'type': 'Point',
          'coordinates': [longitude, latitude],
        };

        final response = await ApiService.logEmergencyAlert(
          userId: userId,
          emergencyType: emergencyType.replaceAll(RegExp(r'[^\w\s]+'), '').trim(),
          alertColor: color,
          location: location,
        );

        if (!response.containsKey('error')) {
          await ApiService.updateEmergencyStatus(
            userId: userId,
            isEmergency: true,
            emergencyAlertColor: color,
          );

          await ApiService.triggerEmergency(userId);

          if (mounted) {
            Navigator.pushReplacementNamed(context, '/nearby');
          }
        } else {
          print("❌ Error logging alert: ${response['error']}");
        }
      } else {
        print("⚠️ User ID or location not found.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String selectedColorName = emergencyTypes[_selectedEmergencyType]!;
    selectedColor = _getColorFromName(selectedColorName);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
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
            icon: const Icon(Icons.notifications),
            color: AppColors.primary,
            onPressed: () {
              print('Notification clicked');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: GestureDetector(
          onTap: _onHelpButtonTapped,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Removed filtering dropdown (no filter on this page)

              const SizedBox(height: 40),
              Center(
                child: Container(
                  height: 280,
                  width: 280,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 14.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      // Show emergency text without emoji prefix:
                      _selectedEmergencyType.split(' ').skip(1).join(' '),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Tap quickly 3 or more times to ask for help.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: AppColors.font2),
              ),
              const SizedBox(height: 40),
              Text(
                'Or scroll down and tap an emergency type twice:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.font,
                ),
              ),
              const SizedBox(height: 16),
              ...emergencyTypes.keys.map((String value) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      _handleEmergency(value);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getPastelColorFor(value),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        color: _getTextColorForPastel(_getPastelColorFor(value)),
                      ),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName) {
      case 'purple':
        return Colors.purple;
      case 'yellow':
        return Colors.amber;
      case 'brown':
        return Colors.brown;
      case 'orange':
        return Colors.deepOrange;
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      default:
        return Colors.red;
    }
  }

  // Pastel background colors for buttons
  Color _getPastelColorFor(String emergencyKey) {
    switch (emergencyKey) {
      case '🟣 Rape':
        return const Color(0xFFD8B4F2); // pastel purple
      case '🟡 Mugging':
        return const Color(0xFFFFF9C4); // pastel yellow
      case '🟤 Riot':
        return const Color(0xFFBCAAA4); // pastel brown/greyish
      case '🟠 Fire':
        return const Color(0xFFFFCCBC); // pastel orange
      case '🟢 Domestic Abuse':
        return const Color(0xFFA5D6A7); // pastel green
      case '🔴 General Emergency':
        return const Color(0xFFFF8A80); // pastel red
      default:
        return Colors.grey.shade200;
    }
  }

  // Determine text color for contrast on pastel backgrounds
  Color _getTextColorForPastel(Color bgColor) {
    // Simple check: if pastel is light, use dark text; else white
    double brightness = (bgColor.red * 0.299 + bgColor.green * 0.587 + bgColor.blue * 0.114);
    return brightness > 186 ? Colors.black : Colors.white;
  }
}
