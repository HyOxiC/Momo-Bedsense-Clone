import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'resident.freezed.dart';
part 'resident.g.dart';

enum ResidentStatus { resting, restless, exitSoon, outOfBed }

@freezed
abstract class Resident with _$Resident {
  const Resident._();
  const factory Resident({
    required String id,
    required String name,
    required String room,
    required ResidentStatus status,
    required int immobileMinutes,
  }) = _Resident;

  factory Resident.fromJson(Map<String, dynamic> json) => _$ResidentFromJson(json);

  String get statusLabel {
    switch (this.status) {
      case ResidentStatus.resting:
        return 'Resting';
      case ResidentStatus.restless:
        return 'Restless';
      case ResidentStatus.exitSoon:
        return 'Exit soon';
      case ResidentStatus.outOfBed:
        return 'Out of bed';
    }
  }

  Color get statusColor {
    switch (this.status) {
      case ResidentStatus.resting:
        return const Color(0xFF2E7D32);
      case ResidentStatus.restless:
        return const Color(0xFFF9A825);
      case ResidentStatus.exitSoon:
        return const Color(0xFFD32F2F);
      case ResidentStatus.outOfBed:
        return const Color(0xFF1976D2);
    }
  }

  String get immobileForLabel => this.immobileMinutes == 0 ? '—' : '${this.immobileMinutes} min';
}


