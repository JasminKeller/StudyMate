// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_booking.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeBookingAdapter extends TypeAdapter<TimeBooking> {
  @override
  final int typeId = 2;

  @override
  TimeBooking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeBooking(
      id: fields[0] as int,
      comment: fields[1] as String?,
      startDateTime: fields[2] as DateTime,
      endDateTime: fields[3] as DateTime,
      courseId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TimeBooking obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.comment)
      ..writeByte(2)
      ..write(obj.startDateTime)
      ..writeByte(3)
      ..write(obj.endDateTime)
      ..writeByte(4)
      ..write(obj.courseId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeBookingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
