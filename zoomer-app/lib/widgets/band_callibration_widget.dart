import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msap/utils.dart';

class BandCallibrationWidget extends StatelessWidget {
  const BandCallibrationWidget({
    super.key,
    required this.index,
    required this.bandName,
    required this.description,
  });

  final int index;
  final String bandName;
  final String description;

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: utils.paddingHorizontal,
          vertical: utils.paddingVertical,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Band ${index + 1} Calibration',
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: utils.subtitleSize * 0.7,
              ),
            ),
            SizedBox(height: utils.screenHeight * 0.01),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: utils.paddingHorizontal,
                vertical: utils.paddingVertical * 0.5,
              ),
              decoration: BoxDecoration(
                color: utils.selectedContainer,
                borderRadius: BorderRadius.circular(utils.borderRadius),
              ),
              child: Text(
                'Paired',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: utils.subtitleSize * 0.8,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: utils.screenHeight * 0.01),
            Text(
              description,
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: utils.subtitleSize * 0.7,
              ),
            )
          ],
        ),
      ),
    );
  }
}
