// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:go_router/go_router.dart';
// import 'package:whirl_wash/features/home/presentation/providers/service_search_provider.dart';
// import '../../../../../core/constants/app_colors.dart';
// import '../../../data/models/fabric_type.dart';
// import '../../../data/repositories/config_repository.dart';
// import '../../providers/cart_provider.dart';
// import '../../providers/config_providers.dart';
// import '../../widgets/service_item_card.dart';
// import '../../widgets/service_search_bar.dart';
// import '../../widgets/service_bottom_bar.dart';
// import '../../widgets/service_fabric_sheet.dart';

// // =====================================================================
// // LOCAL STATE PROVIDERS
// // =====================================================================

// // Stores selected service id (e.g. 'wash_fold')
// final _selectedServiceIdProvider = StateProvider<String?>((ref) => null);

// // Stores selected express time
// final _selectedTimeProvider = StateProvider<ExpressTimeConfig?>((ref) => null);

// // =====================================================================
// // MAIN SCREEN
// // =====================================================================

// class ExpressScreen extends ConsumerWidget {
//   const ExpressScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final servicesAsync = ref.watch(expressServicesConfigProvider);
//     final timesAsync = ref.watch(expressTimesConfigProvider);
//     final selectedServiceId = ref.watch(_selectedServiceIdProvider);
//     final selectedTime = ref.watch(_selectedTimeProvider);

//     // Auto-select first service and time when data loads
//     ref.listen(expressServicesConfigProvider, (_, next) {
//       next.whenData((services) {
//         if (services.isNotEmpty &&
//             ref.read(_selectedServiceIdProvider) == null) {
//           ref.read(_selectedServiceIdProvider.notifier).state =
//               services.first.id;
//         }
//       });
//     });

//     ref.listen(expressTimesConfigProvider, (_, next) {
//       next.whenData((times) {
//         if (times.isNotEmpty && ref.read(_selectedTimeProvider) == null) {
//           ref.read(_selectedTimeProvider.notifier).state = times.first;
//         }
//       });
//     });

//     final totalItems = _getTotalItems(ref, selectedServiceId);

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: _buildAppBar(context),
//       body: Column(
//         children: [
//           // Service selector
//           _ServiceSelector(
//             servicesAsync: servicesAsync,
//             selectedId: selectedServiceId,
//           ),

//           // Time selector
//           _TimeSelector(timesAsync: timesAsync, selectedTime: selectedTime),

//           // Surcharge banner
//           if (selectedTime != null)
//             _SurchargeBanner(surcharge: selectedTime.surcharge),

//           // Item list
//           if (selectedServiceId != null)
//             Expanded(child: _ServiceItemList(serviceId: selectedServiceId))
//           else
//             const Expanded(child: Center(child: CircularProgressIndicator())),
//         ],
//       ),
//       bottomSheet: ServiceBottomBar(
//         totalItems: totalItems,
//         accentColor: Colors.orange,
//       ),
//     );
//   }

//   int _getTotalItems(WidgetRef ref, String? serviceId) {
//     if (serviceId == null) return 0;
//     return ref.watch(cartServiceTotalProvider(serviceId));
//   }

//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.black,
//       elevation: 0,
//       leading: GestureDetector(
//         onTap: () => context.pop(),
//         child: Container(
//           margin: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.white.withValues(alpha: 0.08),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: const Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: Colors.white,
//             size: 18,
//           ),
//         ),
//       ),
//       title: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: Colors.orange.withValues(alpha: 0.2),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(
//               Icons.bolt_rounded,
//               color: Colors.orange,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 10),
//           const Text(
//             'Express',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//             decoration: BoxDecoration(
//               color: Colors.orange.withValues(alpha: 0.15),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: Colors.orange.withValues(alpha: 0.4),
//                 width: 1,
//               ),
//             ),
//             child: const Text(
//               'FAST',
//               style: TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w800,
//                 color: Colors.orange,
//                 letterSpacing: 1,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =====================================================================
// // SERVICE SELECTOR — from Firestore
// // =====================================================================

// class _ServiceSelector extends ConsumerWidget {
//   final AsyncValue<List<ServiceConfig>> servicesAsync;
//   final String? selectedId;

//   const _ServiceSelector({
//     required this.servicesAsync,
//     required this.selectedId,
//   });

