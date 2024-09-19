import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msap/features/evaluation_type/evaluation_type.dart';
import 'package:msap/features/home/bloc/home_bloc.dart';
import 'package:msap/features/home/grades.dart'; // Import HomeScreen
import 'package:msap/features/manual_assessment/manual_evaluation_type.dart';
import 'package:msap/features/profile/profile.dart';
import 'package:msap/services/golain_api_services.dart';
import 'package:msap/utils.dart';
import 'dart:developer' as dev;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

class DivisionsScreen extends StatefulWidget {
  final String selectedGrade;
  const DivisionsScreen({Key? key, required this.selectedGrade}) : super(key: key);

  @override
  State<DivisionsScreen> createState() => _DivisionsScreenState();
}

class _DivisionsScreenState extends State<DivisionsScreen> {
  late HomeBloc _homeBloc;
  List<String> divisions = [];
  late String selectedDivision;

  late String schoolName = "Unknown School";

  static final getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
    final golainApiService = getIt<GolainApiService>();
    _homeBloc = HomeBloc(apiService: golainApiService);
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadSchoolName();
    _homeBloc.add(FetchDivisionsEvent(
      grade: widget.selectedGrade,
      school: schoolName,
    ));
  }

  Future<void> _loadSchoolName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      schoolName = prefs.getString('school_name') ?? 'Unknown School';
    });
  }

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);

    return WillPopScope(
      onWillPop: () async {
        // Always navigate back to the HomeScreen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (Route<dynamic> route) => false,
        );
        return false; // Prevent default back button behavior
      },
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: utils.paddingHorizontal,
              vertical: utils.paddingVertical,
            ),
            child: BlocConsumer<HomeBloc, HomeState>(
              bloc: _homeBloc,
              listener: (context, state) {
                if (state is AIAssessment) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EvaluationTypeScreen(),
                    ),
                  );
                } else if (state is ManualAssessment) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManualEvaluationType(),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is DivisionsLoaded) {
                  divisions = state.divisions;
                  dev.log('Divisions loaded: $divisions');
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, utils),
                    SizedBox(height: utils.screenHeight * 0.03),
                    Text(
                      'Select a Division',
                      style: GoogleFonts.roboto(
                        fontSize: utils.subtitleSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: utils.screenHeight * 0.03),
                    Expanded(
                      child: _buildDivisionsList(utils, state),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Utils utils) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                // Always navigate back to the HomeScreen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                size: utils.titleSize,
              ),
            ),
            SizedBox(width: utils.screenWidth * 0.02),
            Text(
              schoolName, // You might want to make this dynamic too
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: utils.titleSize,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          },
          icon: Icon(
            Icons.settings,
            size: utils.iconSize,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDivisionsList(Utils utils, HomeState state) {
    if (state is HomeLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is DivisionsLoaded || divisions.isNotEmpty) {
      return ListView.separated(
        itemCount: divisions.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () async {
              selectedDivision = divisions[index];
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('selectedDivision', selectedDivision);
              dev.log('Selected division: $selectedDivision');
              _homeBloc.add(StudentsEvent(division: selectedDivision));
            },
            title: Text(
              divisions[index],
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: utils.screenWidth * 0.045,
              ),
            ),
            leading: CircleAvatar(
              radius: utils.avatarRadius,
              backgroundColor: const Color.fromRGBO(158, 158, 158, 0.05),
              child: Center(
                child: Icon(
                  Icons.auto_stories,
                  color: Colors.primaries[index % Colors.primaries.length],
                  size: utils.avatarRadius,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: utils.screenHeight * 0.001,
          );
        },
      );
    } else if (state is HomeError) {
      return Center(child: Text(state.message));
    } else {
      return const Center(child: Text('No divisions available'));
    }
  }
}
