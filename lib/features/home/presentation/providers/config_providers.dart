import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whirl_wash/features/home/data/repositories/config_repository.dart';

// =====================================================================
// REPOSITORY PROVIDER
// =====================================================================

final configRepositoryProvider = Provider<ConfigRepository>((ref) {
  return ConfigRepository();
});

// =====================================================================
// FUTURE PROVIDERS
// =====================================================================

// All enabled services for home screen grid
final servicesConfigProvider = FutureProvider<List<ServiceConfig>>((ref) {
  return ref.watch(configRepositoryProvider).fetchServices();
});

// Items for a specific service
final itemsConfigProvider = FutureProvider.family<List<ItemConfig>, String>((
  ref,
  serviceId,
) {
  return ref.watch(configRepositoryProvider).fetchItems(serviceId);
});

// Services with expressEnabled: true — for express screen chips
final expressServicesConfigProvider = FutureProvider<List<ServiceConfig>>((
  ref,
) {
  return ref.watch(configRepositoryProvider).fetchExpressServices();
});

// Express time chips
final expressTimesConfigProvider = FutureProvider<List<ExpressTimeConfig>>((
  ref,
) {
  return ref.watch(configRepositoryProvider).fetchExpressTimes();
});

// Single service — for ratePerKg in cart/estimator
final serviceConfigProvider = FutureProvider.family<ServiceConfig?, String>((
  ref,
  serviceId,
) {
  return ref.watch(configRepositoryProvider).fetchService(serviceId);
});