//   static const Map<String, IconData> _iconMap = {
//     'local_laundry_service': Icons.local_laundry_service_rounded,
//     'iron': Icons.iron_rounded,
//     'dry_cleaning': Icons.dry_cleaning_rounded,
//     'checkroom': Icons.checkroom_rounded,
//     'cleaning_services': Icons.cleaning_services_rounded,
//     'flash_on': Icons.flash_on_rounded,
//   };

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Select Service',
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: Colors.white.withValues(alpha: 0.5),
//               letterSpacing: 0.5,
//             ),
//           ),
//           const SizedBox(height: 10),
//           servicesAsync.when(
//             loading: () => const SizedBox(
//               height: 60,
//               child: Center(child: CircularProgressIndicator()),
//             ),
//             error: (_, __) => const SizedBox.shrink(),
//             data: (services) => Row(
//               children: services.asMap().entries.map((entry) {
//                 final index = entry.key;
//                 final service = entry.value;
//                 final isSelected = selectedId == service.id;
//                 final icon =
//                     _iconMap[service.icon] ??
//                     Icons.local_laundry_service_rounded;
//                 return Expanded(
//                   child: Opacity(
//                     opacity: service.enabled ? 1.0 : 0.4,
//                     child: GestureDetector(
//                       onTap: service.enabled
//                           ? () =>
//                                 ref
//                                     .read(_selectedServiceIdProvider.notifier)
//                                     .state = service
//                                     .id
//                           : null,
//                       child: Container(
//                         margin: EdgeInsets.only(
//                           right: index < services.length - 1 ? 8 : 0,
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? Colors.orange.withValues(alpha: 0.15)
//                               : const Color(0xFF141414),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: isSelected
//                                 ? Colors.orange.withValues(alpha: 0.5)
//                                 : Colors.white.withValues(alpha: 0.08),
//                             width: 1,
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             Icon(
//                               icon,
//                               size: 20,
//                               color: isSelected
//                                   ? Colors.orange
//                                   : Colors.white.withValues(alpha: 0.6),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               service.name,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: isSelected
//                                     ? FontWeight.w600
//                                     : FontWeight.w400,
//                                 color: isSelected
//                                     ? Colors.orange
//                                     : Colors.white.withValues(alpha: 0.6),
//                               ),
//                             ),
//                             if (!service.enabled) ...[
//                               const SizedBox(height: 2),
//                               Text(
//                                 'Unavailable',
//                                 style: TextStyle(
//                                   fontSize: 8,
//                                   color: Colors.white.withValues(alpha: 0.4),
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =====================================================================
// // TIME SELECTOR — from Firestore
// // =====================================================================

// class _TimeSelector extends ConsumerWidget {
//   final AsyncValue<List<ExpressTimeConfig>> timesAsync;
//   final ExpressTimeConfig? selectedTime;

//   const _TimeSelector({required this.timesAsync, required this.selectedTime});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Turnaround Time',
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: Colors.white.withValues(alpha: 0.5),
//               letterSpacing: 0.5,
//             ),
//           ),
//           const SizedBox(height: 10),
//           timesAsync.when(
//             loading: () => const SizedBox(
//               height: 60,
//               child: Center(child: CircularProgressIndicator()),
//             ),
//             error: (_, __) => const SizedBox.shrink(),
//             data: (times) => Row(
//               children: times.asMap().entries.map((entry) {
//                 final index = entry.key;
//                 final time = entry.value;
//                 final isSelected = selectedTime?.id == time.id;
//                 return Expanded(
//                   child: Opacity(
//                     opacity: time.enabled ? 1.0 : 0.4,
//                     child: GestureDetector(
//                       onTap: time.enabled
//                           ? () =>
//                                 ref.read(_selectedTimeProvider.notifier).state =
//                                     time
//                           : null,
//                       child: Container(
//                         margin: EdgeInsets.only(
//                           right: index < times.length - 1 ? 8 : 0,
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? Colors.orange.withValues(alpha: 0.15)
//                               : const Color(0xFF141414),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: isSelected
//                                 ? Colors.orange.withValues(alpha: 0.5)
//                                 : Colors.white.withValues(alpha: 0.08),
//                             width: 1,
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             Text(
//                               time.label,
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w700,
//                                 color: isSelected
//                                     ? Colors.orange
//                                     : Colors.white.withValues(alpha: 0.7),
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               time.sublabel,
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 color: isSelected
//                                     ? Colors.orange.withValues(alpha: 0.7)
//                                     : Colors.white.withValues(alpha: 0.35),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =====================================================================
// // SURCHARGE BANNER — surcharge is now int
// // =====================================================================

// class _SurchargeBanner extends StatelessWidget {
//   final int surcharge;
//   const _SurchargeBanner({required this.surcharge});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.orange.withValues(alpha: 0.08),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Colors.orange.withValues(alpha: 0.25),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.bolt_rounded, size: 16, color: Colors.orange),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               '$surcharge% express surcharge applies · Priced per kg',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.orange.withValues(alpha: 0.85),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =====================================================================
// // ITEM LIST — based on selected service id
// // =====================================================================

// class _ServiceItemList extends ConsumerWidget {
//   final String serviceId;
//   const _ServiceItemList({required this.serviceId});

//   bool get _isIronOnly => serviceId == 'iron_only';
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final itemsAsync = ref.watch(itemsConfigProvider(serviceId));
//     final searchProvider = _isIronOnly
//         ? ironOnlySearchProvider
//         : washFoldSearchProvider;
//     final searchQuery = ref.watch(searchProvider);

//     return Column(
//       children: [
//         ServiceSearchBar(searchProvider: searchProvider),
//         Expanded(
//           child: itemsAsync.when(
//             loading: () => const Center(child: CircularProgressIndicator()),
//             error: (_, __) => const Center(
//               child: Text(
//                 'Failed to load items',
//                 style: TextStyle(color: Colors.white54),
//               ),
//             ),
//             data: (items) {
//               final filtered = items
//                   .where(
//                     (item) => item.name.toLowerCase().contains(
//                       searchQuery.toLowerCase(),
//                     ),
//                   )
//                   .toList();

//               if (_isIronOnly) {
//                 return _buildIronList(context, ref, filtered, searchQuery);
//               } else {
//                 return _buildWashFoldList(
//                   context,
//                   ref,
//                   filtered,
//                   searchQuery,
//                   serviceId,
//                 );
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildWashFoldList(
//     BuildContext context,
//     WidgetRef ref,
//     List<ItemConfig> filtered,
//     String searchQuery,
//     String serviceId,
//   ) {
//     final cartMap = ref.watch(cartProvider);
//     final notifier = ref.read(cartProvider.notifier);
//     return ListView(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
//       children: [
//         ...filtered.map((item) {
//           final entry = notifier.entryFor(item.id, serviceId);
//           final cartEntry = cartMap['${serviceId}_${item.id}'];
//           return ServiceItemCard(
//             emoji: item.emoji,
//             name: item.name,
//             quantity: cartEntry?.quantity ?? 0,
//             fabric: cartEntry?.fabric,
//             onIncrement: () => notifier.increment(item.id, serviceId),
//             onDecrement: () => notifier.decrement(item.id, serviceId),
//             onFabricSelect: (f) => notifier.setFabric(item.id, serviceId, f),
//           );
//         }),
//         ...cartMap.values
//             .where((e) => e.serviceId == serviceId && e.isCustom)
//             .map(
//               (e) => ServiceItemCard(
//                 emoji: '🧺',
//                 name: e.customName!,
//                 quantity: e.quantity,
//                 fabric: e.fabric,
//                 onIncrement: () => notifier.increment(e.itemId, serviceId),
//                 onDecrement: () => notifier.decrement(e.itemId, serviceId),
//                 onFabricSelect: (f) =>
//                     notifier.setFabric(e.itemId, serviceId, f),
//               ),
//             ),
//         _AddCustomWashFoldCard(),
//         const SizedBox(height: 12),
//       ],
//     );
//   }

//   Widget _buildIronList(
//     BuildContext context,
//     WidgetRef ref,
//     List<ItemConfig> filtered,
//     String searchQuery,
//   ) {
//     final cartMap = ref.watch(cartProvider);
//     final notifier = ref.read(cartProvider.notifier);
//     const serviceId = 'iron_only';
//     return ListView(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
//       children: [
//         ...filtered.map((item) {
//           final cartEntry = cartMap['${serviceId}_${item.id}'];
//           return ServiceItemCard(
//             emoji: item.emoji,
//             name: item.name,
//             quantity: cartEntry?.quantity ?? 0,
//             onIncrement: () => notifier.increment(item.id, serviceId),
//             onDecrement: () => notifier.decrement(item.id, serviceId),
//           );
//         }),
//         ...cartMap.values
//             .where((e) => e.serviceId == serviceId && e.isCustom)
//             .map(
//               (e) => ServiceItemCard(
//                 emoji: '🧺',
//                 name: e.customName!,
//                 quantity: e.quantity,
//                 onIncrement: () => notifier.increment(e.itemId, serviceId),
//                 onDecrement: () => notifier.decrement(e.itemId, serviceId),
//               ),
//             ),
//         _AddCustomIronCard(),
//         const SizedBox(height: 12),
//       ],
//     );
//   }
// }

// // =====================================================================
// // ADD CUSTOM CARDS
// // =====================================================================

// class _AddCustomWashFoldCard extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final controller = ref.watch(_exWFControllerProvider);
//     final qty = ref.watch(_exWFQtyProvider);
//     final fabric = ref.watch(_exWFFabricProvider);

//     return _CustomCardBase(
//       controller: controller,
//       qty: qty,
//       hintText: 'Item name (e.g. Dupatta, Blanket...)',
//       onDecrement: () => ref.read(_exWFQtyProvider.notifier).state--,
//       onIncrement: () => ref.read(_exWFQtyProvider.notifier).state++,
//       showFabric: true,
//       fabricLabel: fabric == FabricType.dontKnow
//           ? 'Select fabric'
//           : fabric.label,
//       fabricHasSelection: fabric != FabricType.dontKnow,
//       onFabricTap: () => showModalBottomSheet(
//         context: context,
//         backgroundColor: Colors.transparent,
//         builder: (_) => ServiceCustomFabricSheet(
//           selected: fabric,
//           onSelect: (f) => ref.read(_exWFFabricProvider.notifier).state = f,
//         ),
//       ),
//       onAdd: () {
//         final name = controller.text.trim();
//         if (name.isNotEmpty) {
//           ref
//               .read(cartProvider.notifier)
//               .addCustom(
//                 name: name,
//                 serviceId: ref.read(_selectedServiceIdProvider) ?? 'wash_fold',
//                 quantity: qty,
//                 fabric: fabric,
//               );
//           controller.clear();
//           ref.read(_exWFQtyProvider.notifier).state = 1;
//           ref.read(_exWFFabricProvider.notifier).state = FabricType.dontKnow;
//         }
//       },
//     );
//   }
// }

// class _AddCustomIronCard extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final controller = ref.watch(_exIronControllerProvider);
//     final qty = ref.watch(_exIronQtyProvider);

//     return _CustomCardBase(
//       controller: controller,
//       qty: qty,
//       hintText: 'Item name (e.g. Dupatta, Blanket...)',
//       onDecrement: () => ref.read(_exIronQtyProvider.notifier).state--,
//       onIncrement: () => ref.read(_exIronQtyProvider.notifier).state++,
//       showFabric: false,
//       onAdd: () {
//         final name = controller.text.trim();
//         if (name.isNotEmpty) {
//           ref
//               .read(cartProvider.notifier)
//               .addCustom(name: name, serviceId: 'iron_only', quantity: qty);
//           controller.clear();
//           ref.read(_exIronQtyProvider.notifier).state = 1;
//         }
//       },
//     );
//   }
// }

// class _CustomCardBase extends StatelessWidget {
//   final TextEditingController controller;
//   final int qty;
//   final String hintText;
//   final VoidCallback onDecrement;
//   final VoidCallback onIncrement;
//   final VoidCallback onAdd;
//   final bool showFabric;
//   final String? fabricLabel;
//   final bool fabricHasSelection;
//   final VoidCallback? onFabricTap;

//   const _CustomCardBase({
//     required this.controller,
//     required this.qty,
//     required this.hintText,
//     required this.onDecrement,
//     required this.onIncrement,
//     required this.onAdd,
//     this.showFabric = true,
//     this.fabricLabel,
//     this.fabricHasSelection = false,
//     this.onFabricTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF141414),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.white.withValues(alpha: 0.1),
//           width: 1,
//         ),
//       ),
//       padding: const EdgeInsets.all(14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.add_circle_outline_rounded,
//                 color: AppColors.secondary,
//                 size: 20,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 'Add Custom Item',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.secondary,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Container(
//             height: 46,
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(alpha: 0.06),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: Colors.white.withValues(alpha: 0.1),
//                 width: 1,
//               ),
//             ),
//             child: TextField(
//               controller: controller,
//               style: const TextStyle(color: Colors.white, fontSize: 14),
//               decoration: InputDecoration(
//                 hintText: hintText,
//                 hintStyle: TextStyle(
//                   color: Colors.white.withValues(alpha: 0.3),
//                   fontSize: 13,
//                 ),
//                 prefixIcon: Icon(
//                   Icons.edit_rounded,
//                   size: 18,
//                   color: Colors.white.withValues(alpha: 0.3),
//                 ),
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 14,
//                   vertical: 14,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withValues(alpha: 0.05),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: Colors.white.withValues(alpha: 0.08),
//                     width: 1,
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     GestureDetector(
//                       onTap: qty > 1 ? onDecrement : null,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 12,
//                         ),
//                         child: Icon(
//                           Icons.remove,
//                           size: 16,
//                           color: Colors.white.withValues(
//                             alpha: qty > 1 ? 0.8 : 0.25,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Text(
//                       '$qty',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: onIncrement,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 12,
//                         ),
//                         child: Icon(
//                           Icons.add,
//                           size: 16,
//                           color: Colors.white.withValues(alpha: 0.8),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (showFabric) ...[
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: onFabricTap,
//                     child: Container(
//                       height: 46,
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withValues(alpha: 0.05),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: Colors.white.withValues(alpha: 0.08),
//                           width: 1,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.texture_rounded,
//                             size: 16,
//                             color: fabricHasSelection
//                                 ? AppColors.secondary
//                                 : Colors.white.withValues(alpha: 0.35),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               fabricLabel ?? 'Select fabric',
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: fabricHasSelection
//                                     ? AppColors.secondary
//                                     : Colors.white.withValues(alpha: 0.4),
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           Icon(
//                             Icons.keyboard_arrow_down_rounded,
//                             size: 16,
//                             color: Colors.white.withValues(alpha: 0.3),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ] else
//                 const Spacer(),
//               const SizedBox(width: 10),
//               GestureDetector(
//                 onTap: onAdd,
//                 child: Container(
//                   height: 46,
//                   width: 46,
//                   decoration: BoxDecoration(
//                     color: AppColors.secondary.withValues(alpha: 0.15),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: AppColors.secondary.withValues(alpha: 0.4),
//                       width: 1,
//                     ),
//                   ),
//                   child: Icon(
//                     Icons.check_rounded,
//                     color: AppColors.secondary,
//                     size: 22,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =====================================================================
// // LOCAL PROVIDERS
// // =====================================================================

// final _exWFControllerProvider = Provider.autoDispose<TextEditingController>((
//   ref,
// ) {
//   final c = TextEditingController();
//   ref.onDispose(() => c.dispose());
//   return c;
// });
// final _exWFQtyProvider = StateProvider.autoDispose<int>((ref) => 1);
// final _exWFFabricProvider = StateProvider.autoDispose<FabricType>(
//   (ref) => FabricType.dontKnow,
// );
// final _exIronControllerProvider = Provider.autoDispose<TextEditingController>((
//   ref,
// ) {
//   final c = TextEditingController();
//   ref.onDispose(() => c.dispose());
//   return c;
// });
// final _exIronQtyProvider = StateProvider.autoDispose<int>((ref) => 1);

// --------------------------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:go_router/go_router.dart';
// import 'package:whirl_wash/features/home/presentation/providers/service_search_provider.dart';
// import '../../../../../core/constants/app_colors.dart';
// import '../../../data/models/fabric_type.dart';
// import '../../../data/repositories/config_repository.dart';
// import '../../providers/cart_provider.dart';
// import '../../providers/config_providers.dart';
// import '../../widgets/service_item_card.dart';
// import '../../widgets/service_search_bar.dart';
// import '../../widgets/service_bottom_bar.dart';
// import '../../widgets/service_fabric_sheet.dart';

// // =====================================================================
// // LOCAL STATE PROVIDERS
// // =====================================================================

// // Stores selected service id (e.g. 'wash_fold')
// final _selectedServiceIdProvider = StateProvider<String?>((ref) => null);

// // Stores selected express time
// final _selectedTimeProvider = StateProvider<ExpressTimeConfig?>((ref) => null);

// // =====================================================================
// // MAIN SCREEN
// // =====================================================================

// class ExpressScreen extends ConsumerWidget {
//   const ExpressScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final servicesAsync = ref.watch(expressServicesConfigProvider);
//     final timesAsync = ref.watch(expressTimesConfigProvider);
//     final selectedServiceId = ref.watch(_selectedServiceIdProvider);
//     final selectedTime = ref.watch(_selectedTimeProvider);

//     // Auto-select first service and time when data loads
//     ref.listen(expressServicesConfigProvider, (_, next) {
//       next.whenData((services) {
//         if (services.isNotEmpty &&
//             ref.read(_selectedServiceIdProvider) == null) {
//           ref.read(_selectedServiceIdProvider.notifier).state =
//               services.first.id;
//         }
//       });
//     });

//     ref.listen(expressTimesConfigProvider, (_, next) {
//       next.whenData((times) {
//         if (times.isNotEmpty && ref.read(_selectedTimeProvider) == null) {
//           ref.read(_selectedTimeProvider.notifier).state = times.first;
//         }
//       });
//     });

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: _buildAppBar(context),
//       body: Column(
//         children: [
//           // Service selector
//           _ServiceSelector(
//             servicesAsync: servicesAsync,
//             selectedId: selectedServiceId,
//           ),

//           // Time selector
//           _TimeSelector(timesAsync: timesAsync, selectedTime: selectedTime),

//           // Surcharge banner
//           if (selectedTime != null)
//             _SurchargeBanner(surcharge: selectedTime.surcharge),

//           // Item list
//           if (selectedServiceId != null)
//             Expanded(child: _ServiceItemList(serviceId: selectedServiceId))
//           else
//             const Expanded(child: Center(child: CircularProgressIndicator())),
//         ],
//       ),
//       bottomSheet: const ServiceBottomBar(accentColor: Colors.orange),
//     );
//   }

//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.black,
//       elevation: 0,
//       leading: GestureDetector(
//         onTap: () => context.pop(),
//         child: Container(
//           margin: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.white.withValues(alpha: 0.08),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: const Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: Colors.white,
//             size: 18,
//           ),
//         ),
//       ),
//       title: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: Colors.orange.withValues(alpha: 0.2),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(
//               Icons.bolt_rounded,
//               color: Colors.orange,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 10),
//           const Text(
//             'Express',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//             decoration: BoxDecoration(
//               color: Colors.orange.withValues(alpha: 0.15),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: Colors.orange.withValues(alpha: 0.4),
//                 width: 1,
//               ),
//             ),
//             child: const Text(
//               'FAST',
//               style: TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w800,
//                 color: Colors.orange,
//                 letterSpacing: 1,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =====================================================================
// // SERVICE SELECTOR — from Firestore
// // =====================================================================

// class _ServiceSelector extends ConsumerWidget {
//   final AsyncValue<List<ServiceConfig>> servicesAsync;
//   final String? selectedId;

//   const _ServiceSelector({
//     required this.servicesAsync,
//     required this.selectedId,
//   });

//   static const Map<String, IconData> _iconMap = {
//     'local_laundry_service': Icons.local_laundry_service_rounded,
//     'iron': Icons.iron_rounded,
//     'dry_cleaning': Icons.dry_cleaning_rounded,
//     'checkroom': Icons.checkroom_rounded,
//     'cleaning_services': Icons.cleaning_services_rounded,
//     'flash_on': Icons.flash_on_rounded,
//   };

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Select Service',
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: Colors.white.withValues(alpha: 0.5),
//               letterSpacing: 0.5,
//             ),
//           ),
//           const SizedBox(height: 10),
//           servicesAsync.when(
//             loading: () => const SizedBox(
//               height: 60,
//               child: Center(child: CircularProgressIndicator()),
//             ),
//             error: (_, __) => const SizedBox.shrink(),
//             data: (services) => Row(
//               children: services.asMap().entries.map((entry) {
//                 final index = entry.key;
//                 final service = entry.value;
//                 final isSelected = selectedId == service.id;
//                 final icon =
//                     _iconMap[service.icon] ??
//                     Icons.local_laundry_service_rounded;
//                 return Expanded(
//                   child: Opacity(
//                     opacity: service.enabled ? 1.0 : 0.4,
//                     child: GestureDetector(
//                       onTap: service.enabled
//                           ? () =>
//                                 ref
//                                     .read(_selectedServiceIdProvider.notifier)
//                                     .state = service
//                                     .id
//                           : null,
//                       child: Container(
//                         margin: EdgeInsets.only(
//                           right: index < services.length - 1 ? 8 : 0,
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? Colors.orange.withValues(alpha: 0.15)
//                               : const Color(0xFF141414),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: isSelected
//                                 ? Colors.orange.withValues(alpha: 0.5)
//                                 : Colors.white.withValues(alpha: 0.08),
//                             width: 1,
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             Icon(
//                               icon,
//                               size: 20,
//                               color: isSelected
//                                   ? Colors.orange
//                                   : Colors.white.withValues(alpha: 0.6),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               service.name,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: isSelected
//                                     ? FontWeight.w600
//                                     : FontWeight.w400,
//                                 color: isSelected
//                                     ? Colors.orange
//                                     : Colors.white.withValues(alpha: 0.6),
//                               ),
//                             ),
//                             if (!service.enabled) ...[
//                               const SizedBox(height: 2),
//                               Text(
//                                 'Unavailable',
//                                 style: TextStyle(
//                                   fontSize: 8,
//                                   color: Colors.white.withValues(alpha: 0.4),
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =====================================================================
// // TIME SELECTOR — from Firestore
// // =====================================================================

// class _TimeSelector extends ConsumerWidget {
//   final AsyncValue<List<ExpressTimeConfig>> timesAsync;
//   final ExpressTimeConfig? selectedTime;

//   const _TimeSelector({required this.timesAsync, required this.selectedTime});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Turnaround Time',
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: Colors.white.withValues(alpha: 0.5),
//               letterSpacing: 0.5,
//             ),
//           ),
//           const SizedBox(height: 10),
//           timesAsync.when(
//             loading: () => const SizedBox(
//               height: 60,
//               child: Center(child: CircularProgressIndicator()),
//             ),
//             error: (_, __) => const SizedBox.shrink(),
//             data: (times) => Row(
//               children: times.asMap().entries.map((entry) {
//                 final index = entry.key;
//                 final time = entry.value;
//                 final isSelected = selectedTime?.id == time.id;
//                 return Expanded(
//                   child: Opacity(
//                     opacity: time.enabled ? 1.0 : 0.4,
//                     child: GestureDetector(
//                       onTap: time.enabled
//                           ? () =>
//                                 ref.read(_selectedTimeProvider.notifier).state =
//                                     time
//                           : null,
//                       child: Container(
//                         margin: EdgeInsets.only(
//                           right: index < times.length - 1 ? 8 : 0,
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? Colors.orange.withValues(alpha: 0.15)
//                               : const Color(0xFF141414),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: isSelected
//                                 ? Colors.orange.withValues(alpha: 0.5)
//                                 : Colors.white.withValues(alpha: 0.08),
//                             width: 1,
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             Text(
//                               time.label,
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w700,
//                                 color: isSelected
//                                     ? Colors.orange
//                                     : Colors.white.withValues(alpha: 0.7),
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               time.sublabel,
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 color: isSelected
//                                     ? Colors.orange.withValues(alpha: 0.7)
//                                     : Colors.white.withValues(alpha: 0.35),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =====================================================================
// // SURCHARGE BANNER — surcharge is now int
// // =====================================================================

// class _SurchargeBanner extends StatelessWidget {
//   final int surcharge;
//   const _SurchargeBanner({required this.surcharge});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.orange.withValues(alpha: 0.08),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Colors.orange.withValues(alpha: 0.25),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.bolt_rounded, size: 16, color: Colors.orange),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               '$surcharge% express surcharge applies · Priced per kg',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.orange.withValues(alpha: 0.85),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =====================================================================
// // ITEM LIST — based on selected service id
// // =====================================================================

// class _ServiceItemList extends ConsumerWidget {
//   final String serviceId;
//   const _ServiceItemList({required this.serviceId});

//   bool get _isIronOnly => serviceId == 'iron_only';
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final itemsAsync = ref.watch(itemsConfigProvider(serviceId));
//     final searchProvider = _isIronOnly
//         ? ironOnlySearchProvider
//         : washFoldSearchProvider;
//     final searchQuery = ref.watch(searchProvider);

//     return Column(
//       children: [
//         ServiceSearchBar(searchProvider: searchProvider),
//         Expanded(
//           child: itemsAsync.when(
//             loading: () => const Center(child: CircularProgressIndicator()),
//             error: (_, __) => const Center(
//               child: Text(
//                 'Failed to load items',
//                 style: TextStyle(color: Colors.white54),
//               ),
//             ),
//             data: (items) {
//               final filtered = items
//                   .where(
//                     (item) => item.name.toLowerCase().contains(
//                       searchQuery.toLowerCase(),
//                     ),
//                   )
//                   .toList();

//               if (_isIronOnly) {
//                 return _buildIronList(context, ref, filtered, searchQuery);
//               } else {
//                 return _buildWashFoldList(
//                   context,
//                   ref,
//                   filtered,
//                   searchQuery,
//                   serviceId,
//                 );
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildWashFoldList(
//     BuildContext context,
//     WidgetRef ref,
//     List<ItemConfig> filtered,
//     String searchQuery,
//     String serviceId,
//   ) {
//     final cartMap = ref.watch(cartProvider);
//     final notifier = ref.read(cartProvider.notifier);
//     return ListView(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
//       children: [
//         ...filtered.map((item) {
//           final entry = notifier.entryFor(item.id, serviceId);
//           final cartEntry = cartMap['${serviceId}_${item.id}'];
//           return ServiceItemCard(
//             emoji: item.emoji,
//             name: item.name,
//             quantity: cartEntry?.quantity ?? 0,
//             fabric: cartEntry?.fabric,
//             onIncrement: () => notifier.increment(item.id, serviceId),
//             onDecrement: () => notifier.decrement(item.id, serviceId),
//             onFabricSelect: (f) => notifier.setFabric(item.id, serviceId, f),
//           );
//         }),
//         ...cartMap.values
//             .where((e) => e.serviceId == serviceId && e.isCustom)
//             .map(
//               (e) => ServiceItemCard(
//                 emoji: '🧺',
//                 name: e.customName!,
//                 quantity: e.quantity,
//                 fabric: e.fabric,
//                 onIncrement: () => notifier.increment(e.itemId, serviceId),
//                 onDecrement: () => notifier.decrement(e.itemId, serviceId),
//                 onFabricSelect: (f) =>
//                     notifier.setFabric(e.itemId, serviceId, f),
//               ),
//             ),
//         _AddCustomWashFoldCard(),
//         const SizedBox(height: 12),
//       ],
//     );
//   }

//   Widget _buildIronList(
//     BuildContext context,
//     WidgetRef ref,
//     List<ItemConfig> filtered,
//     String searchQuery,
//   ) {
//     final cartMap = ref.watch(cartProvider);
//     final notifier = ref.read(cartProvider.notifier);
//     const serviceId = 'iron_only';
//     return ListView(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
//       children: [
//         ...filtered.map((item) {
//           final cartEntry = cartMap['${serviceId}_${item.id}'];
//           return ServiceItemCard(
//             emoji: item.emoji,
//             name: item.name,
//             quantity: cartEntry?.quantity ?? 0,
//             onIncrement: () => notifier.increment(item.id, serviceId),
//             onDecrement: () => notifier.decrement(item.id, serviceId),
//           );
//         }),
//         ...cartMap.values
//             .where((e) => e.serviceId == serviceId && e.isCustom)
//             .map(
//               (e) => ServiceItemCard(
//                 emoji: '🧺',
//                 name: e.customName!,
//                 quantity: e.quantity,
//                 onIncrement: () => notifier.increment(e.itemId, serviceId),
//                 onDecrement: () => notifier.decrement(e.itemId, serviceId),
//               ),
//             ),
//         _AddCustomIronCard(),
//         const SizedBox(height: 12),
//       ],
//     );
//   }
// }

// // =====================================================================
// // ADD CUSTOM CARDS
// // =====================================================================

// class _AddCustomWashFoldCard extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final controller = ref.watch(_exWFControllerProvider);
//     final qty = ref.watch(_exWFQtyProvider);
//     final fabric = ref.watch(_exWFFabricProvider);

//     return _CustomCardBase(
//       controller: controller,
//       qty: qty,
//       hintText: 'Item name (e.g. Dupatta, Blanket...)',
//       onDecrement: () => ref.read(_exWFQtyProvider.notifier).state--,
//       onIncrement: () => ref.read(_exWFQtyProvider.notifier).state++,
//       showFabric: true,
//       fabricLabel: fabric == FabricType.dontKnow
//           ? 'Select fabric'
//           : fabric.label,
//       fabricHasSelection: fabric != FabricType.dontKnow,
//       onFabricTap: () => showModalBottomSheet(
//         context: context,
//         backgroundColor: Colors.transparent,
//         builder: (_) => ServiceCustomFabricSheet(
//           selected: fabric,
//           onSelect: (f) => ref.read(_exWFFabricProvider.notifier).state = f,
//         ),
//       ),
//       onAdd: () {
//         final name = controller.text.trim();
//         if (name.isNotEmpty) {
//           ref
//               .read(cartProvider.notifier)
//               .addCustom(
//                 name: name,
//                 serviceId: ref.read(_selectedServiceIdProvider) ?? 'wash_fold',
//                 quantity: qty,
//                 fabric: fabric,
//               );
//           controller.clear();
//           ref.read(_exWFQtyProvider.notifier).state = 1;
//           ref.read(_exWFFabricProvider.notifier).state = FabricType.dontKnow;
//         }
//       },
//     );
//   }
// }

// class _AddCustomIronCard extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final controller = ref.watch(_exIronControllerProvider);
//     final qty = ref.watch(_exIronQtyProvider);

//     return _CustomCardBase(
//       controller: controller,
//       qty: qty,
//       hintText: 'Item name (e.g. Dupatta, Blanket...)',
//       onDecrement: () => ref.read(_exIronQtyProvider.notifier).state--,
//       onIncrement: () => ref.read(_exIronQtyProvider.notifier).state++,
//       showFabric: false,
//       onAdd: () {
//         final name = controller.text.trim();
//         if (name.isNotEmpty) {
//           ref
//               .read(cartProvider.notifier)
//               .addCustom(name: name, serviceId: 'iron_only', quantity: qty);
//           controller.clear();
//           ref.read(_exIronQtyProvider.notifier).state = 1;
//         }
//       },
//     );
//   }
// }

// class _CustomCardBase extends StatelessWidget {
//   final TextEditingController controller;
//   final int qty;
//   final String hintText;
//   final VoidCallback onDecrement;
//   final VoidCallback onIncrement;
//   final VoidCallback onAdd;
//   final bool showFabric;
//   final String? fabricLabel;
//   final bool fabricHasSelection;
//   final VoidCallback? onFabricTap;

//   const _CustomCardBase({
//     required this.controller,
//     required this.qty,
//     required this.hintText,
//     required this.onDecrement,
//     required this.onIncrement,
//     required this.onAdd,
//     this.showFabric = true,
//     this.fabricLabel,
//     this.fabricHasSelection = false,
//     this.onFabricTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF141414),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.white.withValues(alpha: 0.1),
//           width: 1,
//         ),
//       ),
//       padding: const EdgeInsets.all(14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.add_circle_outline_rounded,
//                 color: AppColors.secondary,
//                 size: 20,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 'Add Custom Item',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.secondary,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Container(
//             height: 46,
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(alpha: 0.06),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: Colors.white.withValues(alpha: 0.1),
//                 width: 1,
//               ),
//             ),
//             child: TextField(
//               controller: controller,
//               style: const TextStyle(color: Colors.white, fontSize: 14),
//               decoration: InputDecoration(
//                 hintText: hintText,
//                 hintStyle: TextStyle(
//                   color: Colors.white.withValues(alpha: 0.3),
//                   fontSize: 13,
//                 ),
//                 prefixIcon: Icon(
//                   Icons.edit_rounded,
//                   size: 18,
//                   color: Colors.white.withValues(alpha: 0.3),
//                 ),
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 14,
//                   vertical: 14,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withValues(alpha: 0.05),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: Colors.white.withValues(alpha: 0.08),
//                     width: 1,
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     GestureDetector(
//                       onTap: qty > 1 ? onDecrement : null,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 12,
//                         ),
//                         child: Icon(
//                           Icons.remove,
//                           size: 16,
//                           color: Colors.white.withValues(
//                             alpha: qty > 1 ? 0.8 : 0.25,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Text(
//                       '$qty',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: onIncrement,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 12,
//                         ),
//                         child: Icon(
//                           Icons.add,
//                           size: 16,
//                           color: Colors.white.withValues(alpha: 0.8),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (showFabric) ...[
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: onFabricTap,
//                     child: Container(
//                       height: 46,
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withValues(alpha: 0.05),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: Colors.white.withValues(alpha: 0.08),
//                           width: 1,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.texture_rounded,
//                             size: 16,
//                             color: fabricHasSelection
//                                 ? AppColors.secondary
//                                 : Colors.white.withValues(alpha: 0.35),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               fabricLabel ?? 'Select fabric',
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: fabricHasSelection
//                                     ? AppColors.secondary
//                                     : Colors.white.withValues(alpha: 0.4),
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           Icon(
//                             Icons.keyboard_arrow_down_rounded,
//                             size: 16,
//                             color: Colors.white.withValues(alpha: 0.3),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ] else
//                 const Spacer(),
//               const SizedBox(width: 10),
//               GestureDetector(
//                 onTap: onAdd,
//                 child: Container(
//                   height: 46,
//                   width: 46,
//                   decoration: BoxDecoration(
//                     color: AppColors.secondary.withValues(alpha: 0.15),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: AppColors.secondary.withValues(alpha: 0.4),
//                       width: 1,
//                     ),
//                   ),
//                   child: Icon(
//                     Icons.check_rounded,
//                     color: AppColors.secondary,
//                     size: 22,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =====================================================================
// // LOCAL PROVIDERS
// // =====================================================================

// final _exWFControllerProvider = Provider.autoDispose<TextEditingController>((
//   ref,
// ) {
//   final c = TextEditingController();
//   ref.onDispose(() => c.dispose());
//   return c;
// });
// final _exWFQtyProvider = StateProvider.autoDispose<int>((ref) => 1);
// final _exWFFabricProvider = StateProvider.autoDispose<FabricType>(
//   (ref) => FabricType.dontKnow,
// );
// final _exIronControllerProvider = Provider.autoDispose<TextEditingController>((
//   ref,
// ) {
//   final c = TextEditingController();
//   ref.onDispose(() => c.dispose());
//   return c;
// });
// final _exIronQtyProvider = StateProvider.autoDispose<int>((ref) => 1);

// --------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:whirl_wash/features/home/presentation/providers/service_search_provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/fabric_type.dart';
import '../../../data/repositories/config_repository.dart';
import '../../providers/cart_provider.dart';
import '../../providers/config_providers.dart';
import '../../widgets/service_item_card.dart';
import '../../widgets/service_search_bar.dart';
import '../../widgets/service_bottom_bar.dart';
import '../../widgets/service_fabric_sheet.dart';

// =====================================================================
// LOCAL STATE PROVIDERS
// =====================================================================

// Stores selected service id (e.g. 'wash_fold')
final _selectedServiceIdProvider = StateProvider<String?>((ref) => null);

// Stores selected express time
final _selectedTimeProvider = StateProvider<ExpressTimeConfig?>((ref) => null);

// =====================================================================
// MAIN SCREEN
// =====================================================================

class ExpressScreen extends ConsumerWidget {
  const ExpressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(expressServicesConfigProvider);
    final timesAsync = ref.watch(expressTimesConfigProvider);
    final selectedServiceId = ref.watch(_selectedServiceIdProvider);
    final selectedTime = ref.watch(_selectedTimeProvider);

    // Auto-select first service and time when data loads
    ref.listen(expressServicesConfigProvider, (_, next) {
      next.whenData((services) {
        if (services.isNotEmpty &&
            ref.read(_selectedServiceIdProvider) == null) {
          ref.read(_selectedServiceIdProvider.notifier).state =
              services.first.id;
        }
      });
    });

    ref.listen(expressTimesConfigProvider, (_, next) {
      next.whenData((times) {
        if (times.isNotEmpty && ref.read(_selectedTimeProvider) == null) {
          ref.read(_selectedTimeProvider.notifier).state = times.first;
        }
      });
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // Service selector
          _ServiceSelector(
            servicesAsync: servicesAsync,
            selectedId: selectedServiceId,
          ),

          // Time selector
          _TimeSelector(timesAsync: timesAsync, selectedTime: selectedTime),

          // Surcharge banner
          if (selectedTime != null)
            _SurchargeBanner(surcharge: selectedTime.surcharge),

          // Item list
          if (selectedServiceId != null)
            Expanded(child: _ServiceItemList(serviceId: selectedServiceId))
          else
            const Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      ),
      bottomSheet: const ServiceBottomBar(accentColor: Colors.orange),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Express',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.orange.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: const Text(
              'FAST',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.orange,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// SERVICE SELECTOR — from Firestore
// =====================================================================

class _ServiceSelector extends ConsumerWidget {
  final AsyncValue<List<ServiceConfig>> servicesAsync;
  final String? selectedId;

  const _ServiceSelector({
    required this.servicesAsync,
    required this.selectedId,
  });

  static const Map<String, IconData> _iconMap = {
    'local_laundry_service': Icons.local_laundry_service_rounded,
    'iron': Icons.iron_rounded,
    'dry_cleaning': Icons.dry_cleaning_rounded,
    'checkroom': Icons.checkroom_rounded,
    'cleaning_services': Icons.cleaning_services_rounded,
    'flash_on': Icons.flash_on_rounded,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Service',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.5),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          servicesAsync.when(
            loading: () => const SizedBox(
              height: 60,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
            data: (services) => Row(
              children: services.asMap().entries.map((entry) {
                final index = entry.key;
                final service = entry.value;
                final isSelected = selectedId == service.id;
                final icon =
                    _iconMap[service.icon] ??
                    Icons.local_laundry_service_rounded;
                return Expanded(
                  child: Opacity(
                    opacity: service.enabled ? 1.0 : 0.4,
                    child: GestureDetector(
                      onTap: service.enabled
                          ? () =>
                                ref
                                    .read(_selectedServiceIdProvider.notifier)
                                    .state = service
                                    .id
                          : null,
                      child: Container(
                        margin: EdgeInsets.only(
                          right: index < services.length - 1 ? 8 : 0,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.orange.withValues(alpha: 0.15)
                              : const Color(0xFF141414),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.orange.withValues(alpha: 0.5)
                                : Colors.white.withValues(alpha: 0.08),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              icon,
                              size: 20,
                              color: isSelected
                                  ? Colors.orange
                                  : Colors.white.withValues(alpha: 0.6),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              service.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? Colors.orange
                                    : Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                            if (!service.enabled) ...[
                              const SizedBox(height: 2),
                              Text(
                                'Unavailable',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// TIME SELECTOR — from Firestore
// =====================================================================

class _TimeSelector extends ConsumerWidget {
  final AsyncValue<List<ExpressTimeConfig>> timesAsync;
  final ExpressTimeConfig? selectedTime;

  const _TimeSelector({required this.timesAsync, required this.selectedTime});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Turnaround Time',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.5),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          timesAsync.when(
            loading: () => const SizedBox(
              height: 60,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
            data: (times) => Row(
              children: times.asMap().entries.map((entry) {
                final index = entry.key;
                final time = entry.value;
                final isSelected = selectedTime?.id == time.id;
                return Expanded(
                  child: Opacity(
                    opacity: time.enabled ? 1.0 : 0.4,
                    child: GestureDetector(
                      onTap: time.enabled
                          ? () =>
                                ref.read(_selectedTimeProvider.notifier).state =
                                    time
                          : null,
                      child: Container(
                        margin: EdgeInsets.only(
                          right: index < times.length - 1 ? 8 : 0,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.orange.withValues(alpha: 0.15)
                              : const Color(0xFF141414),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.orange.withValues(alpha: 0.5)
                                : Colors.white.withValues(alpha: 0.08),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              time.label,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.orange
                                    : Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              time.sublabel,
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected
                                    ? Colors.orange.withValues(alpha: 0.7)
                                    : Colors.white.withValues(alpha: 0.35),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// SURCHARGE BANNER — surcharge is now int
// =====================================================================

class _SurchargeBanner extends StatelessWidget {
  final int surcharge;
  const _SurchargeBanner({required this.surcharge});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.bolt_rounded, size: 16, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$surcharge% express surcharge applies · Priced per kg',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange.withValues(alpha: 0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// ITEM LIST — based on selected service id
// =====================================================================

class _ServiceItemList extends ConsumerWidget {
  final String serviceId;
  const _ServiceItemList({required this.serviceId});

  bool get _isIronOnly => serviceId == 'iron_only';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsConfigProvider(serviceId));
    final searchProvider = _isIronOnly
        ? ironOnlySearchProvider
        : washFoldSearchProvider;
    final searchQuery = ref.watch(searchProvider);

    return Column(
      children: [
        ServiceSearchBar(searchProvider: searchProvider),
        Expanded(
          child: itemsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(
              child: Text(
                'Failed to load items',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            data: (items) {
              final filtered = items
                  .where(
                    (item) => item.name.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ),
                  )
                  .toList();

              if (_isIronOnly) {
                return _buildIronList(context, ref, filtered, searchQuery);
              } else {
                return _buildWashFoldList(
                  context,
                  ref,
                  filtered,
                  searchQuery,
                  serviceId,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWashFoldList(
    BuildContext context,
    WidgetRef ref,
    List<ItemConfig> filtered,
    String searchQuery,
    String serviceId,
  ) {
    final cartMap = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        ...filtered.map((item) {
          final entry = notifier.entryFor(item.id, serviceId);
          final cartEntry = cartMap['${serviceId}_${item.id}'];
          return ServiceItemCard(
            emoji: item.emoji,
            name: item.name,
            quantity: cartEntry?.quantity ?? 0,
            fabric: cartEntry?.fabric,
            onIncrement: () => notifier.increment(item.id, serviceId),
            onDecrement: () => notifier.decrement(item.id, serviceId),
            onFabricSelect: (f) => notifier.setFabric(item.id, serviceId, f),
          );
        }),
        ...cartMap.values
            .where((e) => e.serviceId == serviceId && e.isCustom)
            .map(
              (e) => ServiceItemCard(
                isCustom: true,
                emoji: '🧺',
                name: e.customName!,
                quantity: e.quantity,
                fabric: e.fabric,
                onIncrement: () => notifier.increment(e.itemId, serviceId),
                onDecrement: () => notifier.decrement(e.itemId, serviceId),
                onFabricSelect: (f) =>
                    notifier.setFabric(e.itemId, serviceId, f),
              ),
            ),
        _AddCustomWashFoldCard(),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildIronList(
    BuildContext context,
    WidgetRef ref,
    List<ItemConfig> filtered,
    String searchQuery,
  ) {
    final cartMap = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);
    const serviceId = 'iron_only';
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        ...filtered.map((item) {
          final cartEntry = cartMap['${serviceId}_${item.id}'];
          return ServiceItemCard(
            emoji: item.emoji,
            name: item.name,
            quantity: cartEntry?.quantity ?? 0,
            onIncrement: () => notifier.increment(item.id, serviceId),
            onDecrement: () => notifier.decrement(item.id, serviceId),
          );
        }),
        ...cartMap.values
            .where((e) => e.serviceId == serviceId && e.isCustom)
            .map(
              (e) => ServiceItemCard(
                isCustom: true,
                emoji: '🧺',
                name: e.customName!,
                quantity: e.quantity,
                onIncrement: () => notifier.increment(e.itemId, serviceId),
                onDecrement: () => notifier.decrement(e.itemId, serviceId),
              ),
            ),
        _AddCustomIronCard(),
        const SizedBox(height: 12),
      ],
    );
  }
}

// =====================================================================
// ADD CUSTOM CARDS
// =====================================================================

class _AddCustomWashFoldCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(_exWFControllerProvider);
    final qty = ref.watch(_exWFQtyProvider);
    final fabric = ref.watch(_exWFFabricProvider);

    return _CustomCardBase(
      controller: controller,
      qty: qty,
      hintText: 'Item name (e.g. Dupatta, Blanket...)',
      onDecrement: () => ref.read(_exWFQtyProvider.notifier).state--,
      onIncrement: () => ref.read(_exWFQtyProvider.notifier).state++,
      showFabric: true,
      fabricLabel: fabric == FabricType.dontKnow
          ? 'Select fabric'
          : fabric.label,
      fabricHasSelection: fabric != FabricType.dontKnow,
      onFabricTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => ServiceCustomFabricSheet(
          selected: fabric,
          onSelect: (f) => ref.read(_exWFFabricProvider.notifier).state = f,
        ),
      ),
      onAdd: () {
        final name = controller.text.trim();
        if (name.isNotEmpty) {
          ref
              .read(cartProvider.notifier)
              .addCustom(
                name: name,
                serviceId: ref.read(_selectedServiceIdProvider) ?? 'wash_fold',
                quantity: qty,
                fabric: fabric,
              );
          controller.clear();
          ref.read(_exWFQtyProvider.notifier).state = 1;
          ref.read(_exWFFabricProvider.notifier).state = FabricType.dontKnow;
        }
      },
    );
  }
}

class _AddCustomIronCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(_exIronControllerProvider);
    final qty = ref.watch(_exIronQtyProvider);

    return _CustomCardBase(
      controller: controller,
      qty: qty,
      hintText: 'Item name (e.g. Dupatta, Blanket...)',
      onDecrement: () => ref.read(_exIronQtyProvider.notifier).state--,
      onIncrement: () => ref.read(_exIronQtyProvider.notifier).state++,
      showFabric: false,
      onAdd: () {
        final name = controller.text.trim();
        if (name.isNotEmpty) {
          ref
              .read(cartProvider.notifier)
              .addCustom(name: name, serviceId: 'iron_only', quantity: qty);
          controller.clear();
          ref.read(_exIronQtyProvider.notifier).state = 1;
        }
      },
    );
  }
}

class _CustomCardBase extends StatelessWidget {
  final TextEditingController controller;
  final int qty;
  final String hintText;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onAdd;
  final bool showFabric;
  final String? fabricLabel;
  final bool fabricHasSelection;
  final VoidCallback? onFabricTap;

  const _CustomCardBase({
    required this.controller,
    required this.qty,
    required this.hintText,
    required this.onDecrement,
    required this.onIncrement,
    required this.onAdd,
    this.showFabric = true,
    this.fabricLabel,
    this.fabricHasSelection = false,
    this.onFabricTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                color: AppColors.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Add Custom Item',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 13,
                ),
                prefixIcon: Icon(
                  Icons.edit_rounded,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: qty > 1 ? onDecrement : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 16,
                          color: Colors.white.withValues(
                            alpha: qty > 1 ? 0.8 : 0.25,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '$qty',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: onIncrement,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        child: Icon(
                          Icons.add,
                          size: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (showFabric) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: onFabricTap,
                    child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.texture_rounded,
                            size: 16,
                            color: fabricHasSelection
                                ? AppColors.secondary
                                : Colors.white.withValues(alpha: 0.35),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              fabricLabel ?? 'Select fabric',
                              style: TextStyle(
                                fontSize: 13,
                                color: fabricHasSelection
                                    ? AppColors.secondary
                                    : Colors.white.withValues(alpha: 0.4),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else
                const Spacer(),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.secondary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// LOCAL PROVIDERS
// =====================================================================

final _exWFControllerProvider = Provider.autoDispose<TextEditingController>((
  ref,
) {
  final c = TextEditingController();
  ref.onDispose(() => c.dispose());
  return c;
});
final _exWFQtyProvider = StateProvider.autoDispose<int>((ref) => 1);
final _exWFFabricProvider = StateProvider.autoDispose<FabricType>(
  (ref) => FabricType.dontKnow,
);
final _exIronControllerProvider = Provider.autoDispose<TextEditingController>((
  ref,
) {
  final c = TextEditingController();
  ref.onDispose(() => c.dispose());
  return c;
});
final _exIronQtyProvider = StateProvider.autoDispose<int>((ref) => 1);
