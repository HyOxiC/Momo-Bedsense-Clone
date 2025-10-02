import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadingProvider = FutureProvider<bool>((ref) async {
  // Simulate initial loading; could be backed by real network in future.
  await Future<void>.delayed(const Duration(milliseconds: 900));
  return false;
});
