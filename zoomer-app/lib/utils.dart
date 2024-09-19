import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

class Utils {
  BuildContext context;
  double screenHeight = 0;
  double screenWidth = 0;
  double paddingHorizontal = 0;
  double paddingVertical = 0;
  double titleSize = 0;
  double subtitleSize = 0;
  double avatarRadius = 0;
  double borderRadius = 0;
  double iconSize = 0;
  final EasyLoading _easyLoading = EasyLoading.instance;
  final Color selectedContainer = const Color(0xFFC8C810);

  Utils(this.context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    paddingHorizontal = screenWidth * 0.05;
    paddingVertical = screenHeight * 0.02;
    titleSize = screenWidth * 0.068;
    subtitleSize = screenWidth * 0.048;
    iconSize = screenWidth * 0.08;
    borderRadius = screenWidth * 0.03;
    avatarRadius = screenWidth * 0.06;
    _easyLoading.contentPadding = EdgeInsets.symmetric(
      horizontal: paddingHorizontal,
      vertical: paddingVertical,
    );
    _easyLoading.textStyle = GoogleFonts.roboto(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: subtitleSize,
    );
  }

  ButtonStyle elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFF1E3D75), width: 0.85),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal,
        vertical: paddingVertical,
      ),
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF1E3D75),
    );
  }

  BoxDecoration detailsContainerDecoration() {
    return BoxDecoration(
      color: const Color(0xFF1E3D75),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  InputDecoration addStudentTextFieldDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.roboto(
        color: const Color(0xFF1E3D75),
        fontWeight: FontWeight.w400,
        fontSize: subtitleSize * 0.85,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(
          color: Color(0xFF1E3D75),
        ),
      ),
    );
  }

  static Future<void> showShorterToast(String message) {
    return EasyLoading.showToast(
      message,
      maskType: EasyLoadingMaskType.none,
      duration: const Duration(seconds: 2),
      toastPosition: EasyLoadingToastPosition.bottom,
    );
  }

  static Future<void> showSuccess(String title) {
    return EasyLoading.showSuccess(
      title,
      duration: const Duration(seconds: 2),
      maskType: EasyLoadingMaskType.none,
    );
  }

  static Future<void> showError(String title) {
    return EasyLoading.showError(
      title,
      duration: const Duration(seconds: 2),
      maskType: EasyLoadingMaskType.none,
    );
  }

  static final Map<String, Map<String, int>> gradeQuestionType = {
    'Nursery': {
      '1. Is the student able to step over the balance beam with his preferred (dominant) leg?':
          0,
      '2. Is the student able to step over a row of mighty mugs with his non-dominant leg?':
          0,
      '3. Is the student able to step down from a three-storey tower of biggie pegs on his preferred (dominant) leg?':
          0,
      '4. Is the student able to step down from a two-storey tower of biggie pegs on his non-dominant leg?':
          0,
      '5. How many Jumps is the student able to do? (To jump using both legs and land on both feet)':
          1,
      '6. How many times is the student able to hit the balloon upwards with hand without letting the balloon fall down?':
          1,
    },
    'LKG': {
      '1. How many seconds is the student able stand on their preferred (dominant) leg?':
          1,
      '2. Is the student able to step over a tower of two biggie pegs and one big bowl with his non-dominant leg?':
          0,
      '3. How many times is the student is able to hop forward in one go, using their preferred (dominant) leg?':
          1,
      '4. How many times is the student able to hop forward in one go, using their non-dominant leg?':
          1,
      '5. How many times is the student able to do jumping jacks without moving the hands?':
          1,
      '6. How many times is the student able to hit the balloon upwards with hand without letting the balloon fall down?':
          1,
    },
    'SKG': {
      '1. How many seconds is the student able stand on their preferred (dominant) leg?':
          1,
      '2. How many seconds is the student able stand on their non-preferred (non-dominant) leg?':
          1,
      '3. How many times is the student is able to hop forward in one go, using their preferred (dominant) leg?':
          1,
      '4. How many times is the student able to hop forward in one go, using their non-dominant leg?':
          1,
      '5. How many times is the student able to do jumping jacks without moving the hands?':
          1,
      '6. How many times is the student able to bounce and catch the big bounce in one go. Bounce and catch with both hands from below.':
          1,
    },


    'Grade 1': {
      '1. How many seconds is the student able stand on their preferred (dominant) leg?':
          1,
      '2. How many seconds is the student able stand on their non-dominant leg?':
          1,
      '3. How many hops does the student need to cover a distance of 9 metres, using their preferred (dominant) leg? MARK 0 (ZERO) IF NOT ABLE TO COVER 9 METRES.':
          1,
      '4. How many times is the student able to hop forward in one go, using their non-dominant leg?':
          1,
      '5. How many times is the student able to skip continuously?': 1,
      '6. How many times is the student able to bounce and catch the big bounce in one go, using the dominant hand?':
          1,
    },
    'Grade 2': {
      '1. How many seconds is the student able stand on their preferred (dominant) leg?':
          1,
      '2. How many seconds is the student able stand on their non-dominant leg?':
          1,
      '3. How many hops does the student need to cover a distance of 9 metres, using their preferred (dominant) leg? MARK 0 (ZERO) IF NOT ABLE TO COVER 9 METRES.':
          1,
      '4. How many times is the student able to hop forward in one go, using their non-dominant leg?':
          1,

      '5. How many times is the student able to do the front and back criss-cross jumps continuously?':
          1,

      '6. How many times is the student able to bounce and catch the big bounce in one go, using the non-dominant hand':
          1,
    },
    'Grade 3': {
      '1. How many seconds is the student able stand on their preferred (dominant) leg?':
          1,
      '2. How many seconds is the student able stand on their non-dominant leg?':
          1,
      '3. How many hops does the student need to cover a distance of 9 metres, using their preferred (dominant) leg? MARK 0 (ZERO)  IF NOT ABLE TO COVER 9 METRES.':
          1,
      '4. How many hops does the student need to cover a distance of 9 metres, using their non-dominant leg?  MARK 0 (ZERO) IF NOT ABLE TO COVER 9 METRES.':
          1,
      '5. How many times is the student able to do the front and back criss-cross jumps continuously?':
          1,
      '6. How many rounds is the student able to complete around the cones while dribbling with big bounce, using the dominant hand?':
          1,
    },
    'Grade 4': {
      '1. How many seconds is the student able stand on their preferred (dominant) leg?':
          1,
      '2. How many seconds is the student able stand on their non-dominant leg?':
          1,
      '3. How many hops does the student need to cover a distance of 9 metres, using their preferred (dominant) leg? MARK 0 (ZERO)  IF NOT ABLE TO COVER 9 METRES.':
          1,
      '4. How many hops does the student need to cover a distance of 9 metres, using their non-dominant leg?  MARK 0 (ZERO) IF NOT ABLE TO COVER 9 METRES.':
          1,
      '5. How many times is the student able to do the front and back criss-cross jumps continuously?':
          1,
      '6. How many rounds is the student able to complete around the cones while dribbling with big bounce, using the dominant hand?':
          1,
    },
    'Grade 5': {
      '1. How many seconds is the student able stand on their preferred (dominant) leg?':
          1,
      '2. How many seconds is the student able stand on their non-dominant leg?':
          1,
      '3. How many hops does the student need to cover a distance of 9 metres, using their preferred (dominant) leg? MARK 0 (ZERO)  IF NOT ABLE TO COVER 9 METRES.':
          1,
      '4. How many hops does the student need to cover a distance of 9 metres, using their non-dominant leg?  MARK 0 (ZERO) IF NOT ABLE TO COVER 9 METRES.':
          1,
      '5. How many times is the student able to do on-the-spot sideways criss-cross jumps continuously and clapping when the feet are close together?':
          1,
      '6. How many rounds is the student able to complete making a figure of 8 around the cones while dribbling with big bounce, using the dominant hand?':
          1,
    },
    'Grade 6': {
      '1. How many seconds is the student able stand on their preferred (dominant) leg with their eyes closed?':
          1,
      '2. How many seconds is the student able stand on their non preferred (non-dominant) leg with their eyes closed?':
          1,
      '3. How many hops does the student need to cover a distance of 9 metres, using their preferred (dominant) leg? MARK 0 (ZERO) IF NOT ABLE TO COVER 9 METRES.':
          1,
      '4. How many hops does the student need to cover a distance of 9 metres, using their non-dominant leg?  MARK 0 (ZERO) IF NOT ABLE TO COVER 9 METRES?':
          1,
      '5. How many times is the student able to do forward backward open close continuously with their feet alternating? Each time ONE FULL SET is done it is counted as one point.':
          1,
      '6. How many figure of 8 rounds is the student able to complete around the markers that are at a distance of 3 meters apart while dribbling the basketball using the dominant hand or preferred hand?':
          1,
    },
  };


  static final Map<String, List<String>> exerciseConfigs = {
    // Nursery
    '1. Is the student able to step over the balance beam with his preferred (dominant) leg?': ['Body Management Skill', 'Dominant Leg'],
    '2. Is the student able to step over a row of mighty mugs with his non-dominant leg?': ['Body Management Skill', 'Non-Dominant Leg'],
    '3. Is the student able to step down from a three-storey tower of biggie pegs on his preferred (dominant) leg?': ['Locomotor Skill', 'Dominant Leg'],
    '4. Is the student able to step down from a two-storey tower of biggie pegs on his non-dominant leg?': ['Locomotor Skill', 'Non-Dominant Leg'],
    '5. How many Jumps is the student able to do? (To jump using both legs and land on both feet)': ['Coordination Skill', ''],
    '6. How many times is the student able to hit the balloon upwards with hand without letting the balloon fall down?': ['Object Control Skill', ''],

    // LKG
    '1. How many seconds is the student able stand on their preferred (dominant) leg?': ['Body Management Skill', 'Dominant Leg'],
    '2. Is the student able to step over a tower of two biggie pegs and one big bowl with his non-dominant leg?': ['Body Management Skill', 'Non-Dominant Leg'],
    '3. How many times is the student is able to hop forward in one go, using their preferred (dominant) leg?': ['Locomotor Skill', 'Dominant Leg'],
    '4. How many times is the student able to hop forward in one go, using their non-dominant leg?': ['Locomotor Skill', 'Non-Dominant Leg'],
    '5. How many times is the student able to do jumping jacks without moving the hands?': ['Coordination Skill', ''],
    '6. How many times is the student able to hit the balloon upwards with hand without letting the balloon fall down?': ['Object Control Skill', ''],

    // SKG
    '1. How many seconds is the student able stand on their preferred (dominant) leg?': ['Body Management Skill', 'Dominant Leg'],
    '2. How many seconds is the student able stand on their non-preferred (non-dominant) leg?': ['Body Management Skill', 'Non-Dominant Leg'],
    '3. How many times is the student is able to hop forward in one go, using their preferred (dominant) leg?': ['Locomotor Skill', 'Dominant Leg'],
    '4. How many times is the student able to hop forward in one go, using their non-dominant leg?': ['Locomotor Skill', 'Non-Dominant Leg'],
    '5. How many times is the student able to do jumping jacks without moving the hands?': ['Coordination Skill', ''],
    '6. How many times is the student able to bounce and catch the big bounce in one go. Bounce and catch with both hands from below.': ['Object Control Skill', ''],

    // Grade 1
    '1. How many seconds is the student able stand on their preferred (dominant) leg?': ['Body Management Skill', 'Dominant Leg'],
    '2. How many seconds is the student able stand on their non-dominant leg?': ['Body Management Skill', 'Non-Dominant Leg'],
    '3. How many hops does the student need to cover a distance of 9 metres, using their preferred (dominant) leg? MARK 0 (ZERO) IF NOT ABLE TO COVER 9 METRES.': ['Locomotor Skill', 'Dominant Leg'],
    '4. How many times is the student able to hop forward in one go, using their non-dominant leg?': ['Locomotor Skill', 'Non-Dominant Leg'],
    '5. How many times is the student able to skip continuously?': ['Coordination Skill', ''],
    '6. How many times is the student able to bounce and catch the big bounce in one go, using the dominant hand?': ['Object Control Skill', ''],

    // Grade 2
    '1. How many seconds is the student able stand on their preferred (dominant) leg?': ['Body Management Skill', 'Dominant Leg'],
    '2. How many seconds is the student able stand on their non-dominant leg?': ['Body Management Skill', 'Non-Dominant Leg'],
    '3. How many hops does the student need to cover a distance of 9 metres, using their preferred (dominant) leg? MARK 0 (ZERO) IF NOT ABLE TO COVER 9 METRES.': ['Locomotor Skill', 'Dominant Leg'],
    '4. How many times is the student able to hop forward in one go, using their non-dominant leg?': ['Locomotor Skill', 'Non-Dominant Leg'],
    '5. How many times is the student able to do the front and back criss-cross jumps continuously?': ['Coordination Skill', ''],
    '6. How many times is the student able to bounce and catch the big bounce in one go, using the non-dominant hand': ['Object Control Skill', ''],

    // Grade 3, 4, and 5 (same questions)
    '1. How many seconds is the student able stand on their preferred (dominant) leg?': ['Body Management Skill', 'Dominant Leg'],
    '2. How many seconds is the student able stand on their non-dominant leg?': ['Body Management Skill', 'Non-Dominant Leg'],
    '3. How many hops does the student need to cover a distance of 9 metres, using their preferred (dominant) leg? MARK 0 (ZERO)  IF NOT ABLE TO COVER 9 METRES.': ['Locomotor Skill', 'Dominant Leg'],
    '4. How many hops does the student need to cover a distance of 9 metres, using their non-dominant leg?  MARK 0 (ZERO) IF NOT ABLE TO COVER 9 METRES.': ['Locomotor Skill', 'Non-Dominant Leg'],
    '5. How many times is the student able to do the front and back criss-cross jumps continuously?': ['Coordination Skill', ''],
    '6. How many rounds is the student able to complete around the cones while dribbling with big bounce, using the dominant hand?': ['Object Control Skill', ''],

    // Grade 5 (different question 5)
    '5. How many times is the student able to do on-the-spot sideways criss-cross jumps continuously and clapping when the feet are close together?': ['Coordination Skill', ''],
    '6. How many rounds is the student able to complete making a figure of 8 around the cones while dribbling with big bounce, using the dominant hand?': ['Object Control Skill', ''],

    // Grade 6
    '1. How many seconds is the student able stand on their preferred (dominant) leg with their eyes closed?': ['Body Management Skill', 'Dominant Leg'],
    '2. How many seconds is the student able stand on their non preferred (non-dominant) leg with their eyes closed?': ['Body Management Skill', 'Non-Dominant Leg'],
    '3. How many hops does the student need to cover a distance of 9 metres, using their preferred (dominant) leg? MARK 0 (ZERO) IF NOT ABLE TO COVER 9 METRES.': ['Locomotor Skill', 'Dominant Leg'],
    '4. How many hops does the student need to cover a distance of 9 metres, using their non-dominant leg?  MARK 0 (ZERO) IF NOT ABLE TO COVER 9 METRES?': ['Locomotor Skill', 'Non-Dominant Leg'],
    '5. How many times is the student able to do forward backward open close continuously with their feet alternating? Each time ONE FULL SET is done it is counted as one point.': ['Coordination Skill', ''],
    '6. How many figure of 8 rounds is the student able to complete around the markers that are at a distance of 3 meters apart while dribbling the basketball using the dominant hand or preferred hand?': ['Object Control Skill', ''],
  };
}

