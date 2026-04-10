// import 'dart:convert';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:whirl_wash/core/constants/app_colors.dart';
// import 'package:whirl_wash/features/auth/presentation/providers/complete_profile_screen_providers.dart';

// class AddressSection extends ConsumerStatefulWidget {
//   final CompleteProfileTextControllers controllers;

//   const AddressSection({super.key, required this.controllers});

//   @override
//   ConsumerState<AddressSection> createState() => _AddressSectionState();
// }

// class _AddressSectionState extends ConsumerState<AddressSection> {
//   GoogleMapController? _mapController;
//   final FocusNode _addressFocusNode = FocusNode();
//   Timer? _debounce;
//   List<Map<String, dynamic>> _suggestions = [];
//   bool _showSuggestions = false;
//   bool _isSearching = false;
//   bool _isSelectingSuggestion = false;

//   static const LatLng _defaultLocation = LatLng(11.2588, 75.7804);

//   @override
//   void initState() {
//     super.initState();
//     widget.controllers.address.addListener(_onAddressChanged);
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     _addressFocusNode.dispose();
//     widget.controllers.address.removeListener(_onAddressChanged);
//     _mapController?.dispose();
//     super.dispose();
//   }

//   void _onAddressChanged() {
//     if (_isSelectingSuggestion) return;
//     final text = widget.controllers.address.text;
//     if (text.trim().isEmpty) {
//       setState(() {
//         _suggestions = [];
//         _showSuggestions = false;
//       });
//       return;
//     }
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       _fetchSuggestions(text);
//     });
//   }

//   Future<void> _fetchSuggestions(String input) async {
//     if (input.trim().length < 3) return;
//     setState(() => _isSearching = true);
//     try {
//       final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
//       final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json'
//         '?input=${Uri.encodeComponent(input)}'
//         '&components=country:in'
//         '&key=$apiKey',
//       );
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 'OK') {
//           final predictions = (data['predictions'] as List).map((p) {
//             return {
//               'description': p['description'] as String,
//               'placeId': p['place_id'] as String,
//             };
//           }).toList();
//           setState(() {
//             _suggestions = predictions;
//             _showSuggestions = predictions.isNotEmpty;
//           });
//         } else {
//           setState(() {
//             _suggestions = [];
//             _showSuggestions = false;
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint('Places API error: $e');
//     } finally {
//       setState(() => _isSearching = false);
//     }
//   }

//   Future<void> _selectSuggestion(Map<String, dynamic> suggestion) async {
//     final description = suggestion['description'] as String;
//     final placeId = suggestion['placeId'] as String;

//     _isSelectingSuggestion = true;
//     _debounce?.cancel();

//     widget.controllers.address.text = description;
//     widget.controllers.address.selection = TextSelection.fromPosition(
//       TextPosition(offset: description.length),
//     );

//     setState(() {
//       _suggestions = [];
//       _showSuggestions = false;
//     });

//     _addressFocusNode.unfocus();

//     Future.delayed(const Duration(milliseconds: 100), () {
//       _isSelectingSuggestion = false;
//     });

//     try {
//       final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
//       final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/place/details/json'
//         '?place_id=$placeId'
//         '&fields=geometry'
//         '&key=$apiKey',
//       );
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 'OK') {
//           final loc = data['result']['geometry']['location'];
//           final lat = (loc['lat'] as num).toDouble();
//           final lng = (loc['lng'] as num).toDouble();
//           final latLng = LatLng(lat, lng);
//           ref.read(completeProfileLocationProvider.notifier).state = latLng;
//           _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
//         }
//       }
//     } catch (e) {
//       debugPrint('Place details error: $e');
//     }
//   }

//   Future<void> _useCurrentLocation() async {
//     try {
//       final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) return;

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) return;
//       }
//       if (permission == LocationPermission.deniedForever) return;

//       final position = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//         ),
//       );

//       final latLng = LatLng(position.latitude, position.longitude);
//       final placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         final p = placemarks.first;
//         final address = [
//           p.subLocality,
//           p.locality,
//           p.administrativeArea,
//           p.postalCode,
//         ].where((e) => e != null && e.isNotEmpty).join(', ');
//         widget.controllers.address.text = address;
//       }

