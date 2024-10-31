// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String locationMessage = "Presiona para obtener la ubicación";

  Future<void> _getLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        locationMessage =
            'Latitud: ${position.latitude}, Longitud: ${position.longitude}';
      });
    } catch (e) {
      setState(() {
        locationMessage = 'Error: $e';
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si los servicios de ubicación están habilitados.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    // Verificar el estado de los permisos.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permiso de ubicación denegado');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permisos de ubicación denegados permanentemente.');
    }

    // Cuando los permisos están habilitados y los servicios de ubicación activos.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demostración de GPS')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(locationMessage),
            ElevatedButton(
              onPressed: _getLocation,
              child: Text('Obtener Ubicación Actual'),
            ),
          ],
        ),
      ),
    );
  }
}
