import 'package:flutter_riverpod/legacy.dart';

final washFoldSearchProvider = StateProvider.autoDispose<String>((ref) => '');
final washIronSearchProvider = StateProvider.autoDispose<String>((ref) => '');
final dryCleanSearchProvider = StateProvider.autoDispose<String>((ref) => '');
final ironOnlySearchProvider = StateProvider.autoDispose<String>((ref) => '');
final shoeCleanSearchProvider = StateProvider.autoDispose<String>((ref) => '');