//       ref.read(completeProfileLocationProvider.notifier).state = latLng;
//       _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
//     } catch (e) {
//       debugPrint('Current location error: $e');
//     }
//   }

//   Future<void> _onMapTap(LatLng latLng) async {
//     ref.read(completeProfileLocationProvider.notifier).state = latLng;
//     try {
//       final placemarks = await placemarkFromCoordinates(
//         latLng.latitude,
//         latLng.longitude,
//       );
//       if (placemarks.isNotEmpty) {
//         final p = placemarks.first;
//         final address = [
//           p.subLocality,
//           p.locality,
//           p.administrativeArea,
//           p.postalCode,
//         ].where((e) => e != null && e.isNotEmpty).join(', ');
//         widget.controllers.address.text = address;
//       }
//     } catch (e) {
//       debugPrint('Reverse geocode error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final location = ref.watch(completeProfileLocationProvider);
//     final pinLocation = location ?? _defaultLocation;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ── Header ─────────────────────────────────────────────────
//         Row(
//           children: [
//             Icon(
//               Icons.location_on_rounded,
//               color: AppColors.secondary,
//               size: 18,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               'Delivery Address',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textSecondary,
//                 letterSpacing: 0.3,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),

//         // ── Search Field ────────────────────────────────────────────
//         Container(
//           decoration: BoxDecoration(
//             color: AppColors.glassBackground,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: AppColors.glassBorder, width: 1),
//           ),
//           child: TextField(
//             controller: widget.controllers.address,
//             focusNode: _addressFocusNode,
//             keyboardType: TextInputType.streetAddress,
//             textInputAction: TextInputAction.search,
//             style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
//             decoration: InputDecoration(
//               hintText: 'Search area / street...',
//               hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13),
//               prefixIcon: Icon(
//                 Icons.search_rounded,
//                 color: AppColors.iconPrimary,
//                 size: 20,
//               ),
//               suffixIcon: _isSearching
//                   ? Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: SizedBox(
//                         width: 16,
//                         height: 16,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: AppColors.secondary,
//                         ),
//                       ),
//                     )
//                   : widget.controllers.address.text.isNotEmpty
//                   ? IconButton(
//                       icon: Icon(
//                         Icons.clear,
//                         color: AppColors.textDisabled,
//                         size: 18,
//                       ),
//                       onPressed: () {
//                         widget.controllers.address.clear();
//                         setState(() {
//                           _suggestions = [];
//                           _showSuggestions = false;
//                         });
//                       },
//                     )
//                   : null,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide.none,
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide.none,
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: AppColors.focusedBorder,
//                   width: 2,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 14,
//               ),
//             ),
//           ),
//         ),

