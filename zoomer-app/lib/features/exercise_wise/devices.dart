import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msap/features/exercise_wise/bloc/exercise_bloc.dart';
import 'package:msap/features/exercise_wise/students.dart';
import 'package:msap/services/bluetooth.dart';
import 'package:msap/utils.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  late ExerciseBloc _exerciseBloc;
  List<BluetoothDevice> availableDevices = [];
  final BluetoothServices _service = BluetoothServices();

  @override
  void initState() {
    super.initState();
    _exerciseBloc = ExerciseBloc();
    _exerciseBloc.add(BluetoothScanEvent());
  }

  @override
  void dispose() {
    _exerciseBloc.close();
    super.dispose();
  }

  void connectDisconnect(BluetoothDevice device) async {
    if (device.isDisconnected) {
      await _service.connectDevice(device);
      setState(() {});
    } else {
      await _service.disconnectDevice(device);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: utils.paddingHorizontal,
            vertical: utils.paddingVertical,
          ),
          child: BlocConsumer<ExerciseBloc, ExerciseState>(
            bloc: _exerciseBloc,
            listener: (context, state) {
              if (state is BluetoothScanComplete) {
                setState(() {
                  availableDevices = state.devices;
                });
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              size: utils.titleSize,
                            ),
                          ),
                          SizedBox(width: utils.screenWidth * 0.02),
                          Text(
                            'Connect to Devices',
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: utils.titleSize,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.settings,
                          size: utils.iconSize,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: utils.screenHeight * 0.03),
                  Text(
                    'Available Devices',
                    style: GoogleFonts.inter(
                      fontSize: utils.subtitleSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: utils.screenHeight * 0.03),
                  if (state is ExerciseLoading)
                    const Center(child: CircularProgressIndicator.adaptive())
                  else ...[
                    Expanded(
                      child: ListView.separated(
                        itemCount: availableDevices.length,
                        itemBuilder: (context, index) {
                          var device = availableDevices[index];

                          return ListTile(
                            onTap: () {
                              connectDisconnect(device);
                            },
                            title: Text(
                              device.platformName,
                              style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontSize: utils.subtitleSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: device.isConnected
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: utils.selectedContainer,
                                    ),
                                    child: Text(
                                      'Connected',
                                      style: GoogleFonts.roboto(
                                        color: const Color(0xFF2E3180),
                                        fontWeight: FontWeight.w400,
                                        fontSize: utils.subtitleSize * 0.8,
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(0, 0, 0, 0.05),
                                      border: Border.all(
                                        color:
                                            const Color.fromRGBO(0, 0, 0, 0.1),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      'Not Connected',
                                      style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: utils.subtitleSize * 0.8,
                                      ),
                                    ),
                                  ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(thickness: utils.screenHeight * 0.001);
                        },
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StudentsScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Stop',
                            style: GoogleFonts.roboto(
                              fontSize: utils.subtitleSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
