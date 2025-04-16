import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeforestedArea {
  final String id;
  final String name;
  final String description;
  final DateTime reportDate;
  final List<LatLng> boundaries;
  final double areaInSquareKm;
  final DeforestationCause cause;
  final bool needsReplantation;
  final ReforestationStatus status;

  DeforestedArea({
    required this.id,
    required this.name,
    required this.description,
    required this.reportDate,
    required this.boundaries,
    required this.areaInSquareKm,
    required this.cause,
    required this.needsReplantation,
    this.status = ReforestationStatus.notStarted,
  });

  // Sample data for demonstration purposes
  static List<DeforestedArea> getSampleData() {
    return [
      DeforestedArea(
        id: '1',
        name: 'Eastern Ridge Clearing',
        description: 'Large area affected by illegal logging operations. Discovered during aerial survey.',
        reportDate: DateTime.now().subtract(const Duration(days: 45)),
        boundaries: [
          const LatLng(19.085, 72.891),
          const LatLng(19.087, 72.901),
          const LatLng(19.075, 72.903),
          const LatLng(19.072, 72.893),
        ],
        areaInSquareKm: 3.7,
        cause: DeforestationCause.logging,
        needsReplantation: true,
        status: ReforestationStatus.inProgress,
      ),
      DeforestedArea(
        id: '2',
        name: 'Northern Valley Fire Zone',
        description: 'Area damaged by forest fire last dry season. Native vegetation completely lost.',
        reportDate: DateTime.now().subtract(const Duration(days: 90)),
        boundaries: [
          const LatLng(19.103, 72.867),
          const LatLng(19.108, 72.879),
          const LatLng(19.099, 72.888),
          const LatLng(19.094, 72.877),
        ],
        areaInSquareKm: 2.1,
        cause: DeforestationCause.fire,
        needsReplantation: true,
        status: ReforestationStatus.planned,
      ),
      DeforestedArea(
        id: '3',
        name: 'Western Mining Expansion',
        description: 'Cleared for illegal mining operations. Heavy machinery tracks visible. Soil heavily contaminated.',
        reportDate: DateTime.now().subtract(const Duration(days: 120)),
        boundaries: [
          const LatLng(19.042, 72.821),
          const LatLng(19.048, 72.830),
          const LatLng(19.043, 72.836),
          const LatLng(19.037, 72.826),
        ],
        areaInSquareKm: 1.5,
        cause: DeforestationCause.mining,
        needsReplantation: false,
        status: ReforestationStatus.notSuitable,
      ),
      DeforestedArea(
        id: '4',
        name: 'Southern Agricultural Encroachment',
        description: 'Forest cleared for agricultural use. Illegal farm plots established.',
        reportDate: DateTime.now().subtract(const Duration(days: 180)),
        boundaries: [
          const LatLng(18.997, 72.848),
          const LatLng(19.002, 72.861),
          const LatLng(18.992, 72.867),
          const LatLng(18.987, 72.855),
        ],
        areaInSquareKm: 2.8,
        cause: DeforestationCause.agriculture,
        needsReplantation: true,
        status: ReforestationStatus.notStarted,
      ),
      DeforestedArea(
        id: '5',
        name: 'Central Road Expansion',
        description: 'Cleared for unauthorized road construction through protected area.',
        reportDate: DateTime.now().subtract(const Duration(days: 220)),
        boundaries: [
          const LatLng(19.061, 72.855),
          const LatLng(19.067, 72.863),
          const LatLng(19.051, 72.875),
          const LatLng(19.045, 72.866),
        ],
        areaInSquareKm: 1.8,
        cause: DeforestationCause.development,
        needsReplantation: true,
        status: ReforestationStatus.completed,
      ),
    ];
  }
}

enum DeforestationCause {
  logging,
  fire,
  mining,
  agriculture,
  development,
  natural,
}

enum ReforestationStatus {
  notStarted,
  planned,
  inProgress,
  completed,
  notSuitable,
} 