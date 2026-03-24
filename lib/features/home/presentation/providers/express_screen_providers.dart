// import 'package:flutter_riverpod/legacy.dart';

// // =====================================================================
// // EXPRESS SERVICE ENUM
// // =====================================================================

// enum ExpressService {
//   washFold('Wash & Fold', '🫧'),
//   washIron('Wash & Iron', '👕'),
//   dryClean('Dry Clean', '✨'),
//   ironOnly('Iron Only', '🔥');

//   final String label;
//   final String emoji;
//   const ExpressService(this.label, this.emoji);
// }

// // =====================================================================
// // EXPRESS TIME ENUM
// // =====================================================================

// enum ExpressTime {
//   sixHr('6hr', 'Same day', '30% extra'),
//   twelveHr('12hr', 'Half day', '20% extra'),
//   twentyFourHr('24hr', 'Next day', '10% extra');

//   final String label;
//   final String sublabel;
//   final String surcharge;
//   const ExpressTime(this.label, this.sublabel, this.surcharge);
// }

// // =====================================================================
// // PROVIDERS
// // =====================================================================

// final expressServiceProvider = StateProvider.autoDispose<ExpressService>(
//   (ref) => ExpressService.washFold,
// );

// final expressTimeProvider = StateProvider.autoDispose<ExpressTime>(
//   (ref) => ExpressTime.twentyFourHr,
// );
