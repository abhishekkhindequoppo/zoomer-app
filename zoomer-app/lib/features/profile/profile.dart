import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msap/features/profile/bloc/profile_bloc.dart';
import 'package:msap/utils.dart';
import '../login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileBloc _profileBloc;
  late String schoolName = 'Unknown School';

  @override
  void initState() {
    super.initState();
    _loadSchoolName();
    _profileBloc = ProfileBloc();
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
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

    return SafeArea(
      child: Scaffold(
        body: BlocListener<ProfileBloc, ProfileState>(
          bloc: _profileBloc,
          listener: (context, state) {
            if (state is LogOut) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.grey,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: utils.paddingHorizontal,
                    vertical: utils.paddingVertical,
                  ),
                  child: Column(
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
                            'Profile',
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: utils.titleSize,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: utils.screenHeight * 0.03),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: utils.titleSize * 2.5,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: utils.titleSize * 3.5,
                            ),
                          ),
                          SizedBox(height: utils.screenHeight * 0.01),
                          Text(
                            schoolName,
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: utils.titleSize,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: utils.screenHeight * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: utils.paddingHorizontal,
                  vertical: utils.paddingVertical,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        _profileBloc.add(LogOutEvent());
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(utils.borderRadius),
                          side: const BorderSide(color: Colors.black),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.power_settings_new_outlined,
                            color: Colors.black,
                            size: utils.subtitleSize,
                          ),
                          title: Text(
                            'Log Out',
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: utils.subtitleSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
