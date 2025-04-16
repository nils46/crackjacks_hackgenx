import 'package:flutter/material.dart';
import 'package:wildlife_guardian/theme/app_theme.dart';
import 'package:wildlife_guardian/models/alert.dart';
import 'package:wildlife_guardian/widgets/custom_card.dart';
import 'package:wildlife_guardian/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AlertType? _selectedFilter;
  final List<Alert> _alerts = Alert.getSampleData();
  List<Alert> _filteredAlerts = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filteredAlerts = _alerts;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _filterAlerts(AlertType? type) {
    setState(() {
      _selectedFilter = type;
      if (type == null) {
        _filteredAlerts = _alerts;
      } else {
        _filteredAlerts = _alerts.where((alert) => alert.type == type).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
        backgroundColor: AppTheme.primaryDark,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Alerts'),
            Tab(text: 'Map View'),
          ],
          indicatorColor: AppTheme.accentGreen,
          labelColor: AppTheme.accentGreen,
          unselectedLabelColor: AppTheme.textSecondary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAlertsListView(),
          _buildMapView(),
        ],
      ),
    );
  }

  Widget _buildAlertsListView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: AppTheme.secondaryDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(null, 'All'),
                    _buildFilterChip(AlertType.illegal, 'Illegal Activity'),
                    _buildFilterChip(AlertType.wildlife, 'Wildlife'),
                    _buildFilterChip(AlertType.fire, 'Fire'),
                    _buildFilterChip(AlertType.maintenance, 'Maintenance'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredAlerts.isEmpty
              ? const Center(
                  child: Text('No alerts found'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredAlerts.length,
                  itemBuilder: (context, index) {
                    final alert = _filteredAlerts[index];
                    return _buildAlertCard(alert);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(AlertType? type, String label) {
    bool isSelected = _selectedFilter == type;
    Color chipColor;
    
    if (type == null) {
      chipColor = AppTheme.accentBlue;
    } else {
      switch (type) {
        case AlertType.illegal:
          chipColor = Colors.red;
          break;
        case AlertType.wildlife:
          chipColor = AppTheme.accentGreen;
          break;
        case AlertType.fire:
          chipColor = Colors.orange;
          break;
        case AlertType.maintenance:
          chipColor = Colors.blue;
          break;
      }
    }

    return GestureDetector(
      onTap: () => _filterAlerts(type),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? chipColor.withOpacity(0.2) 
              : AppTheme.tertiaryDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? chipColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? chipColor : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard(Alert alert) {
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

    final formattedDate = DateFormat('MMM d, h:mm a').format(alert.timestamp);

    return CustomCard(
      onTap: () {
        _showAlertDetails(alert);
      },
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: alertColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  alertIcon,
                  color: alertColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
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
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: alertColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            alert.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CustomOutlinedButton(
                text: 'View Location',
                icon: Icons.location_on,
                color: AppTheme.accentBlue,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                onPressed: () {
                  // TODO: Navigate to map with location
                },
              ),
              const Spacer(),
              CustomIconButton(
                icon: Icons.send,
                size: 40,
                borderRadius: 8,
                onPressed: () {
                  // TODO: Implement sharing
                },
                tooltip: 'Share Alert',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAlertDetails(Alert alert) {
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

    final formattedDate = DateFormat('MMMM d, yyyy • h:mm a').format(alert.timestamp);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: AppTheme.secondaryDark,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.textMuted.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: alertColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        alertIcon,
                        color: alertColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alert.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: alertColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  alert.type.name.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: alertColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
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
                  ],
                ),
              ),
              
              const Divider(color: AppTheme.tertiaryDark),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        alert.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomCard(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          children: [
                            Container(
                              height: 180,
                              width: double.infinity,
                              color: AppTheme.tertiaryDark,
                              child: const Center(
                                child: Text(
                                  'Map Preview',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Coordinates',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${alert.latitude.toStringAsFixed(4)}, ${alert.longitude.toStringAsFixed(4)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  CustomButton(
                                    text: 'Navigate',
                                    icon: Icons.directions,
                                    onPressed: () {
                                      // TODO: Navigate to location
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Actions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppTheme.secondaryDark,
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.tertiaryDark,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Mark as Resolved',
                        icon: Icons.check_circle,
                        isFullWidth: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    CustomIconButton(
                      icon: Icons.share,
                      onPressed: () {
                        // TODO: Share alert
                      },
                      tooltip: 'Share Alert',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMapView() {
    return Container(
      color: AppTheme.primaryDark,
      child: const Center(
        child: Text(
          'Map View Coming Soon',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      ),
    );
  }
} 