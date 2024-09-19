import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msap/utils.dart';

class ExerciseWidget extends StatelessWidget {
  const ExerciseWidget({
    Key? key,
    required this.exerciseName,
    required this.onTap,
  }) : super(key: key);

  final String exerciseName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Added Backgraund color,
          borderRadius: BorderRadius.circular(8), // Added border radius,
          boxShadow: [
            BoxShadow(
              color: Colors.black26.withOpacity(0.1), // added subtitle shadow,
              // spreadRadius: 4,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center align text vertically,
          mainAxisAlignment:
              MainAxisAlignment.center, // Center align text horizontally,
          children: [
            const Icon(
              Icons.fitness_center,
              size: 48,
              color: Color(0xFF1E3D75),
            ), // Added exercise icon,
            const SizedBox(height: 8),
            Text(
              exerciseName,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: const Color(0xFF1E3D75),
                fontWeight: FontWeight.w500,
                fontSize: utils.subtitleSize * 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