//         // ── Suggestions Dropdown ────────────────────────────────────
//         if (_showSuggestions && _suggestions.isNotEmpty)
//           Container(
//             margin: const EdgeInsets.only(top: 4),
//             decoration: BoxDecoration(
//               color: const Color(0xFF1A1A1A),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.3),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: _suggestions.asMap().entries.map((entry) {
//                 final index = entry.key;
//                 final suggestion = entry.value;
//                 final isLast = index == _suggestions.length - 1;
//                 return Column(
//                   children: [
//                     InkWell(
//                       onTap: () => _selectSuggestion(suggestion),
//                       borderRadius: BorderRadius.circular(12),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 12,
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.location_on_outlined,
//                               color: AppColors.secondary,
//                               size: 16,
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Text(
//                                 suggestion['description'] as String,
//                                 style: const TextStyle(
//                                   fontSize: 13,
//                                   color: AppColors.textPrimary,
//                                 ),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     if (!isLast)
//                       Divider(
//                         height: 1,
//                         color: Colors.white.withValues(alpha: 0.06),
//                         indent: 16,
//                         endIndent: 16,
//                       ),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),

//         const SizedBox(height: 12),

//         // ── Google Map ──────────────────────────────────────────────
//         ClipRRect(
//           borderRadius: BorderRadius.circular(14),
//           child: SizedBox(
//             height: 200,
//             width: double.infinity,
//             child: GoogleMap(
//               initialCameraPosition: const CameraPosition(
//                 target: _defaultLocation,
//                 zoom: 14,
//               ),
//               onMapCreated: (controller) => _mapController = controller,
//               onTap: _onMapTap,
//               markers: {
//                 Marker(
//                   markerId: const MarkerId('selected'),
//                   position: pinLocation,
//                   draggable: true,
//                   onDragEnd: _onMapTap,
//                 ),
//               },
//               myLocationButtonEnabled: false,
//               zoomControlsEnabled: false,
//               mapToolbarEnabled: false,
//             ),
//           ),
//         ),

//         const SizedBox(height: 10),

//         // ── Use Current Location ────────────────────────────────────
//         GestureDetector(
//           onTap: _useCurrentLocation,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             decoration: BoxDecoration(
//               color: AppColors.secondary.withValues(alpha: 0.1),
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                 color: AppColors.secondary.withValues(alpha: 0.3),
//               ),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.my_location_rounded,
//                   color: AppColors.secondary,
//                   size: 16,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Use My Current Location',
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: AppColors.secondary,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         const SizedBox(height: 16),

//         // ── House Name ──────────────────────────────────────────────
//         Text(
//           'House Name / Flat No',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: AppColors.textSecondary,
//             letterSpacing: 0.3,
//           ),
//         ),
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(
//             color: AppColors.glassBackground,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: AppColors.glassBorder, width: 1),
//           ),
//           child: TextField(
//             controller: widget.controllers.houseName,
//             keyboardType: TextInputType.text,
//             textInputAction: TextInputAction.done,
//             style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
//             decoration: InputDecoration(
//               hintText: 'e.g. Mango Villa, 2nd floor',
//               hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13),
//               prefixIcon: Icon(
//                 Icons.home_outlined,
//                 color: AppColors.iconPrimary,
//                 size: 20,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide.none,
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide.none,
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: AppColors.focusedBorder,
//                   width: 2,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 14,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// -----------------------------------After Edit profile------------------------------------
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';
import 'package:whirl_wash/features/auth/presentation/providers/complete_profile_screen_providers.dart';

class AddressSection extends ConsumerStatefulWidget {
  final CompleteProfileTextControllers controllers;
  final StateProvider<LatLng?> locationProvider;

  const AddressSection({
    super.key,
    required this.controllers,
    required this.locationProvider,
  });

  @override
  ConsumerState<AddressSection> createState() => _AddressSectionState();
}

class _AddressSectionState extends ConsumerState<AddressSection> {
  GoogleMapController? _mapController;
  final FocusNode _addressFocusNode = FocusNode();
  Timer? _debounce;
  List<Map<String, dynamic>> _suggestions = [];
  bool _showSuggestions = false;
  bool _isSearching = false;
  bool _isSelectingSuggestion = false;

  static const LatLng _defaultLocation = LatLng(11.2588, 75.7804);

  @override
  void initState() {
    super.initState();
    widget.controllers.address.addListener(_onAddressChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _addressFocusNode.dispose();
    widget.controllers.address.removeListener(_onAddressChanged);
    _mapController?.dispose();
    super.dispose();
  }

  void _onAddressChanged() {
    if (_isSelectingSuggestion) return;
    final text = widget.controllers.address.text;
    if (text.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchSuggestions(text);
    });
  }

  Future<void> _fetchSuggestions(String input) async {
    if (input.trim().length < 3) return;
    setState(() => _isSearching = true);
    try {
      final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=${Uri.encodeComponent(input)}'
        '&components=country:in'
        '&key=$apiKey',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final predictions = (data['predictions'] as List).map((p) {
            return {
              'description': p['description'] as String,
              'placeId': p['place_id'] as String,
            };
          }).toList();
          setState(() {
            _suggestions = predictions;
            _showSuggestions = predictions.isNotEmpty;
          });
        } else {
          setState(() {
            _suggestions = [];
            _showSuggestions = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Places API error: $e');
    } finally {
      setState(() => _isSearching = false);
    }
  }

  Future<void> _selectSuggestion(Map<String, dynamic> suggestion) async {
    final description = suggestion['description'] as String;
    final placeId = suggestion['placeId'] as String;

    _isSelectingSuggestion = true;
    _debounce?.cancel();

    widget.controllers.address.text = description;
    widget.controllers.address.selection = TextSelection.fromPosition(
      TextPosition(offset: description.length),
    );

    setState(() {
      _suggestions = [];
      _showSuggestions = false;
    });

    _addressFocusNode.unfocus();

    Future.delayed(const Duration(milliseconds: 100), () {
      _isSelectingSuggestion = false;
    });

    try {
      final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeId'
        '&fields=geometry'
        '&key=$apiKey',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final loc = data['result']['geometry']['location'];
          final lat = (loc['lat'] as num).toDouble();
          final lng = (loc['lng'] as num).toDouble();
          final latLng = LatLng(lat, lng);
          ref.read(widget.locationProvider.notifier).state = latLng;
          _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
        }
      }
    } catch (e) {
      debugPrint('Place details error: $e');
    }
  }

  Future<void> _useCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final latLng = LatLng(position.latitude, position.longitude);
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final address = [
          p.subLocality,
          p.locality,
          p.administrativeArea,
          p.postalCode,
        ].where((e) => e != null && e.isNotEmpty).join(', ');
        widget.controllers.address.text = address;
      }

      ref.read(widget.locationProvider.notifier).state = latLng;
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
    } catch (e) {
      debugPrint('Current location error: $e');
    }
  }

  Future<void> _onMapTap(LatLng latLng) async {
    ref.read(widget.locationProvider.notifier).state = latLng;
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final address = [
          p.subLocality,
          p.locality,
          p.administrativeArea,
          p.postalCode,
        ].where((e) => e != null && e.isNotEmpty).join(', ');
        widget.controllers.address.text = address;
      }
    } catch (e) {
      debugPrint('Reverse geocode error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(widget.locationProvider);
    final pinLocation = location ?? _defaultLocation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ─────────────────────────────────────────────────
        Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              color: AppColors.secondary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Delivery Address',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── Search Field ────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
          child: TextField(
            controller: widget.controllers.address,
            focusNode: _addressFocusNode,
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.search,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search area / street...',
              hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.iconPrimary,
                size: 20,
              ),
              suffixIcon: _isSearching
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.secondary,
                        ),
                      ),
                    )
                  : widget.controllers.address.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: AppColors.textDisabled,
                        size: 18,
                      ),
                      onPressed: () {
                        widget.controllers.address.clear();
                        setState(() {
                          _suggestions = [];
                          _showSuggestions = false;
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: AppColors.focusedBorder,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),

        // ── Suggestions Dropdown ────────────────────────────────────
        if (_showSuggestions && _suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: _suggestions.asMap().entries.map((entry) {
                final index = entry.key;
                final suggestion = entry.value;
                final isLast = index == _suggestions.length - 1;
                return Column(
                  children: [
                    InkWell(
                      onTap: () => _selectSuggestion(suggestion),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: AppColors.secondary,
                              size: 16,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                suggestion['description'] as String,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.06),
                        indent: 16,
                        endIndent: 16,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),

        const SizedBox(height: 12),

        // ── Google Map ──────────────────────────────────────────────
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: _defaultLocation,
                zoom: 14,
              ),
              onMapCreated: (controller) => _mapController = controller,
              onTap: _onMapTap,
              markers: {
                Marker(
                  markerId: const MarkerId('selected'),
                  position: pinLocation,
                  draggable: true,
                  onDragEnd: _onMapTap,
                ),
              },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // ── Use Current Location ────────────────────────────────────
        GestureDetector(
          onTap: _useCurrentLocation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.my_location_rounded,
                  color: AppColors.secondary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Use My Current Location',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ── House Name ──────────────────────────────────────────────
        Text(
          'House Name / Flat No',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
          child: TextField(
            controller: widget.controllers.houseName,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'e.g. Mango Villa, 2nd floor',
              hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13),
              prefixIcon: Icon(
                Icons.home_outlined,
                color: AppColors.iconPrimary,
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: AppColors.focusedBorder,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
