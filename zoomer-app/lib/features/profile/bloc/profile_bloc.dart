import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/authentication_service.dart';
import 'dart:developer';
import 'package:get_it/get_it.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LogOutEvent>(_onLogOutEvent);
  }

  static final getIt = GetIt.instance;

  void _onLogOutEvent(LogOutEvent event, Emitter<ProfileState> emit) async {
    final service = getIt<AuthenticationService>();
    log('Attempting Log Out');
    await service.logout();
    log('Logged Out');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('login');
    await prefs.remove('assessment');
    await prefs.remove('school_name');
    await prefs.remove('attendance');
    await prefs.remove('selectedGrade');
    await prefs.remove('selectedDivision');
    await prefs.remove('grade');
    await prefs.remove('div');
    await prefs.remove('type');
    await prefs.remove('exercise');
    await prefs.remove('ansType');
    await prefs.remove('student');
    log(prefs.getString('school_name') ?? 'Blank');
    emit(LogOut());
  }
}
