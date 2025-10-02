import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/resident.dart';

final fakeResidentsProvider = Provider<List<Resident>>((ref) {
  return [
    Resident(
      id: 'r1',
      name: 'Anna Jansen',
      room: '101A',
      status: ResidentStatus.resting,
      immobileMinutes: 35,
    ),
    Resident(
      id: 'r2',
      name: 'Pieter de Vries',
      room: '102B',
      status: ResidentStatus.exitSoon,
      immobileMinutes: 5,
    ),
    Resident(
      id: 'r3',
      name: 'Klara Müller',
      room: '203',
      status: ResidentStatus.outOfBed,
      immobileMinutes: 0,
    ),
    Resident(
      id: 'r4',
      name: 'John Smith',
      room: '204',
      status: ResidentStatus.restless,
      immobileMinutes: 12,
    ),
    Resident(
      id: 'r5',
      name: 'Maria Gonzalez',
      room: '105C',
      status: ResidentStatus.resting,
      immobileMinutes: 28,
    ),
    Resident(
      id: 'r6',
      name: 'Hans Wagner',
      room: '106A',
      status: ResidentStatus.exitSoon,
      immobileMinutes: 3,
    ),
    Resident(
      id: 'r7',
      name: 'Sophie Laurent',
      room: '107B',
      status: ResidentStatus.restless,
      immobileMinutes: 8,
    ),
    Resident(
      id: 'r8',
      name: 'Chen Wei',
      room: '108D',
      status: ResidentStatus.resting,
      immobileMinutes: 45,
    ),
    Resident(
      id: 'r9',
      name: 'Emma Thompson',
      room: '109A',
      status: ResidentStatus.outOfBed,
      immobileMinutes: 0,
    ),
    Resident(
      id: 'r10',
      name: 'Roberto Silva',
      room: '110C',
      status: ResidentStatus.restless,
      immobileMinutes: 15,
    ),
  ];
});


