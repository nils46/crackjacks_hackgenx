class UserProfile {
  final String id;
  final String name;
  final String designation;
  final String forestRegion;
  final String imageUrl;
  final String contactNumber;
  final String email;
  final List<String> responsibilities;
  final Map<String, bool> appSettings;

  UserProfile({
    required this.id,
    required this.name,
    required this.designation,
    required this.forestRegion,
    required this.imageUrl,
    required this.contactNumber,
    required this.email,
    required this.responsibilities,
    required this.appSettings,
  });

  // Default user for demonstration purposes
  static UserProfile defaultUser() {
    return UserProfile(
      id: '1',
      name: 'Rahul Singh',
      designation: 'Chief Forest Officer',
      forestRegion: 'Western Wildlife Sanctuary',
      imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
      contactNumber: '+91 9876543210',
      email: 'rahul.singh@forestdept.gov.in',
      responsibilities: [
        'Wildlife Monitoring',
        'Anti-Poaching Operations',
        'Conservation Planning',
        'Team Management',
      ],
      appSettings: {
        'darkMode': true,
        'notificationsEnabled': true,
        'locationSharing': true,
        'autoSyncData': true,
        'offlineMapAccess': true,
        'highResolutionImages': false,
      },
    );
  }

  // Create a copy with updated fields
  UserProfile copyWith({
    String? id,
    String? name,
    String? designation,
    String? forestRegion,
    String? imageUrl,
    String? contactNumber,
    String? email,
    List<String>? responsibilities,
    Map<String, bool>? appSettings,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      designation: designation ?? this.designation,
      forestRegion: forestRegion ?? this.forestRegion,
      imageUrl: imageUrl ?? this.imageUrl,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      responsibilities: responsibilities ?? this.responsibilities,
      appSettings: appSettings ?? this.appSettings,
    );
  }

  // Update a specific setting
  UserProfile updateSetting(String settingName, bool value) {
    final updatedSettings = Map<String, bool>.from(appSettings);
    updatedSettings[settingName] = value;
    return copyWith(appSettings: updatedSettings);
  }
} 