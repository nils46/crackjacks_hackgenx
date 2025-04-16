import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wildlife_guardian/theme/app_theme.dart';

class OfflineMapWidget extends StatefulWidget {
  final LatLng initialPosition;
  final List<MapMarker> markers;
  final double initialZoom;
  final bool showCurrentLocation;
  final void Function(LatLng)? onTap;

  const OfflineMapWidget({
    Key? key,
    this.initialPosition = const LatLng(0, 0),
    this.markers = const [],
    this.initialZoom = 13.0,
    this.showCurrentLocation = true,
    this.onTap,
  }) : super(key: key);

  @override
  State<OfflineMapWidget> createState() => _OfflineMapWidgetState();
}

class _OfflineMapWidgetState extends State<OfflineMapWidget> {
  late MapController _mapController;
  bool _isOfflineMode = false;
  LatLng? _currentPosition;
  bool _isLoading = true;
  bool _locationError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }
  
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = true;
            _errorMessage = 'Location permission denied';
            _isLoading = false;
          });
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = true;
          _errorMessage = 'Location permissions permanently denied, please enable in settings';
          _isLoading = false;
        });
        return;
      }
      
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
        
        // If we want to use the user's current location as center
        if (widget.showCurrentLocation && _currentPosition != null) {
          _mapController.move(_currentPosition!, widget.initialZoom);
        }
      });
    } catch (e) {
      setState(() {
        _locationError = true;
        _errorMessage = 'Error getting location: ${e.toString()}';
        _isLoading = false;
      });
      debugPrint('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.accentGreen,
        ),
      );
    }
    
    if (_locationError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off,
              size: 48,
              color: AppTheme.warningRed,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.warningRed,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _locationError = false;
                  _isLoading = true;
                });
                _getCurrentLocation();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    // Determine the center position for the map
    final centerPosition = widget.showCurrentLocation && _currentPosition != null
        ? _currentPosition!
        : widget.initialPosition;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: centerPosition,
            initialZoom: widget.initialZoom,
            onTap: widget.onTap != null
                ? (_, point) => widget.onTap!(point)
                : null,
            interactionOptions: const InteractionOptions(
              enableScrollWheel: true,
              enableMultiFingerGestureRace: true,
              flags: InteractiveFlag.all,
            ),
            minZoom: 4,
            maxZoom: 18,
          ),
          children: [
            TileLayer(
              urlTemplate: _isOfflineMode
                  ? 'assets/map_tiles/{z}/{x}/{y}.png'
                  : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.wildlife.guardian',
              maxNativeZoom: 18,
              tileBuilder: (context, widget, tile) {
                // This will help with debugging tile loading issues
                if (tile.loadError != null) {
                  debugPrint('Error loading tile: ${tile.loadError}');
                  return ColoredBox(
                    color: Colors.grey[300]!,
                    child: const Center(
                      child: Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  );
                }
                return widget;
              },
              fallbackUrl: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            
            // Add markers
            MarkerLayer(
              markers: [
                ...widget.markers.map((marker) => 
                  Marker(
                    point: marker.position, 
                    child: _buildMarker(marker),
                  )
                ).toList(),
                
                // Show current location marker if enabled
                if (widget.showCurrentLocation && _currentPosition != null)
                  Marker(
                    point: _currentPosition!,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.accentBlue.withOpacity(0.4),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.accentBlue,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.my_location,
                        color: AppTheme.accentBlue,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        
        // Current location button
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            heroTag: 'locationButton',
            mini: true,
            backgroundColor: AppTheme.primaryDark,
            onPressed: () {
              if (_currentPosition != null) {
                _mapController.move(_currentPosition!, 16.0);
              } else {
                _getCurrentLocation();
              }
            },
            child: const Icon(
              Icons.my_location,
              color: AppTheme.accentBlue,
            ),
          ),
        ),
        
        // Offline mode indicator
        Positioned(
          top: 16,
          left: 16,
          child: InkWell(
            onTap: () {
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
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _isOfflineMode
                    ? AppTheme.accentOrange.withOpacity(0.8)
                    : AppTheme.accentGreen.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isOfflineMode ? Icons.wifi_off : Icons.wifi,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isOfflineMode ? 'Offline Mode' : 'Online Mode',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMarker(MapMarker marker) {
    return GestureDetector(
      onTap: () {
        if (marker.onTap != null) {
          marker.onTap!();
        }
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: marker.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              marker.icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          if (marker.label != null) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                marker.label!,
                style: TextStyle(
                  color: marker.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class MapMarker {
  final LatLng position;
  final IconData icon;
  final Color color;
  final String? label;
  final VoidCallback? onTap;

  const MapMarker({
    required this.position,
    required this.icon,
    required this.color,
    this.label,
    this.onTap,
  });
} 