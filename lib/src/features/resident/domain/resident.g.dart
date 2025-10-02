// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Resident _$ResidentFromJson(Map<String, dynamic> json) => _Resident(
  id: json['id'] as String,
  name: json['name'] as String,
  room: json['room'] as String,
  status: $enumDecode(_$ResidentStatusEnumMap, json['status']),
  immobileMinutes: (json['immobileMinutes'] as num).toInt(),
);

Map<String, dynamic> _$ResidentToJson(_Resident instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'room': instance.room,
  'status': _$ResidentStatusEnumMap[instance.status]!,
  'immobileMinutes': instance.immobileMinutes,
};

const _$ResidentStatusEnumMap = {
  ResidentStatus.resting: 'resting',
  ResidentStatus.restless: 'restless',
  ResidentStatus.exitSoon: 'exitSoon',
  ResidentStatus.outOfBed: 'outOfBed',
};
