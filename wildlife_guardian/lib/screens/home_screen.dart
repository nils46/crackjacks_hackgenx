import 'package:flutter/material.dart';
import 'package:wildlife_guardian/theme/app_theme.dart';
import 'package:wildlife_guardian/widgets/custom_card.dart';
import 'package:wildlife_guardian/models/wildlife.dart';
import 'package:wildlife_guardian/models/alert.dart';
import 'package:wildlife_guardian/models/news.dart';
import 'package:wildlife_guardian/models/illegal_activity.dart';
import 'package:wildlife_guardian/widgets/offline_map.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const DashboardTab(),
    const MapTab(),
    const ActivityLogTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.secondaryDark,
        selectedItemColor: AppTheme.accentGreen,
        unselectedItemColor: AppTheme.textMuted,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get sample data
    final recentWildlife = Wildlife.getSampleData().take(3).toList();
    final recentAlerts = Alert.getSampleData().take(3).toList();
    final recentNews = ForestNews.getSampleData().take(3).toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: false,
              snap: true,
              backgroundColor: AppTheme.primaryDark,
              elevation: 0,
              title: const Row(
                children: [
                  Icon(
                    Icons.eco,
                    color: AppTheme.accentGreen,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Wildlife Guardian',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: AppTheme.textSecondary),
                  onPressed: () {
                    Navigator.pushNamed(context, '/alerts');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: AppTheme.textSecondary),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Access',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.4,
                      children: [
                        _buildQuickAccessCard(
                          context,
                          'Alerts',
                          'View recent alerts',
                          Icons.notifications_active,
                          AppTheme.accentOrange,
                          () {
                            Navigator.pushNamed(context, '/alerts');
                          },
                        ),
                        _buildQuickAccessCard(
                          context,
                          'Wildlife',
                          'Track animal sightings',
                          Icons.pets,
                          AppTheme.accentGreen,
                          () {
                            Navigator.pushNamed(context, '/wildlife');
                          },
                        ),
                        _buildQuickAccessCard(
                          context,
                          'Target Spots',
                          'Navigate to locations',
                          Icons.location_on,
                          AppTheme.accentBlue,
                          () {
                            Navigator.pushNamed(context, '/target_spot');
                          },
                        ),
                        _buildQuickAccessCard(
                          context,
                          'News',
                          'Latest forest updates',
                          Icons.article,
                          Colors.purple,
                          () {
                            Navigator.pushNamed(context, '/news');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Recent Wildlife',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: recentWildlife.length,
                        itemBuilder: (context, index) {
                          final wildlife = recentWildlife[index];
                          return _buildWildlifeCard(context, wildlife);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Alerts',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/alerts');
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...recentAlerts.map((alert) => _buildAlertCard(context, alert)).toList(),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Forest News',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/news');
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...recentNews.map((news) => _buildNewsCard(context, news)).toList(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GradientBorderCard(
      gradientStart: color,
      gradientEnd: color.withOpacity(0.7),
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            color: color,
            size: 30,
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWildlifeCard(BuildContext context, Wildlife wildlife) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      child: CustomCard(
        onTap: () {
          Navigator.pushNamed(context, '/wildlife');
        },
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                wildlife.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wildlife.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    wildlife.species,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppTheme.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${wildlife.detectionTime.hour}:${wildlife.detectionTime.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, Alert alert) {
    Color alertColor;
    IconData alertIcon;

    switch (alert.type) {
      case AlertType.illegal:
        alertColor = Colors.red;
        alertIcon = Icons.warning;
        break;
      case AlertType.wildlife:
        alertColor = AppTheme.accentGreen;
        alertIcon = Icons.pets;
        break;
      case AlertType.fire:
        alertColor = Colors.orange;
        alertIcon = Icons.local_fire_department;
        break;
      case AlertType.maintenance:
        alertColor = Colors.blue;
        alertIcon = Icons.build;
        break;
    }

    return StatusCard(
      title: alert.title,
      subtitle: alert.description,
      icon: alertIcon,
      iconColor: alertColor,
      onTap: () {
        Navigator.pushNamed(context, '/alerts');
      },
    );
  }

  Widget _buildNewsCard(BuildContext context, ForestNews news) {
    return CustomCard(
      onTap: () {
        Navigator.pushNamed(context, '/news');
      },
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              news.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  news.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        news.category.name,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.accentGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: AppTheme.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${news.publishDate.day}/${news.publishDate.month}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MapTab extends StatefulWidget {
  const MapTab({Key? key}) : super(key: key);

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showFilterPanel = false;
  bool _showWildlifeMarkers = true;
  bool _showAlertMarkers = true;
  bool _showIllegalActivityMarkers = true;
  bool _showTargetSpotMarkers = true;
  bool _isOfflineMode = false;
  
  // Sample coordinates near a forest area
  final LatLng _initialPosition = const LatLng(12.4244, 75.7395); // Western Ghats, India
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wildlife Map'),
        backgroundColor: AppTheme.primaryDark,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isOfflineMode ? Icons.wifi_off : Icons.wifi,
              color: _isOfflineMode ? AppTheme.accentOrange : AppTheme.textSecondary,
            ),
            tooltip: _isOfflineMode ? 'Switch to Online Mode' : 'Switch to Offline Mode',
            onPressed: _toggleOfflineMode,
          ),
          IconButton(
            icon: Icon(
              _showFilterPanel ? Icons.filter_list_off : Icons.filter_list,
              color: _showFilterPanel ? AppTheme.accentGreen : AppTheme.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _showFilterPanel = !_showFilterPanel;
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Map View'),
            Tab(text: 'List View'),
          ],
          indicatorColor: AppTheme.accentGreen,
          labelColor: AppTheme.accentGreen,
          unselectedLabelColor: AppTheme.textSecondary,
        ),
      ),
      body: Column(
        children: [
          if (_showFilterPanel) _buildFilterPanel(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMapView(),
                _buildListView(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show bottom sheet with options to add different types of markers
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) => _buildAddMarkersSheet(),
          );
        },
        backgroundColor: AppTheme.accentGreen,
        child: const Icon(Icons.add_location_alt),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: AppTheme.secondaryDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Map Markers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFilterChip(
                  label: 'Wildlife',
                  icon: Icons.pets,
                  color: AppTheme.accentGreen,
                  selected: _showWildlifeMarkers,
                  onSelected: (value) {
                    setState(() {
                      _showWildlifeMarkers = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterChip(
                  label: 'Alerts',
                  icon: Icons.notification_important,
                  color: AppTheme.accentOrange,
                  selected: _showAlertMarkers,
                  onSelected: (value) {
                    setState(() {
                      _showAlertMarkers = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildFilterChip(
                  label: 'Illegal Activities',
                  icon: Icons.warning,
                  color: AppTheme.warningRed,
                  selected: _showIllegalActivityMarkers,
                  onSelected: (value) {
                    setState(() {
                      _showIllegalActivityMarkers = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterChip(
                  label: 'Target Spots',
                  icon: Icons.location_on,
                  color: AppTheme.accentBlue,
                  selected: _showTargetSpotMarkers,
                  onSelected: (value) {
                    setState(() {
                      _showTargetSpotMarkers = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required Color color,
    required bool selected,
    required Function(bool) onSelected,
  }) {
    return GestureDetector(
      onTap: () => onSelected(!selected),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.1) : AppTheme.tertiaryDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color : AppTheme.tertiaryDark,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? color : AppTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: selected ? color : AppTheme.textSecondary,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    // Gather all markers based on filters
    final markers = <MapMarker>[];
    
    // Mock data for demonstration purposes
    if (_showWildlifeMarkers) {
      markers.addAll([
        MapMarker(
          position: LatLng(12.4244, 75.7395),
          icon: Icons.pets,
          color: AppTheme.accentGreen,
          label: 'Tiger',
          onTap: () => _showMarkerDetails('Tiger', 'Wildlife sighting', Icons.pets, AppTheme.accentGreen),
        ),
        MapMarker(
          position: LatLng(12.4354, 75.7455),
          icon: Icons.pets,
          color: AppTheme.accentGreen,
          label: 'Elephant',
          onTap: () => _showMarkerDetails('Elephant', 'Wildlife sighting', Icons.pets, AppTheme.accentGreen),
        ),
      ]);
    }
    
    if (_showAlertMarkers) {
      markers.addAll([
        MapMarker(
          position: LatLng(12.4184, 75.7445),
          icon: Icons.notification_important,
          color: AppTheme.accentOrange,
          label: 'Alert',
          onTap: () => _showMarkerDetails('Forest Fire', 'Critical alert', Icons.local_fire_department, AppTheme.accentOrange),
        ),
      ]);
    }
    
    if (_showIllegalActivityMarkers) {
      markers.addAll([
        MapMarker(
          position: LatLng(12.4284, 75.7485),
          icon: Icons.warning,
          color: AppTheme.warningRed,
          label: 'Illegal',
          onTap: () => _showMarkerDetails('Illegal Logging', 'Reported activity', Icons.forest, AppTheme.warningRed),
        ),
      ]);
    }
    
    if (_showTargetSpotMarkers) {
      markers.addAll([
        MapMarker(
          position: LatLng(12.4224, 75.7355),
          icon: Icons.location_on,
          color: AppTheme.accentBlue,
          label: 'Target',
          onTap: () => _showMarkerDetails('Patrol Point', 'Target spot', Icons.location_on, AppTheme.accentBlue),
        ),
      ]);
    }
    
    return OfflineMapWidget(
      initialPosition: _initialPosition,
      initialZoom: 13.0,
      markers: markers,
      onTap: (position) {
        print('Tapped on map at $position');
      },
    );
  }

  Widget _buildListView() {
    // This is a simplified list view showing items that would be on the map
    final items = <Map<String, dynamic>>[];
    
    if (_showWildlifeMarkers) {
      items.addAll([
        {
          'title': 'Tiger',
          'subtitle': 'Spotted yesterday at 14:30',
          'icon': Icons.pets,
          'color': AppTheme.accentGreen,
          'onTap': () => Navigator.pushNamed(context, '/wildlife'),
        },
        {
          'title': 'Elephant',
          'subtitle': 'Spotted today at 09:15',
          'icon': Icons.pets,
          'color': AppTheme.accentGreen,
          'onTap': () => Navigator.pushNamed(context, '/wildlife'),
        },
      ]);
    }
    
    if (_showAlertMarkers) {
      items.addAll([
        {
          'title': 'Forest Fire',
          'subtitle': 'Critical alert - Immediate attention required',
          'icon': Icons.local_fire_department,
          'color': AppTheme.accentOrange,
          'onTap': () => Navigator.pushNamed(context, '/alerts'),
        },
      ]);
    }
    
    if (_showIllegalActivityMarkers) {
      items.addAll([
        {
          'title': 'Illegal Logging',
          'subtitle': 'Reported by Ranger Kumar at 16:45',
          'icon': Icons.forest,
          'color': AppTheme.warningRed,
          'onTap': () => Navigator.pushNamed(context, '/illegal_activity'),
        },
      ]);
    }
    
    if (_showTargetSpotMarkers) {
      items.addAll([
        {
          'title': 'Patrol Point',
          'subtitle': 'Scheduled patrol at 18:00',
          'icon': Icons.location_on,
          'color': AppTheme.accentBlue,
          'onTap': () => Navigator.pushNamed(context, '/target_spot'),
        },
      ]);
    }
    
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No items to display.\nAdjust filters to see content.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CustomCard(
            onTap: item['onTap'],
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: item['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item['icon'],
                    color: item['color'],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['subtitle'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppTheme.textMuted,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddMarkersSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppTheme.textMuted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Add New Marker',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _buildActionTile(
            context: context,
            title: 'Wildlife Sighting',
            icon: Icons.pets,
            color: AppTheme.accentGreen,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/wildlife');
            },
          ),
          const SizedBox(height: 16),
          _buildActionTile(
            context: context,
            title: 'Illegal Activity',
            icon: Icons.warning,
            color: AppTheme.warningRed,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/illegal_activity');
            },
          ),
          const SizedBox(height: 16),
          _buildActionTile(
            context: context,
            title: 'Create Alert',
            icon: Icons.notification_important,
            color: AppTheme.accentOrange,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/alerts');
            },
          ),
          const SizedBox(height: 16),
          _buildActionTile(
            context: context,
            title: 'Target Spot',
            icon: Icons.location_on,
            color: AppTheme.accentBlue,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/target_spot');
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  
  void _showMarkerDetails(String title, String description, IconData icon, Color color) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppTheme.primaryDark,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.secondaryDark,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sample content for demonstration
                    const Text(
                      'Location Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'GPS Coordinates: 12.4244° N, 75.7395° E\nWestern Ghats Forest Division\nKerala, India',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Additional Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Navigate to detail page
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.remove_red_eye),
                            label: const Text('View Details'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: color,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Handle sharing
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.share),
                            label: const Text('Share'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: color,
                              side: BorderSide(color: color),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _toggleOfflineMode() {
    setState(() {
      _isOfflineMode = !_isOfflineMode;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isOfflineMode
            ? 'Switched to offline map mode'
            : 'Switched to online map mode'),
        backgroundColor: _isOfflineMode
            ? AppTheme.accentOrange
            : AppTheme.accentGreen,
      ),
    );
  }
  
  Widget _buildActionTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: AppTheme.secondaryDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityLogTab extends StatelessWidget {
  const ActivityLogTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get sample activities from different categories
    final wildlifeActivities = Wildlife.getSampleData().take(3).toList();
    final illegalActivities = IllegalActivity.getSampleData().take(3).toList();
    final alerts = Alert.getSampleData().take(3).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Log'),
        backgroundColor: AppTheme.primaryDark,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Recent Wildlife Sightings'),
          const SizedBox(height: 12),
          ...wildlifeActivities.map((wildlife) => _buildActivityItem(
            context: context,
            title: wildlife.name,
            subtitle: wildlife.species,
            date: wildlife.detectionTime,
            icon: Icons.pets,
            color: AppTheme.accentGreen,
            onTap: () {
              Navigator.pushNamed(context, '/wildlife_details', arguments: wildlife);
            },
          )),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Illegal Activities'),
          const SizedBox(height: 12),
          ...illegalActivities.map((activity) => _buildActivityItem(
            context: context,
            title: activity.title,
            subtitle: activity.description,
            date: activity.timestamp,
            icon: _getActivityIcon(activity.type),
            color: AppTheme.warningRed,
            onTap: () {
              Navigator.pushNamed(context, '/illegal_activity_details', arguments: activity);
            },
          )),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Recent Alerts'),
          const SizedBox(height: 12),
          ...alerts.map((alert) => _buildActivityItem(
            context: context,
            title: alert.title,
            subtitle: alert.description,
            date: alert.timestamp,
            icon: _getAlertIcon(alert.type),
            color: _getAlertColor(alert.type),
            onTap: () {
              Navigator.pushNamed(context, '/alert_details', arguments: alert);
            },
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => _buildActivityTypeSheet(context),
          );
        },
        backgroundColor: AppTheme.accentGreen,
        icon: const Icon(Icons.add),
        label: const Text('New Activity'),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }
  
  Widget _buildActivityItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required DateTime date,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final formattedDate = '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(
                  Icons.chevron_right,
                  color: AppTheme.textMuted,
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  IconData _getActivityIcon(IllegalActivityType type) {
    switch (type) {
      case IllegalActivityType.logging:
        return Icons.forest;
      case IllegalActivityType.poaching:
        return Icons.pets;
      case IllegalActivityType.mining:
        return Icons.landscape;
      case IllegalActivityType.trespassing:
        return Icons.do_not_step;
      case IllegalActivityType.trafficking:
        return Icons.local_shipping;
      case IllegalActivityType.fishing:
        return Icons.water;
      default:
        return Icons.warning;
    }
  }
  
  IconData _getAlertIcon(AlertType type) {
    switch (type) {
      case AlertType.illegal:
        return Icons.warning;
      case AlertType.wildlife:
        return Icons.pets;
      case AlertType.fire:
        return Icons.local_fire_department;
      case AlertType.maintenance:
        return Icons.build;
      default:
        return Icons.notification_important;
    }
  }
  
  Color _getAlertColor(AlertType type) {
    switch (type) {
      case AlertType.illegal:
        return AppTheme.warningRed;
      case AlertType.wildlife:
        return AppTheme.accentGreen;
      case AlertType.fire:
        return Colors.orange;
      case AlertType.maintenance:
        return AppTheme.accentBlue;
      default:
        return AppTheme.textMuted;
    }
  }
  
  Widget _buildActivityTypeSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppTheme.textMuted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Record New Activity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _buildActionTile(
            context: context,
            title: 'Wildlife Sighting',
            icon: Icons.pets,
            color: AppTheme.accentGreen,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/wildlife');
            },
          ),
          const SizedBox(height: 16),
          _buildActionTile(
            context: context,
            title: 'Report Illegal Activity',
            icon: Icons.warning,
            color: AppTheme.warningRed,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/illegal_activity');
            },
          ),
          const SizedBox(height: 16),
          _buildActionTile(
            context: context,
            title: 'Create Alert',
            icon: Icons.notification_important,
            color: AppTheme.accentOrange,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/alerts');
            },
          ),
          const SizedBox(height: 16),
          _buildActionTile(
            context: context,
            title: 'Mark Target Spot',
            icon: Icons.location_on,
            color: AppTheme.accentBlue,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/target_spot');
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  
  Widget _buildActionTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: AppTheme.secondaryDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Coming Soon'),
    );
  }
} 