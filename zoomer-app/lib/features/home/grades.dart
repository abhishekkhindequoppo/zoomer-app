import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msap/features/home/bloc/home_bloc.dart';
import 'package:msap/features/home/divisions.dart';
import 'package:msap/features/profile/profile.dart';
import 'package:msap/utils.dart';
import 'package:msap/services/golain_api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

import 'dart:developer';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc _homeBloc;
  late String schoolName = "Unknown School";
  late String selectedGrade;

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
    log('School name after loading: $schoolName');
    _homeBloc.add(FetchGradesAndDivisionsEvent(schoolName: schoolName));
  }

  Future<void> _loadSchoolName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      schoolName = prefs.getString('school_name') ?? 'Unknown School';
      log('Function School name: $schoolName');
    });
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
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
          child: BlocProvider.value(
            value: _homeBloc,
            child: BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is Navigate) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DivisionsScreen(selectedGrade: selectedGrade),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, utils),
                    SizedBox(height: utils.screenHeight * 0.03),
                    Text(
                      'Select a Grade',
                      style: GoogleFonts.roboto(
                        fontSize: utils.subtitleSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: utils.screenHeight * 0.03),
                    Expanded(
                      child: _buildGradesList(state, utils),
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
      Text(
        schoolName,
        style: GoogleFonts.roboto(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: utils.titleSize,
        ),
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


  Widget _buildGradesList(HomeState state, Utils utils) {
    if (state is HomeLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is GradesAndDivisionsLoaded) {
      return ListView.separated(
        itemCount: state.grades.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () async {
              selectedGrade = state.grades[index];
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('selectedGrade', selectedGrade);
              log('Selected grade: ${selectedGrade}');
              _homeBloc.add(NavigateEvent(grade: selectedGrade));
            },
            title: Text(
              state.grades[index],
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
      return const Center(child: Text('Unknown state'));
    }
  }
}