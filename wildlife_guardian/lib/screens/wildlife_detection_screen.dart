import 'package:flutter/material.dart';
import 'package:wildlife_guardian/theme/app_theme.dart';
import 'package:wildlife_guardian/models/wildlife.dart';
import 'package:wildlife_guardian/widgets/custom_card.dart';
import 'package:wildlife_guardian/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class WildlifeDetectionScreen extends StatefulWidget {
  const WildlifeDetectionScreen({Key? key}) : super(key: key);

  @override
  _WildlifeDetectionScreenState createState() => _WildlifeDetectionScreenState();
}

class _WildlifeDetectionScreenState extends State<WildlifeDetectionScreen> {
  final List<Wildlife> _wildlife = Wildlife.getSampleData();
  List<Wildlife> _filteredWildlife = [];
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _filteredWildlife = _wildlife;
  }

  void _filterWildlife(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredWildlife = _wildlife;
      } else {
        _filteredWildlife = _wildlife
            .where((animal) =>
                animal.name.toLowerCase().contains(query.toLowerCase()) ||
                animal.species.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wildlife Detection'),
        backgroundColor: AppTheme.primaryDark,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.secondaryDark,
            child: Column(
              children: [
                TextField(
                  onChanged: _filterWildlife,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search by species or name',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
                    filled: true,
                    fillColor: AppTheme.tertiaryDark,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.accentGreen, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Detections',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Icon(
                      Icons.tune,
                      color: AppTheme.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredWildlife.isEmpty
                ? const Center(
                    child: Text(
                      'No wildlife found',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredWildlife.length,
                    itemBuilder: (context, index) {
                      final animal = _filteredWildlife[index];
                      return _buildWildlifeCard(animal);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accentGreen,
        onPressed: () {
          // TODO: Add functionality to manually report wildlife
          _showAddWildlifeDialog(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildWildlifeCard(Wildlife wildlife) {
    final formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(wildlife.detectionTime);
    
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(0),
      onTap: () {
        _showWildlifeDetails(wildlife);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  wildlife.imageUrl,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDark.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    wildlife.status,
                    style: const TextStyle(
                      color: AppTheme.accentGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      wildlife.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppTheme.accentGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${wildlife.latitude.toStringAsFixed(2)}, ${wildlife.longitude.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.accentGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  wildlife.species,
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: AppTheme.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
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
                          // TODO: Navigate to map view
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    CustomIconButton(
                      icon: Icons.share,
                      onPressed: () {
                        // TODO: Implement sharing
                      },
                      tooltip: 'Share',
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

  void _showWildlifeDetails(Wildlife wildlife) {
    final formattedDate = DateFormat('MMMM d, yyyy • h:mm a').format(wildlife.detectionTime);

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
              
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.network(
                  wildlife.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                wildlife.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                wildlife.species,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.accentGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              wildlife.status,
                              style: const TextStyle(
                                color: AppTheme.accentGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Detection Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(Icons.access_time, 'Time', formattedDate),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        Icons.location_on,
                        'Location',
                        '${wildlife.latitude.toStringAsFixed(4)}, ${wildlife.longitude.toStringAsFixed(4)}',
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Location Map',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 200,
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
                      const Text(
                        'Conservation Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      CustomCard(
                        color: AppTheme.tertiaryDark,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Population in region is stable with increasing trend over the past 3 years. Species is protected under the Wildlife Protection Act.',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildStatusIndicator('Endangerment', 'Low', Colors.green),
                                const SizedBox(width: 12),
                                _buildStatusIndicator('Protection', 'High', AppTheme.accentGreen),
                              ],
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
                        text: 'Track Movement',
                        icon: Icons.timeline,
                        isFullWidth: true,
                        onPressed: () {
                          // TODO: Implement tracking
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    CustomIconButton(
                      icon: Icons.share,
                      onPressed: () {
                        // TODO: Share wildlife sighting
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.tertiaryDark,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.textSecondary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(String label, String status, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: status == 'Low' ? 0.3 : status == 'Medium' ? 0.6 : 0.9,
            backgroundColor: AppTheme.tertiaryDark,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddWildlifeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.secondaryDark,
          title: const Text(
            'Record Wildlife Sighting',
            style: TextStyle(color: AppTheme.textPrimary),
          ),
          content: const Text(
            'This feature will allow you to manually record wildlife sightings with photos and details. Coming soon in the next update!',
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