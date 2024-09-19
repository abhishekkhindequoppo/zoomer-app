import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:msap/utils.dart';

class BluetoothServices {
  final List<String> allowedDevicesNames = [
    'Sense Right Hand',
    'Sense Left Hand',
    'Sense Right Leg',
    'Sense Left Leg',
    'Sense Ball',
  ];

  Future<void> requestPermissions() async {
    await Permission.location.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
  }

  Future scanDevices() async {
    try {
      await requestPermissions();
      Set<String> deviceIds = {};
      List<BluetoothDevice> devices = [];

      var subscription =
          FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
        if (state == BluetoothAdapterState.off) {
          Utils.showError('Bluetooth Off');
        }
      });

      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
      }

      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

      var data = FlutterBluePlus.onScanResults.listen((results) {
        if (results.isNotEmpty) {
          for (ScanResult r in results) {
            String deviceName = r.device.platformName;
            if (allowedDevicesNames.contains(deviceName) &&
                !deviceIds.contains(r.device.remoteId.toString())) {
              devices.add(r.device);
              deviceIds.add(r.device.remoteId.toString());
            }
          }
        }
      }, onError: (e) {
        return e.toString();
      });

      await Future.delayed(const Duration(seconds: 5));
      await FlutterBluePlus.stopScan();

      FlutterBluePlus.cancelWhenScanComplete(data);
      subscription.cancel();
      return devices;
    } catch (e) {
      return e.toString();
    }
  }

  Future connectDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      Utils.showSuccess('Connected ${device.platformName}');
    } catch (e) {
      return e.toString();
    }
  }

  Future disconnectDevice(BluetoothDevice device) async {
    try {
      await device.disconnect();
      Utils.showSuccess('Disconnected ${device.platformName}');
    } catch (e) {
      return e.toString();
    }
  }
}
