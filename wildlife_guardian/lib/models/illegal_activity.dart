class IllegalActivity {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final IllegalActivityType type;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final ActivityStatus status;

  IllegalActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    this.status = ActivityStatus.pending,
  });

  // Sample data for demonstration purposes
  static List<IllegalActivity> getSampleData() {
    return [
      IllegalActivity(
        id: '1',
        title: 'Illegal Logging',
        description: 'Unauthorized logging activity detected in protected area. Trees being cut down with chainsaws.',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        type: IllegalActivityType.logging,
        latitude: 19.0841,
        longitude: 72.8989,
        imageUrl: 'https://cdn.pixabay.com/photo/2018/10/31/10/38/woods-3785607_1280.jpg',
        status: ActivityStatus.verified,
      ),
      IllegalActivity(
        id: '2',
        title: 'Poaching Attempt',
        description: 'Camera traps captured images of armed individuals in rhino habitat area after hours.',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        type: IllegalActivityType.poaching,
        latitude: 18.9220,
        longitude: 72.8347,
        imageUrl: 'https://images.pexels.com/photos/618902/pexels-photo-618902.jpeg',
        status: ActivityStatus.investigating,
      ),
      IllegalActivity(
        id: '3',
        title: 'Unauthorized Mining',
        description: 'Small-scale mining operation discovered near river bed. Environmental damage assessment needed.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: IllegalActivityType.mining,
        latitude: 19.2183,
        longitude: 72.9781,
        imageUrl: 'https://cdn.pixabay.com/photo/2015/09/03/06/59/strip-mining-920217_1280.jpg',
        status: ActivityStatus.pending,
      ),
      IllegalActivity(
        id: '4',
        title: 'Trespassing',
        description: 'Group of individuals entered restricted conservation zone without permits.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: IllegalActivityType.trespassing,
        latitude: 19.1754,
        longitude: 72.8491,
        imageUrl: 'https://images.pexels.com/photos/1462012/pexels-photo-1462012.jpeg',
        status: ActivityStatus.resolved,
      ),
      IllegalActivity(
        id: '5',
        title: 'Wildlife Trafficking',
        description: 'Suspicious vehicle stopped at checkpoint containing endangered species parts.',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        type: IllegalActivityType.trafficking,
        latitude: 19.0173,
        longitude: 72.8562,
        imageUrl: 'https://cdn.pixabay.com/photo/2016/11/21/15/09/trucks-1846064_1280.jpg',
        status: ActivityStatus.verified,
      ),
    ];
  }
}

enum IllegalActivityType {
  logging,
  poaching,
  mining,
  trespassing,
  trafficking,
  fishing,
  waste,
}

enum ActivityStatus {
  pending,
  investigating,
  verified,
  resolved,
  false_alarm,
} 