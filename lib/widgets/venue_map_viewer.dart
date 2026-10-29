import 'package:flutter/material.dart';

class VenueMapViewer extends StatelessWidget {
  const VenueMapViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Color(0xFF5746E8)),
                  SizedBox(width: 7),
                  Text(
                    'Jelajahi venue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF25233B),
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Cubit untuk zoom',
                    style: TextStyle(fontSize: 11, color: Color(0xFF89879A)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: const EdgeInsets.all(20),
                  minScale: 0.7,
                  maxScale: 3,
                  child: Container(
                    width: 380,
                    height: 190,
                    color: const Color(0xFFF0F1F8),
                    child: Stack(
                      children: [
                        const Positioned.fill(
                          child: CustomPaint(painter: _VenueMapPainter()),
                        ),
                        const Positioned(
                          left: 18,
                          top: 20,
                          child: _MapPlace(
                            icon: Icons.mic_rounded,
                            label: 'Main stage',
                            color: Color(0xFF5746E8),
                          ),
                        ),
                        const Positioned(
                          right: 18,
                          top: 24,
                          child: _MapPlace(
                            icon: Icons.restaurant_rounded,
                            label: 'Food court',
                            color: Color(0xFFE78A43),
                          ),
                        ),
                        const Positioned(
                          left: 28,
                          bottom: 20,
                          child: _MapPlace(
                            icon: Icons.meeting_room_rounded,
                            label: 'Workshop',
                            color: Color(0xFF299C7A),
                          ),
                        ),
                        Positioned(
                          right: 26,
                          bottom: 22,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.wc_rounded,
                                  color: Color(0xFF77738E),
                                  size: 16,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Toilet',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPlace extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MapPlace({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _VenueMapPainter extends CustomPainter {
  const _VenueMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 19
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(size.width * 0.03, size.height * 0.52)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.4,
        size.width * 0.7,
        size.height * 0.62,
        size.width * 0.97,
        size.height * 0.43,
      );
    canvas.drawPath(path, roadPaint);
    final crossRoad = Path()
      ..moveTo(size.width * 0.52, size.height * 0.02)
      ..cubicTo(
        size.width * 0.43,
        size.height * 0.35,
        size.width * 0.62,
        size.height * 0.66,
        size.width * 0.5,
        size.height * 0.98,
      );
    canvas.drawPath(crossRoad, roadPaint);
    final greenPaint = Paint()..color = const Color(0xFFDCEFE4);
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.78),
      24,
      greenPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.82),
      18,
      greenPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
