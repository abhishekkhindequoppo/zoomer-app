// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evalutiondata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EvaluationDataAdapter extends TypeAdapter<EvaluationData> {
  @override
  final int typeId = 1;

  @override
  EvaluationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EvaluationData(
      schoolName: fields[0] as String,
      grade: fields[1] as String,
      division: fields[2] as String,
      studentName: fields[3] as String,
      rollNo: fields[4] as int,
      attendance: fields[5] as int,
      evaluationNumber: fields[6] as int,
      timeOfEval: fields[7] as DateTime,
      yearOfEval: fields[8] as int,
      instructorName: fields[9] as String,
      imageId: fields[10] as String,
      skipping: fields[11] as int,
      hitBalloonUp: fields[12] as int,
      dribblingBall8: fields[13] as int,
      dribblingBallO: fields[14] as int,
      jumpSymmetrically: fields[15] as int,
      hop9mDominantLeg: fields[16] as int,
      jumpAsymmetrically: fields[17] as int,
      ballBounceAndCatch: fields[18] as int,
      crissCrossWithClap: fields[19] as int,
      standOnDominantLeg: fields[20] as int,
      hop9mNondominantLeg: fields[21] as int,
      stepDownDominantLeg: fields[22] as String,
      stepOverDominantLeg: fields[23] as String,
      crissCrossLegForward: fields[24] as int,
      jumpingJacksWithClap: fields[25] as int,
      crissCrossWithoutClap: fields[26] as int,
      hopForwardDominantLeg: fields[27] as int,
      standOnNondominantLeg: fields[28] as int,
      stepDownNondominantLeg: fields[29] as String,
      stepOverNondominantLeg: fields[30] as String,
      jumpingJacksWithoutClap: fields[31] as int,
      hopForwardNondominantLeg: fields[32] as int,
      forwardBackwardSpreadLegs: fields[33] as int,
      alternateForwardBackwardLegs: fields[34] as int,
    );
  }

  @override
  void write(BinaryWriter writer, EvaluationData obj) {
    writer
      ..writeByte(35)
      ..writeByte(0)
      ..write(obj.schoolName)
      ..writeByte(1)
      ..write(obj.grade)
      ..writeByte(2)
      ..write(obj.division)
      ..writeByte(3)
      ..write(obj.studentName)
      ..writeByte(4)
      ..write(obj.rollNo)
      ..writeByte(5)
      ..write(obj.attendance)
      ..writeByte(6)
      ..write(obj.evaluationNumber)
      ..writeByte(7)
      ..write(obj.timeOfEval)
      ..writeByte(8)
      ..write(obj.yearOfEval)
      ..writeByte(9)
      ..write(obj.instructorName)
      ..writeByte(10)
      ..write(obj.imageId)
      ..writeByte(11)
      ..write(obj.skipping)
      ..writeByte(12)
      ..write(obj.hitBalloonUp)
      ..writeByte(13)
      ..write(obj.dribblingBall8)
      ..writeByte(14)
      ..write(obj.dribblingBallO)
      ..writeByte(15)
      ..write(obj.jumpSymmetrically)
      ..writeByte(16)
      ..write(obj.hop9mDominantLeg)
      ..writeByte(17)
      ..write(obj.jumpAsymmetrically)
      ..writeByte(18)
      ..write(obj.ballBounceAndCatch)
      ..writeByte(19)
      ..write(obj.crissCrossWithClap)
      ..writeByte(20)
      ..write(obj.standOnDominantLeg)
      ..writeByte(21)
      ..write(obj.hop9mNondominantLeg)
      ..writeByte(22)
      ..write(obj.stepDownDominantLeg)
      ..writeByte(23)
      ..write(obj.stepOverDominantLeg)
      ..writeByte(24)
      ..write(obj.crissCrossLegForward)
      ..writeByte(25)
      ..write(obj.jumpingJacksWithClap)
      ..writeByte(26)
      ..write(obj.crissCrossWithoutClap)
      ..writeByte(27)
      ..write(obj.hopForwardDominantLeg)
      ..writeByte(28)
      ..write(obj.standOnNondominantLeg)
      ..writeByte(29)
      ..write(obj.stepDownNondominantLeg)
      ..writeByte(30)
      ..write(obj.stepOverNondominantLeg)
      ..writeByte(31)
      ..write(obj.jumpingJacksWithoutClap)
      ..writeByte(32)
      ..write(obj.hopForwardNondominantLeg)
      ..writeByte(33)
      ..write(obj.forwardBackwardSpreadLegs)
      ..writeByte(34)
      ..write(obj.alternateForwardBackwardLegs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvaluationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
