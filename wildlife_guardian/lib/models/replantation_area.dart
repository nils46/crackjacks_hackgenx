import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReplantationArea {
  final String id;
  final String name;
  final String description;
  final LatLng center;
  final double areaInSquareKm;
  final List<String> suggestedSpecies;
  final SoilType soilType;
  final double rainfallInMm;
  final int priorityScore;
  final bool isSelected;

  ReplantationArea({
    required this.id,
    required this.name,
    required this.description,
    required this.center,
    required this.areaInSquareKm,
    required this.suggestedSpecies,
    required this.soilType,
    required this.rainfallInMm,
    required this.priorityScore,
    this.isSelected = false,
  });

  // Sample data for demonstration purposes
  static List<ReplantationArea> getSampleData() {
    return [
      ReplantationArea(
        id: '1',
        name: 'Eastern Ridge Recovery Zone',
        description: 'Previously logged area with good soil quality. Suitable for mixed native species.',
        center: const LatLng(19.080, 72.897),
        areaInSquareKm: 3.7,
        suggestedSpecies: ['Teak', 'Sandalwood', 'Bamboo', 'Neem'],
        soilType: SoilType.loam,
        rainfallInMm: 1250.0,
        priorityScore: 9,
      ),
      ReplantationArea(
        id: '2',
        name: 'Northern Valley Restoration Area',
        description: 'Post-fire recovery zone. Soil needs rehabilitation before major replanting.',
        center: const LatLng(19.101, 72.878),
        areaInSquareKm: 2.1,
        suggestedSpecies: ['Acacia', 'Casuarina', 'Wild Grass', 'Bamboo'],
        soilType: SoilType.ash,
        rainfallInMm: 1100.0,
        priorityScore: 8,
      ),
      ReplantationArea(
        id: '3',
        name: 'Southern Corridor Expansion',
        description: 'Wildlife corridor expansion for improved habitat connectivity.',
        center: const LatLng(18.995, 72.858),
        areaInSquareKm: 2.8,
        suggestedSpecies: ['Banyan', 'Peepal', 'Jamun', 'Wild Mango'],
        soilType: SoilType.clay,
        rainfallInMm: 1400.0,
        priorityScore: 7,
      ),
      ReplantationArea(
        id: '4',
        name: 'Western Slope Stabilization',
        description: 'Hillside area requiring erosion control and stabilization planting.',
        center: const LatLng(19.045, 72.830),
        areaInSquareKm: 1.9,
        suggestedSpecies: ['Vetiver Grass', 'Bamboo', 'Sheesham', 'Local Shrubs'],
        soilType: SoilType.rocky,
        rainfallInMm: 950.0,
        priorityScore: 10,
      ),
      ReplantationArea(
        id: '5',
        name: 'Central Watershed Protection',
        description: 'Catchment area requiring reforestation to protect water sources.',
        center: const LatLng(19.058, 72.865),
        areaInSquareKm: 2.3,
        suggestedSpecies: ['Sal', 'Arjuna', 'Kadamba', 'Ficus Species'],
        soilType: SoilType.loam,
        rainfallInMm: 1350.0,
        priorityScore: 9,
      ),
    ];
  }
}

enum SoilType {
  sandy,
  clay,
  loam,
  silt,
  rocky,
  ash, // For post-fire areas
} 