final Map<String, String> questionToApiFieldMap = {
  '1. Is the student able to step over the balance beam with his preferred (dominant) leg?': 'step_over_dominant_leg',
  '2. Is the student able to step over a row of mighty mugs with his non-dominant leg?': 'step_over_nondominant_leg',
  '3. Is the student able to step down from a three-storey tower of biggie pegs on his preferred (dominant) leg?': 'step_down_dominant_leg',
  '4. Is the student able to step down from a two-storey tower of biggie pegs on his non-dominant leg?': 'step_down_nondominant_leg',
  '5. How many Jumps is the student able to do? (To jump using both legs and land on both feet)': 'jump_symmetrically',
  '6. How many times is the student able to hit the balloon upwards with hand without letting the balloon fall down?': 'hit_balloon_up',
  '1. How many seconds is the student able stand on their preferred (dominant) leg?': 'stand_on_dominant_leg',
  '2. Is the student able to step over a tower of two biggie pegs and one big bowl with his non-dominant leg?': 'step_over_nondominant_leg',
  '3. How many times is the student is able to hop forward in one go, using their preferred (dominant) leg?': 'hop_forward_dominant_leg',
  '4. How many times is the student able to hop forward in one go, using their non-dominant leg?': 'hop_forward_nondominant_leg',
  '5. How many times is the student able to do jumping jacks without moving the hands?': 'jumping_jacks_without_clap',
  '2. How many seconds is the student able stand on their non-preferred (non-dominant) leg?': 'stand_on_nondominant_leg',
  '2. How many seconds is the student able stand on their non preferred (non-dominant)?': 'stand_on_nondominant_leg',
  '6. How many times is the student able to bounce and catch the big bounce in one go. Bounce and catch with both hands from below.': 'ball_bounce_and_catch',
  '2. How many seconds is the student able stand on their non-dominant leg?': 'stand_on_nondominant_leg',
  '3. How many hops does the student need to cover a distance of 9 metres, using their preferred (dominant) leg? MARK 0 (ZERO) IF NOT ABLE TO COVER 9 METRES.': 'hop_9m_dominant_leg',
  '5. How many times is the student able to skip continuously?': 'skipping',
  '6. How many times is the student able to bounce and catch the big bounce in one go, using the dominant hand?':  'ball_bounce_and_catch',
  '5. How many times is the student able to do the front and back criss-cross jumps continuously?': 'criss_cross_without_clap',
  '6.How many times is the student able to bounce and catch the big bounce in one go, using the non-dominant hand':  'ball_bounce_and_catch',
  '3. How many hops does the student need to cover a distance of 9 metres, using their preferred (dominant) leg? MARK 0 (ZERO)  IF NOT ABLE TO COVER 9 METRES.': 'hop_9m_dominant_leg',
  '6. How many times is the student able to bounce and catch the big bounce in one go, using the non-dominant hand': 'ball_bounce_and_catch',
  '4. How many hops does the student need to cover a distance of 9 metres, using their non-dominant leg?  MARK 0 (ZERO) IF NOT ABLE TO COVER 9 METRES.': 'hop_forward_nondominant_leg',
  '6. How many rounds is the student able to complete around the cones while dribbling with big bounce, using the dominant hand?': 'dribbling_ball_O',
  '5. How many times is the student able to do on-the-spot sideways criss-cross jumps continuously and clapping when the feet are close together?': 'criss_cross_with_clap',
  '6. How many rounds is the student able to complete making a figure of 8 around the cones while dribbling with big bounce, using the dominant hand?': 'dribbling_ball_8',
  '1. How many seconds is the student able stand on their preferred (dominant) leg leg with their eyes closed?': 'stand_on_dominant_leg',
  '2. How many seconds is the student able stand on their non-preferred (non-dominant) leg with their eyes closed?': 'stand_on_nondominant_leg',
  '5. How many times is the student able to do forward backward open close continuously with their feet alternating? Each time ONE FULL SET is done it is counted as one point.': 'forward_backward_spread_legs',
  '6. How many figure of 8 rounds is the student able to complete around the markers that are at a distance of 3 meters apart while dribbling the basketball using the dominant hand or preferred hand?': 'dribbling_ball_8',
};