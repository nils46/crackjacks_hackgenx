class Wildlife {
  final String id;
  final String name;
  final String species;
  final String imageUrl;
  final DateTime detectionTime;
  final double latitude;
  final double longitude;
  final String status;

  Wildlife({
    required this.id,
    required this.name,
    required this.species,
    required this.imageUrl,
    required this.detectionTime,
    required this.latitude,
    required this.longitude,
    this.status = 'Detected',
  });

  // Sample data for demonstration purposes
  static List<Wildlife> getSampleData() {
    return [
      Wildlife(
        id: '1',
        name: 'Bengal Tiger',
        species: 'Panthera tigris tigris',
        imageUrl: 'https://images.unsplash.com/photo-1561731216-c3a4d99437d5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8&w=1000&q=80',
        detectionTime: DateTime.now().subtract(const Duration(hours: 2)),
        latitude: 19.0760,
        longitude: 72.8777,
      ),
      Wildlife(
        id: '2',
        name: 'Indian Elephant',
        species: 'Elephas maximus indicus',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/9/98/Elephas_maximus_%28Bandipur%29.jpg',
        detectionTime: DateTime.now().subtract(const Duration(hours: 5)),
        latitude: 12.9716,
        longitude: 77.5946,
      ),
      Wildlife(
        id: '3',
        name: 'Indian Rhinoceros',
        species: 'Rhinoceros unicornis',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Indian_Rhinoceros_in_Kaziranga.jpg/1200px-Indian_Rhinoceros_in_Kaziranga.jpg',
        detectionTime: DateTime.now().subtract(const Duration(days: 1)),
        latitude: 26.7505,
        longitude: 94.2125,
      ),
      Wildlife(
        id: '4',
        name: 'Asiatic Lion',
        species: 'Panthera leo persica',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/Asiatic_Lion_Male_in_Gir_Forest.jpg/1200px-Asiatic_Lion_Male_in_Gir_Forest.jpg',
        detectionTime: DateTime.now().subtract(const Duration(hours: 8)),
        latitude: 21.1702,
        longitude: 72.8311,
      ),
      Wildlife(
        id: '5',
        name: 'Indian Leopard',
        species: 'Panthera pardus fusca',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Indian_leopard_in_Sariska_Tiger_Reserve.jpg/1200px-Indian_leopard_in_Sariska_Tiger_Reserve.jpg',
        detectionTime: DateTime.now().subtract(const Duration(hours: 12)),
        latitude: 18.5204,
        longitude: 73.8567,
      ),
    ];
  }
} 