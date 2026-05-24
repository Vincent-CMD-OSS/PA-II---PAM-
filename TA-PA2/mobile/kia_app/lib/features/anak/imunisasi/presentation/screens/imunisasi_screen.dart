import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/core/themes/app_theme.dart';

class ImunisasiScreen extends StatefulWidget {
  final Map<String, dynamic>? anak;

  const ImunisasiScreen({Key? key, this.anak}) : super(key: key);

  @override
  State<ImunisasiScreen> createState() => _ImunisasiScreenState();
}

class _ImunisasiScreenState extends State<ImunisasiScreen> {
  DateTime _focusedMonth = DateTime(2026, 4);

  final List<int> _selesaiDays = [4, 10];
  final List<int> _dijadwalkanDays = [24];
  final int _todayDay = 17;

  final List<Map<String, dynamic>> _riwayat = [
    {'nama': 'K1 & K2', 'tanggal': '5 Apr 2026', 'status': 'selesai', 'dot': Color(0xFF1B9E5F)},
    {'nama': 'TT1 (Tetanus)', 'tanggal': '5 Apr 2026', 'status': 'selesai', 'dot': Color(0xFF1B9E5F)},
    {'nama': 'TT2 (Tetanus)', 'tanggal': '1 Apr 2026', 'status': 'selesai', 'dot': Color(0xFF1B9E5F)},
    {'nama': 'Hepatitis B', 'tanggal': '28 Apr 2026', 'status': 'menunggu', 'dot': Color(0xFFF59E0B)},
  ];

  String get _monthLabel {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${months[_focusedMonth.month]} ${_focusedMonth.year}';
  }

  void _prevMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusCard(),
                  const SizedBox(height: 14),
                  _buildRiwayatSingkat(),
                  const SizedBox(height: 14),
                  _buildKalender(),
                  const SizedBox(height: 14),
                  _buildRiwayatImunisasi(),
                  const SizedBox(height: 14),
                  _buildCtaVitamin(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── HEADER ──────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 52, left: 20, right: 20, bottom: 60),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: TrimesterTheme.t1Gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Tombol back
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Judul + nama anak
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Imunisasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (widget.anak != null)
                    Text(
                      widget.anak!["nama"] ?? "",
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                ],
              ),
            ],
          ),
          // Ikon notifikasi
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  // ── STATUS CARD ─────────────────────────────────────────────────────────────
  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'STATUS IMUNISASI',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF9F1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'On The Way',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF1B9E5F)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '6',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: TrimesterTheme.t1Primary),
              ),
              const Text(
                '/24 Imunisasi',
                style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const Text(
            'Bu Raniyah • 02P140',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 6 / 24,
              minHeight: 6,
              backgroundColor: const Color(0xFFEEF2FF),
              color: TrimesterTheme.t1Primary,
            ),
          ),
        ],
      ),
    );
  }

  // ── RIWAYAT SINGKAT ─────────────────────────────────────────────────────────
  Widget _buildRiwayatSingkat() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Riwayat Imunisasi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
          const SizedBox(height: 2),
          const Text('Minggu 13 · 2 kunjungan ANC', style: TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'K1 & K2 selesai: 2/3',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TrimesterTheme.t1Primary),
            ),
          ),
        ],
      ),
    );
  }

  // ── KALENDER ────────────────────────────────────────────────────────────────
  Widget _buildKalender() {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    int startOffset = firstDayOfMonth.weekday % 7;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kalender Imunisasi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              Row(
                children: [
                  GestureDetector(onTap: _prevMonth, child: Icon(Icons.chevron_left, color: TrimesterTheme.t1Primary, size: 20)),
                  const SizedBox(width: 4),
                  Text(_monthLabel, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TrimesterTheme.t1Primary)),
                  const SizedBox(width: 4),
                  GestureDetector(onTap: _nextMonth, child: Icon(Icons.chevron_right, color: TrimesterTheme.t1Primary, size: 20)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'].map((d) {
              return Expanded(
                child: Center(
                  child: Text(d, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              childAspectRatio: 1,
            ),
            itemCount: startOffset + daysInMonth,
            itemBuilder: (context, index) {
              if (index < startOffset) return const SizedBox();
              final day = index - startOffset + 1;
              final isToday = day == _todayDay;
              final isSelesai = _selesaiDays.contains(day);
              final isDijadwalkan = _dijadwalkanDays.contains(day);
              final isWeekend = (index % 7 == 0 || index % 7 == 6);

              return Center(
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isToday ? TrimesterTheme.t1Primary : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isToday
                              ? Colors.white
                              : isWeekend
                                  ? Colors.grey.shade400
                                  : Colors.black87,
                        ),
                      ),
                      if ((isSelesai || isDijadwalkan) && !isToday)
                        Positioned(
                          bottom: 4,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelesai ? TrimesterTheme.t1Primary : const Color(0xFFF59E0B),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 10),
          Row(
            children: [
              _legendItem(TrimesterTheme.t1Primary, 'Selesai'),
              const SizedBox(width: 16),
              _legendItem(const Color(0xFFF59E0B), 'Dijadwalkan'),
              const SizedBox(width: 16),
              _legendItem(TrimesterTheme.t1Primary, 'Hari ini', isCircle: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, {bool isCircle = false}) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: isCircle ? Border.all(color: color, width: 2) : null,
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  // ── RIWAYAT IMUNISASI ───────────────────────────────────────────────────────
  Widget _buildRiwayatImunisasi() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Riwayat Imunisasi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Imunisasi — April 2026',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TrimesterTheme.t1Primary)),
          const SizedBox(height: 4),
          ..._riwayat.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: item['dot'] as Color,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['nama'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                            Text(item['tanggal'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: item['status'] == 'selesai'
                              ? const Color(0xFFEAF9F1)
                              : const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item['status'] == 'selesai' ? 'Selesai' : 'Menunggu',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: item['status'] == 'selesai'
                                ? const Color(0xFF1B9E5F)
                                : const Color(0xFFB45309),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < _riwayat.length - 1)
                  const Divider(height: 1, color: Color(0xFFF4F4F4)),
              ],
            );
          }),
          const SizedBox(height: 8),
          Center(
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Lihat Riwayat Lengkap',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TrimesterTheme.t1Primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── CTA VITAMIN ─────────────────────────────────────────────────────────────
  Widget _buildCtaVitamin() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: TrimesterTheme.t1Gradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Vitamin & Obat Cacing', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
            Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}