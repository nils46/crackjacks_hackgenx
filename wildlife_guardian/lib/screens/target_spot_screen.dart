import 'package:flutter/material.dart';
import 'package:wildlife_guardian/theme/app_theme.dart';
import 'package:wildlife_guardian/widgets/custom_card.dart';
import 'package:wildlife_guardian/widgets/custom_button.dart';
import 'dart:math' as math;

class TargetSpotScreen extends StatefulWidget {
  const TargetSpotScreen({Key? key}) : super(key: key);

  @override
  _TargetSpotScreenState createState() => _TargetSpotScreenState();
}

class _TargetSpotScreenState extends State<TargetSpotScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _direction = 45.0; // Simulated direction in degrees
  double _distance = 2.4; // Simulated distance in kilometers
  
  final List<TargetLocation> _recentLocations = [
    TargetLocation(
      name: 'Suspected Poaching Activity',
      type: LocationType.alert,
      latitude: 19.085,
      longitude: 72.891,
      distanceKm: 2.4,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    TargetLocation(
      name: 'Bengal Tiger Sighting',
      type: LocationType.wildlife,
      latitude: 19.076,
      longitude: 72.877,
      distanceKm: 3.8,
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    TargetLocation(
      name: 'Illegal Logging Site',
      type: LocationType.illegal,
      latitude: 19.092,
      longitude: 72.856,
      distanceKm: 5.2,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    TargetLocation(
      name: 'Camera Trap #37',
      type: LocationType.equipment,
      latitude: 19.068,
      longitude: 72.902,
      distanceKm: 1.9,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _simulateDirection();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Simulate changing direction for demo purposes
  void _simulateDirection() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          // Randomly adjust direction to simulate movement
          _direction += (math.Random().nextDouble() * 20 - 10);
          if (_direction < 0) _direction += 360;
          if (_direction >= 360) _direction -= 360;
          
          // Small random change in distance
          _distance += (math.Random().nextDouble() * 0.2 - 0.1);
          if (_distance < 0.1) _distance = 0.1;
        });
        _animationController.forward(from: 0.0);
        _simulateDirection();
      }
    });
  }

  String _getDirectionText(double degrees) {
    final directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((degrees + 22.5) % 360 / 45).floor();
    return directions[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Target Spot Direction'),
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
                const Text(
                  'Current Target',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Suspected Poaching Activity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: Colors.red,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'HIGH PRIORITY',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_distance.toStringAsFixed(1)} km away',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                _buildCompassView(),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: 'Navigate',
                      icon: Icons.navigation,
                      onPressed: () {
                        // TODO: Implement external navigation
                      },
                    ),
                    const SizedBox(width: 16),
                    CustomOutlinedButton(
                      text: 'Mark as Reached',
                      icon: Icons.check_circle_outline,
                      onPressed: () {
                        // TODO: Implement marking as reached
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.secondaryDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Locations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _recentLocations.length,
                    itemBuilder: (context, index) {
                      final location = _recentLocations[index];
                      return _buildLocationCard(location);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompassView() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.tertiaryDark,
                border: Border.all(
                  color: AppTheme.accentBlue.withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
            
            // Inner ring
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondaryDark,
                border: Border.all(
                  color: AppTheme.accentBlue.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            
            // Cardinal directions
            Positioned(
              top: 20,
              child: _buildDirectionText('N', _direction == 0),
            ),
            Positioned(
              right: 20,
              child: _buildDirectionText('E', _direction == 90),
            ),
            Positioned(
              bottom: 20,
              child: _buildDirectionText('S', _direction == 180),
            ),
            Positioned(
              left: 20,
              child: _buildDirectionText('W', _direction == 270),
            ),

            // Direction text in center
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getDirectionText(_direction),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_direction.toStringAsFixed(1)}°',
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            
            // Direction arrow
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _direction * math.pi / 180,
                  child: child,
                );
              },
              child: Container(
                width: 200,
                height: 200,
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: AppTheme.accentGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 80,
                      color: AppTheme.accentGreen,
                    ),
                    CustomPaint(
                      size: const Size(20, 10),
                      painter: ArrowPainter(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.tertiaryDark,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on,
                color: AppTheme.accentGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Coordinates: 19.085, 72.891',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textPrimary.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDirectionText(String text, bool isHighlighted) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isHighlighted
            ? AppTheme.accentGreen
            : AppTheme.tertiaryDark,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isHighlighted 
              ? AppTheme.primaryDark 
              : AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildLocationCard(TargetLocation location) {
    Color cardColor;
    IconData locationIcon;
    
    switch (location.type) {
      case LocationType.alert:
        cardColor = Colors.red;
        locationIcon = Icons.warning;
        break;
      case LocationType.wildlife:
        cardColor = AppTheme.accentGreen;
        locationIcon = Icons.pets;
        break;
      case LocationType.illegal:
        cardColor = Colors.orange;
        locationIcon = Icons.report_problem;
        break;
      case LocationType.equipment:
        cardColor = AppTheme.accentBlue;
        locationIcon = Icons.camera_alt;
        break;
    }

    return GestureDetector(
      onTap: () {
        // TODO: Implement setting this as current target
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        child: CustomCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      locationIcon,
                      color: cardColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      location.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.near_me,
                        size: 14,
                        color: AppTheme.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${location.distanceKm.toStringAsFixed(1)} km',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.tertiaryDark,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'SELECT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentGreen
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TargetLocation {
  final String name;
  final LocationType type;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final DateTime timestamp;

  TargetLocation({
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.timestamp,
  });
}

enum LocationType {
  alert,
  wildlife,
  illegal,
  equipment,
} 