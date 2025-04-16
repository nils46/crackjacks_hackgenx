class Alert {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final AlertType type;
  final double latitude;
  final double longitude;
  final bool isRead;

  Alert({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    required this.latitude,
    required this.longitude,
    this.isRead = false,
  });

  // Sample data for demonstration purposes
  static List<Alert> getSampleData() {
    return [
      Alert(
        id: '1',
        title: 'Illegal Logging Detected',
        description: 'Sensors detected chainsaw sounds near sector E4. Please investigate immediately.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        type: AlertType.illegal,
        latitude: 19.0841,
        longitude: 72.8989,
      ),
      Alert(
        id: '2',
        title: 'Tiger Movement',
        description: 'Bengal tiger spotted crossing into new territory in sector A2.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: AlertType.wildlife,
        latitude: 19.0760,
        longitude: 72.8777,
      ),
      Alert(
        id: '3',
        title: 'Forest Fire Alert',
        description: 'Small fire detected in sector C7. Fire department has been notified.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: AlertType.fire,
        latitude: 19.0748,
        longitude: 72.8856,
      ),
      Alert(
        id: '4',
        title: 'Poachers Detected',
        description: 'Suspicious movement detected in rhino sanctuary. Armed team dispatched.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: AlertType.illegal,
        latitude: 19.0522,
        longitude: 72.9005,
      ),
      Alert(
        id: '5',
        title: 'Sensor Maintenance Required',
        description: 'Sensor 47 in sector B3 has low battery. Replacement needed.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: AlertType.maintenance,
        latitude: 19.1023,
        longitude: 72.8568,
      ),
    ];
  }
}

enum AlertType {
  illegal,
  wildlife,
  fire,
  maintenance,
} 