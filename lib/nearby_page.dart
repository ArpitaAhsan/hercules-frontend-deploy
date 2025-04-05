import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hercules/profile_provider.dart';

class NearbyPage extends StatefulWidget {
  const NearbyPage({super.key});

  @override
  State<NearbyPage> createState() => _NearbyPageState();
}

class _NearbyPageState extends State<NearbyPage> {
  LatLng? _currentPosition;
  final MapController _mapController = MapController();
  bool _isLocationLoading = true;
  bool _isProfileFetched = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadEverything();
  }

  Future<void> _loadEverything() async {
    await _getUserIdFromPrefs();
    if (_userId != null) {
      await _determinePosition();
      await _fetchUserProfile();
    } else {
      print("❌ User ID not found in SharedPreferences.");
    }
  }

  Future<void> _getUserIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId');
    });
  }

  Future<void> _fetchUserProfile() async {
    if (_userId == null) return;

    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.fetchUserProfile(_userId!);
    setState(() {
      _isProfileFetched = true;
    });
  }

  Future<void> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _isLocationLoading = false;
    });
  }

  Color _getEmergencyColor(String color) {
    switch (color.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    final isLoading = _isLocationLoading || !_isProfileFetched || profileProvider.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Locations')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Profile Info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: ${profileProvider.name}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: ${profileProvider.email}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Text(
                  'Emergency Status: ${profileProvider.isEmergency ? 'Active' : 'Inactive'}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Alert Color: ${profileProvider.emergencyAlertColor}',
                  style: TextStyle(
                    fontSize: 20,
                    color: _getEmergencyColor(profileProvider.emergencyAlertColor),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Map
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentPosition ?? LatLng(0, 0),
                initialZoom: 12.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    if (_currentPosition != null)
                      Marker(
                        width: 50,
                        height: 50,
                        point: _currentPosition!,
                        child: const Icon(Icons.location_pin, color: Colors.blue, size: 40),
                      ),
                    if (profileProvider.isEmergency &&
                        profileProvider.emergencyLatitude != 0.0 &&
                        profileProvider.emergencyLongitude != 0.0)
                      Marker(
                        width: 50,
                        height: 50,
                        point: LatLng(
                          profileProvider.emergencyLatitude,
                          profileProvider.emergencyLongitude,
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: _getEmergencyColor(profileProvider.emergencyAlertColor),
                          size: 40,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
