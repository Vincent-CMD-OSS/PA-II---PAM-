import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/services/faskes_service.dart';

class EmergencyFaskesScreen extends StatefulWidget {
  const EmergencyFaskesScreen({super.key});

  @override
  State<EmergencyFaskesScreen> createState() => _EmergencyFaskesScreenState();
}

class _EmergencyFaskesScreenState extends State<EmergencyFaskesScreen> {
  final FaskesService _placesService = FaskesService();

  // State UI
  bool _isLoadingGps = true;
  bool _isLoadingFaskes = false;
  List<FaskesModel> _faskesList = [];
  String? _errorMessage;
  
  // Data Lokasi
  double? _userLat;
  double? _userLng;
  bool _isUsingFallback = false;
  double _currentRadiusKm = 5; 

  final double _fallbackLat = -6.1753;
  final double _fallbackLng = 106.8271;

  @override
  void initState() {
    super.initState();
    _initLocationAndFetch();
  }

  Future<void> _initLocationAndFetch() async {
    setState(() {
      _isLoadingGps = true;
      _errorMessage = null;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak.');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      _userLat = position.latitude;
      _userLng = position.longitude;
      _isUsingFallback = false;

    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _userLat = _fallbackLat;
        _userLng = _fallbackLng;
        _isUsingFallback = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('GPS tidak tersedia. Menggunakan lokasi simulasi (Jakarta Pusat).'),
          backgroundColor: Colors.orange,
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isLoadingGps = false);
      
      _fetchFaskes(radiusMeter: 50000); 
    }
  }

  Future<void> _fetchFaskes({double radiusMeter = 5000}) async {
    if (_userLat == null || _userLng == null) return;

    setState(() {
      _isLoadingFaskes = true;
      _currentRadiusKm = radiusMeter / 1000; 
    });

    try {
      final results = await _placesService.fetchNearbyHospitals(
        lat: _userLat!,
        lng: _userLng!,
        radiusMeter: radiusMeter, 
      );
      if (!mounted) return;
      setState(() {
        _faskesList = results;
        _isLoadingFaskes = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoadingFaskes = false;
      });
    }
  }

  String _formatJarak(double meter) {
    if (meter >= 1000) {
      return '${(meter / 1000).toStringAsFixed(1)} Km';
    }
    return '${meter.toInt()} m';
  }

  Future<void> _openMapsNavigation(FaskesModel faskes) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${faskes.lat},${faskes.lng}';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa membuka Google Maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEBEE),
      appBar: AppBar(
        title: const Text('Faskes Terdekat (Darurat)'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoadingGps) {
      return _centerMessage(icon: Icons.gps_fixed, text: 'Mencari lokasi Bunda...', isLoading: true);
    }

    if (_isLoadingFaskes) {
      return _centerMessage(icon: Icons.local_hospital, text: 'Mencari RS dalam radius $_currentRadiusKm Km...', isLoading: true);
    }

    if (_errorMessage != null) {
      return _centerMessage(icon: Icons.error_outline, text: _errorMessage!, isError: true);
    }

    if (_faskesList.isEmpty) {
      return _centerMessage(
        icon: Icons.search_off,
        text: 'Tidak ada RS/Klinik dalam radius ${_currentRadiusKm.toInt()} Km.',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildLocationInfoCard(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Text('Ditemukan ${_faskesList.length} RS/Klinik terdekat:', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
        ),
        const SizedBox(height: 8),
        ..._faskesList.map((faskes) => _buildFaskesCard(faskes)),
      ],
    );
  }

  Widget _buildLocationInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.my_location, color: Colors.blue, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isUsingFallback ? 'Lokasi Simulasi (Jakarta)' : 'Lokasi Anda',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _isUsingFallback ? Colors.orange : Colors.black87),
                ),
                Text('${_userLat?.toStringAsFixed(4)}, ${_userLng?.toStringAsFixed(4)}', style: const TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
          if (_isUsingFallback)
            const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20)
          else
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
        ],
      ),
    );
  }

  Widget _buildFaskesCard(FaskesModel faskes) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3)) 
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_hospital, color: Colors.red, size: 24),
              const SizedBox(width: 12),
              Expanded(child: Text(faskes.nama, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1C2B4A)), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(child: Text(faskes.alamat, style: const TextStyle(fontSize: 13, color: Colors.black54), maxLines: 2, overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.check_circle, size: 14, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(faskes.isOpen ? 'Buka' : 'Tutup', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                ]),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.straighten, size: 14, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(_formatJarak(faskes.jarakMeter), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
                ]),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _openMapsNavigation(faskes),
                icon: const Icon(Icons.navigation, size: 18),
                label: const Text('Navigasi', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _centerMessage({required IconData icon, required String text, bool isLoading = false, bool isError = false}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading) const CircularProgressIndicator(color: Colors.red) else Icon(icon, size: 50, color: isError ? Colors.red.shade300 : Colors.grey),
            const SizedBox(height: 16),
            Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: isError ? Colors.red.shade700 : Colors.black54)),
          ],
        ),
      ),
    );
  }
}