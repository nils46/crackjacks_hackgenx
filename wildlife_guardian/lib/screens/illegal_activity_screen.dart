import 'package:flutter/material.dart';
import 'package:wildlife_guardian/theme/app_theme.dart';
import 'package:wildlife_guardian/models/illegal_activity.dart';
import 'package:wildlife_guardian/widgets/custom_card.dart';
import 'package:wildlife_guardian/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class IllegalActivityScreen extends StatefulWidget {
  const IllegalActivityScreen({Key? key}) : super(key: key);

  @override
  _IllegalActivityScreenState createState() => _IllegalActivityScreenState();
}

class _IllegalActivityScreenState extends State<IllegalActivityScreen> {
  final List<IllegalActivity> _activities = IllegalActivity.getSampleData();
  List<IllegalActivity> _filteredActivities = [];
  IllegalActivityType? _selectedType;
  ActivityStatus? _selectedStatus;
  
  @override
  void initState() {
    super.initState();
    _filteredActivities = _activities;
  }

  void _filterActivities() {
    setState(() {
      _filteredActivities = _activities.where((activity) {
        bool matchesType = _selectedType == null || activity.type == _selectedType;
        bool matchesStatus = _selectedStatus == null || activity.status == _selectedStatus;
        return matchesType && matchesStatus;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Illegal Activity Detection'),
        backgroundColor: AppTheme.primaryDark,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: _filteredActivities.isEmpty
                ? const Center(
                    child: Text(
                      'No activities found',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredActivities.length,
                    itemBuilder: (context, index) {
                      final activity = _filteredActivities[index];
                      return _buildActivityCard(activity);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement reporting new activity
          _showReportDialog();
        },
        backgroundColor: AppTheme.warningRed,
        icon: const Icon(Icons.add_alert),
        label: const Text('Report'),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.secondaryDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Type',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTypeDropdown(),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusDropdown(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Apply Filters',
                  icon: Icons.filter_list,
                  isFullWidth: true,
                  onPressed: _filterActivities,
                ),
              ),
              const SizedBox(width: 12),
              CustomIconButton(
                icon: Icons.clear,
                onPressed: () {
                  setState(() {
                    _selectedType = null;
                    _selectedStatus = null;
                    _filteredActivities = _activities;
                  });
                },
                tooltip: 'Clear Filters',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.tertiaryDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<IllegalActivityType>(
          dropdownColor: AppTheme.tertiaryDark,
          isExpanded: true,
          value: _selectedType,
          hint: const Text(
            'All Types',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          style: const TextStyle(color: AppTheme.textPrimary),
          icon: const Icon(Icons.arrow_drop_down, color: AppTheme.textSecondary),
          onChanged: (value) {
            setState(() {
              _selectedType = value;
            });
          },
          items: [
            ...IllegalActivityType.values.map(
              (type) => DropdownMenuItem(
                value: type,
                child: Text(type.name.capitalize()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.tertiaryDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ActivityStatus>(
          dropdownColor: AppTheme.tertiaryDark,
          isExpanded: true,
          value: _selectedStatus,
          hint: const Text(
            'All Statuses',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          style: const TextStyle(color: AppTheme.textPrimary),
          icon: const Icon(Icons.arrow_drop_down, color: AppTheme.textSecondary),
          onChanged: (value) {
            setState(() {
              _selectedStatus = value;
            });
          },
          items: [
            ...ActivityStatus.values.map(
              (status) => DropdownMenuItem(
                value: status,
                child: Text(status.name.capitalize()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(IllegalActivity activity) {
    final formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(activity.timestamp);
    
    // Determine the status color and icon
    Color statusColor;
    IconData activityIcon;
    
    switch (activity.type) {
      case IllegalActivityType.logging:
        activityIcon = Icons.forest;
        break;
      case IllegalActivityType.poaching:
        activityIcon = Icons.pets;
        break;
      case IllegalActivityType.mining:
        activityIcon = Icons.landscape;
        break;
      case IllegalActivityType.trespassing:
        activityIcon = Icons.do_not_step;
        break;
      case IllegalActivityType.trafficking:
        activityIcon = Icons.local_shipping;
        break;
      case IllegalActivityType.fishing:
        activityIcon = Icons.set_meal;
        break;
      case IllegalActivityType.waste:
        activityIcon = Icons.delete;
        break;
    }
    
    switch (activity.status) {
      case ActivityStatus.pending:
        statusColor = Colors.orange;
        break;
      case ActivityStatus.investigating:
        statusColor = AppTheme.accentBlue;
        break;
      case ActivityStatus.verified:
        statusColor = AppTheme.warningRed;
        break;
      case ActivityStatus.resolved:
        statusColor = AppTheme.accentGreen;
        break;
      case ActivityStatus.false_alarm:
        statusColor = Colors.grey;
        break;
    }

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () {
        _showActivityDetails(activity);
      },
      borderColor: activity.status == ActivityStatus.verified 
          ? AppTheme.warningRed.withOpacity(0.5) 
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  activityIcon,
                  color: statusColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            activity.status.name.capitalize(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
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
          const SizedBox(height: 12),
          Text(
            activity.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomOutlinedButton(
                  text: 'View on Map',
                  icon: Icons.map,
                  isFullWidth: true,
                  onPressed: () {
                    // TODO: Navigate to map with location
                  },
                ),
              ),
              const SizedBox(width: 12),
              if (activity.status != ActivityStatus.resolved) 
                CustomIconButton(
                  icon: Icons.check_circle_outline,
                  startColor: AppTheme.accentGreen,
                  endColor: AppTheme.accentGreen,
                  onPressed: () {
                    // TODO: Mark as resolved
                  },
                  tooltip: 'Mark as Resolved',
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showActivityDetails(IllegalActivity activity) {
    final formattedDate = DateFormat('MMMM d, yyyy • h:mm a').format(activity.timestamp);
    
    // Determine colors and icons based on type and status
    Color statusColor;
    IconData activityIcon;
    
    switch (activity.type) {
      case IllegalActivityType.logging:
        activityIcon = Icons.forest;
        break;
      case IllegalActivityType.poaching:
        activityIcon = Icons.pets;
        break;
      case IllegalActivityType.mining:
        activityIcon = Icons.landscape;
        break;
      case IllegalActivityType.trespassing:
        activityIcon = Icons.do_not_step;
        break;
      case IllegalActivityType.trafficking:
        activityIcon = Icons.local_shipping;
        break;
      case IllegalActivityType.fishing:
        activityIcon = Icons.set_meal;
        break;
      case IllegalActivityType.waste:
        activityIcon = Icons.delete;
        break;
    }
    
    switch (activity.status) {
      case ActivityStatus.pending:
        statusColor = Colors.orange;
        break;
      case ActivityStatus.investigating:
        statusColor = AppTheme.accentBlue;
        break;
      case ActivityStatus.verified:
        statusColor = AppTheme.warningRed;
        break;
      case ActivityStatus.resolved:
        statusColor = AppTheme.accentGreen;
        break;
      case ActivityStatus.false_alarm:
        statusColor = Colors.grey;
        break;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
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
              
              // Header with image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      activity.imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        activity.status.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  // Back button
                  Positioned(
                    top: 12,
                    left: 12,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryDark.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppTheme.textPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and type
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              activityIcon,
                              color: statusColor,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity.title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  activity.type.name.capitalize(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: statusColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Date and location
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.tertiaryDark,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: AppTheme.textSecondary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.location_on,
                              color: AppTheme.textSecondary,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${activity.latitude.toStringAsFixed(4)}, ${activity.longitude.toStringAsFixed(4)}',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        activity.description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Map
                      const Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.tertiaryDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Map Preview',
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Action recommendations
                      const Text(
                        'Recommended Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildRecommendationItem(
                        'Contact nearby patrol units',
                        'Send immediately',
                        Icons.people,
                        AppTheme.accentBlue,
                      ),
                      const SizedBox(height: 8),
                      _buildRecommendationItem(
                        'Document evidence',
                        'Photos and videos',
                        Icons.camera_alt,
                        AppTheme.accentGreen,
                      ),
                      const SizedBox(height: 8),
                      _buildRecommendationItem(
                        'Report to authorities',
                        'Police and forest department',
                        Icons.security,
                        AppTheme.accentOrange,
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
                        text: activity.status == ActivityStatus.resolved
                            ? 'Reopen Case'
                            : 'Mark as Resolved',
                        icon: activity.status == ActivityStatus.resolved
                            ? Icons.refresh
                            : Icons.check_circle,
                        isFullWidth: true,
                        startColor: activity.status == ActivityStatus.resolved
                            ? AppTheme.accentBlue
                            : AppTheme.accentGreen,
                        endColor: activity.status == ActivityStatus.resolved
                            ? AppTheme.accentBlue
                            : AppTheme.accentGreen,
                        onPressed: () {
                          // TODO: Implement status change
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    CustomIconButton(
                      icon: Icons.share,
                      onPressed: () {
                        // TODO: Implement sharing
                      },
                      tooltip: 'Share',
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

  Widget _buildRecommendationItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
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
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: color,
            size: 16,
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.secondaryDark,
          title: const Text(
            'Report Illegal Activity',
            style: TextStyle(color: AppTheme.textPrimary),
          ),
          content: const Text(
            'This feature will allow you to report new illegal activities with photos, location, and details. Coming soon in the next update!',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).replaceAll('_', ' ')}";
  }
} 