import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'beranda_screen.dart';

// ==========================================
// ASSETS BASE64 (PARTY POPPER & SHARE)
// ==========================================
const String _tightPartyPopperBase64 = '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';
const String _partyPopperBase64 = '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';
const String _shareFigmaBase64 = 'iVBORw0KGgoAAAANSUhEUgAAACAAAAAkCAYAAADo6zjiAAACF0lEQVR4nMVWPWtUQRQ9Zw2xMGIZRLJFkKBNIBgQFAQ7u4CwqVJtk/wCf4617mNtUlkJ6cTK0kZEQdDGIlUI4cgsdzZ3X+Z9hJ3RA8POx925582de+YSCUgaxj7J7/hXkPRQ0sSa7PeVpN1SPumcjwCE1oSKZFWEhaQd98ULJMLYncqoFIGJpKmkjYb1YSRRwvnQNh932IWTUO5TGABYtf5pzo2vQ+DM+qv/hQDJH9bf67AtcwFr8U1eMkkHth4zZQcFdGBiX1lZ+w1gBcChm/f4AOA9ya9ZCHSJEcl9s9kG8BTAc1sKxD6R/IZlCQSk0iylgAmyV5RS0j0ATwDcAbAG4CeALyQ/z/fGknBE5uELRNz8DQAXtb9NSb4NnRDjpWDOTtxUuKSVO51Z6BzC/BtJt0i+Rk64dyMieZ+czW5WAn0lW9JmfFsGKIN3AHxYFuBSd1SKwMu+hgOUw7OO9VnWDAo4vh0dtFzCA+tW2bxK2qrVkslM6Hp3rg1JdyUdpRy6uamROnYE14MNm9IEwCMbnpD8lbBZtzhHxQuP1p+EHHdKdjI/a8/vuEVw8hSruozNfNOEo+3a+MHSjuNxtslnihxyQpcVT5t8jktUxTP0qfndKWUvyyM+ogUuE26iEIHHbYZW3QSc5yTQO77u9geNyAtJGy7/r6RWdvlsIHG/lmov6jpQzDkWiXgVLJP3PYk0Pqc58Rd0kn7IEOgZeQAAAABJRU5ErkJggg==';

const String _telkomselLogoBase64 = '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';
const String _contactBookIconBase64 = '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';

// ==========================================
// WIDGET LOGO TELKOMSEL & CONTACT BOOK EXACT FIGMA
// ==========================================
Widget _buildTelkomselLogo({double size = 30}) {
  return Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      color: Color(0xFFF3F3F3),
      shape: BoxShape.circle,
    ),
    alignment: Alignment.center,
    child: Image.memory(
      base64Decode(_telkomselLogoBase64),
      width: size * 0.54,
      height: size * 0.74,
      fit: BoxFit.contain,
    ),
  );
}

Widget _buildContactBookIcon({double width = 22, double height = 24}) {
  return Image.memory(
    base64Decode(_contactBookIconBase64),
    width: width,
    height: height,
    fit: BoxFit.contain,
  );
}



class _ClearXCircleIcon extends StatelessWidget {
  final double size;

  const _ClearXCircleIcon({
    this.size = 19,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CustomPaint(
        painter: _ClearXCirclePainter(),
      ),
    );
  }
}

class _ClearXCirclePainter extends CustomPainter {
  const _ClearXCirclePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFF4A4A4A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1.0;
    canvas.drawCircle(center, radius, strokePaint);

    final xOffset = radius * 0.44;
    canvas.drawLine(
      Offset(center.dx - xOffset, center.dy - xOffset),
      Offset(center.dx + xOffset, center.dy + xOffset),
      strokePaint,
    );
    canvas.drawLine(
      Offset(center.dx + xOffset, center.dy - xOffset),
      Offset(center.dx - xOffset, center.dy + xOffset),
      strokePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


// ==========================================
// WIDGET LOGO PLN PERSIS GAMBAR USER & FIGMA
// ==========================================
Widget _buildPlnExactLogo({double? size, double? width, double? height, double radius = 5}) {
  final double w = width ?? (size != null ? size * 0.775 : 32);
  final double h = height ?? (size ?? 41);
  return Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: const Color(0xFFFFF500),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: const [
        BoxShadow(
          color: Color(0x10000000),
          blurRadius: 3,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        'assets/images/pln_exact_logo.png',
        width: w,
        height: h,
        fit: BoxFit.fill,
      ),
    ),
  );
}

// ==========================================
// CUSTOM PAINTER: PESAWAT KERTAS FIGMA
// ==========================================
class _PaperPlanePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(w, h * 0.5)
      ..lineTo(0, h)
      ..lineTo(w * 0.28, h * 0.5)
      ..close();

    canvas.drawPath(path, paint);

    final foldPaint = Paint()
      ..color = const Color(0xFFCA31FF)
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(w * 0.28, h * 0.5),
      Offset(w * 0.72, h * 0.5),
      foldPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// CUSTOM PAINTER: DOMPET XEMA EXACT FIGMA
// ==========================================
class _XemaWalletExactPainter extends CustomPainter {
  final Color strokeColor;
  final Color fillColor;

  const _XemaWalletExactPainter({
    this.strokeColor = const Color(0xFF1C0823),
    this.fillColor = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {

    final scaleX = size.width / 42.0;
    final scaleY = size.height / 38.0;
    canvas.scale(scaleX, scaleY);

    final strokePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = 1.65
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    // 1. Koin di kanan atas (Coin at top right)
    const coinCenter = Offset(26.5, 9.5);
    const coinRadius = 7.5;
    canvas.drawCircle(coinCenter, coinRadius, fillPaint);
    canvas.drawCircle(coinCenter, coinRadius, strokePaint);

    // Huruf 'C' di dalam koin
    final cPath = Path()
      ..addArc(
        Rect.fromCircle(center: coinCenter, radius: 3.8),
        0.8,
        4.7,
      );
    final cStroke = Paint()
      ..color = strokeColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(cPath, cStroke);

    // 2. Lipatan kantong kiri atas (Top-left flap)
    final flapPath = Path()
      ..moveTo(4.0, 15.0)
      ..lineTo(4.0, 9.5)
      ..arcToPoint(
        const Offset(7.0, 6.5),
        radius: const Radius.circular(3.0),
      )
      ..lineTo(17.5, 6.5)
      ..lineTo(17.5, 15.0)
      ..close();
    canvas.drawPath(flapPath, fillPaint);

    final flapOutline = Path()
      ..moveTo(4.0, 15.0)
      ..lineTo(4.0, 9.5)
      ..arcToPoint(
        const Offset(7.0, 6.5),
        radius: const Radius.circular(3.0),
      )
      ..lineTo(17.5, 6.5);
    canvas.drawPath(flapOutline, strokePaint);

    // Garis lipatan dalam pada flap
    canvas.drawLine(
      const Offset(7.0, 10.5),
      const Offset(15.5, 10.5),
      strokePaint,
    );

    // 3. Badan utama dompet (Main Wallet Body)
    final bodyRRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(4.0, 15.0, 30.0, 21.0),
      const Radius.circular(4.5),
    );
    canvas.drawRRect(bodyRRect, fillPaint);
    canvas.drawRRect(bodyRRect, strokePaint);

    // 4. Pengait dompet di sisi kanan (Clasp on right)
    final claspRRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(24.5, 22.0, 14.0, 7.0),
      const Radius.circular(3.5),
    );
    canvas.drawRRect(claspRRect, fillPaint);
    canvas.drawRRect(claspRRect, strokePaint);

    // Kancing / lubang titik di tengah pengait
    final rivetPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(34.0, 25.5), 1.3, rivetPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// CUSTOM PAINTER: KUNCI HORIZONTAL EXACT FIGMA
// ==========================================
class _HorizontalKeyPainter extends CustomPainter {
  const _HorizontalKeyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCA31FF)
      ..style = PaintingStyle.fill;

    final scaleX = size.width / 40.0;
    final scaleY = size.height / 27.0;
    canvas.scale(scaleX, scaleY);

    // 1. Lingkaran kepala kunci (Bow ring) di sebelah kiri persis Foto 3
    const bowCenter = Offset(11.5, 13.0);
    final outerBow = Path()
      ..addOval(Rect.fromCircle(center: bowCenter, radius: 11.5));
    final innerHole = Path()
      ..addOval(Rect.fromCircle(center: bowCenter, radius: 4.3));
    final bowPath = Path.combine(PathOperation.difference, outerBow, innerHole);
    canvas.drawPath(bowPath, paint);

    // 2. Batang kunci horizontal (Shaft)
    final shaftPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(11.5, 9.5, 28.0, 7.0),
          const Radius.circular(1.0),
        ),
      );
    canvas.drawPath(shaftPath, paint);

    // 3. Satu gigi kunci di ujung kanan bawah persis Foto 3
    final toothPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(32.5, 16.5, 5.5, 6.5),
          const Radius.circular(0.8),
        ),
      );
    canvas.drawPath(toothPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// TOMBOL SALIN TOKEN DENGAN ANIMASI INTERAKTIF & TACTILE
// ==========================================
class _CopyTokenButton extends StatefulWidget {
  final String textToCopy;

  const _CopyTokenButton({
    required this.textToCopy,
  });

  @override
  State<_CopyTokenButton> createState() => _CopyTokenButtonState();
}

class _CopyTokenButtonState extends State<_CopyTokenButton> {
  static const Color _iconColor = Color(0xFF570374);
  static const double _iconSize = 22;

  bool _isCopied = false;
  bool _isPressed = false;
  bool _isHovered = false;
  Timer? _resetTimer;

  void _handleCopy() {
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: widget.textToCopy));

    _resetTimer?.cancel();
    setState(() {
      _isCopied = true;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text(
              'Nomor token PLN berhasil disalin!',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: _iconColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );

    _resetTimer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: _handleCopy,
        child: AnimatedScale(
          scale: _isPressed ? 0.85 : (_isHovered ? 1.15 : 1.0),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutBack,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isCopied
                  ? const Color(0x26570374)
                  : (_isHovered ? const Color(0x1F570374) : Colors.transparent),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: _isCopied
                  ? const Icon(
                      Icons.check_rounded,
                      key: ValueKey('copied_icon'),
                      color: _iconColor,
                      size: _iconSize,
                    )
                  : const Icon(
                      Icons.copy_rounded,
                      key: ValueKey('copy_icon'),
                      color: _iconColor,
                      size: _iconSize,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// TOMBOL OK DENGAN ANIMASI INTERAKTIF & FEEDBACK TACTILE
// ==========================================
class _AnimatedOkButton extends StatefulWidget {
  final VoidCallback onTap;
  final double height;
  final double borderRadius;

  const _AnimatedOkButton({
    required this.onTap,
    this.height = 52,
    this.borderRadius = 28,
  });

  @override
  State<_AnimatedOkButton> createState() => _AnimatedOkButtonState();
}

class _AnimatedOkButtonState extends State<_AnimatedOkButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : (_isHovered ? 1.02 : 1.0),
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: const Color(0xFFCA31FF),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? const Color(0x80CA31FF) // Glow lebih terang saat disentuh kursor
                    : const Color(0x4DCA31FF),
                blurRadius: _isHovered ? 20 : 14,
                offset: _isHovered ? const Offset(0, 6) : const Offset(0, 5),
                spreadRadius: _isHovered ? 2 : 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              splashColor: const Color(0x4DFFFFFF),
              highlightColor: const Color(0x26FFFFFF),
              onHover: (hovered) => setState(() => _isHovered = hovered),
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              onTap: () {
                HapticFeedback.mediumImpact();
                widget.onTap();
              },
              child: Center(
                child: Text(
                  'OK',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// PPOB SCREEN & PULSA / PAKET DATA FLOW
// ==========================================

// CUSTOM PAINTER: PHONE & WIFI / SIGNAL ICON FIGMA (NODE 477:475)
class _PhoneWifiIconPainter extends CustomPainter {
  const _PhoneWifiIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 43.0;
    final fillPaint = Paint()
      ..color = const Color(0xFF52086B)
      ..style = PaintingStyle.fill;

    final path = Path()..fillType = PathFillType.nonZero;

    path.moveTo(s * 18.6333, s * 0.0);
    path.cubicTo(s * 19.436, s * 0.0, s * 20.0667, s * 0.630667, s * 20.0667, s * 1.43333);
    path.lineTo(s * 20.0667, s * 12.3553);
    path.cubicTo(s * 19.092, s * 12.7567, s * 18.1173, s * 13.2153, s * 17.2, s * 13.76);
    path.lineTo(s * 17.2, s * 12.9);
    path.cubicTo(s * 17.2, s * 12.0973, s * 16.5693, s * 11.4667, s * 15.7667, s * 11.4667);
    path.lineTo(s * 4.3, s * 11.4667);
    path.cubicTo(s * 3.49733, s * 11.4667, s * 2.86667, s * 12.0973, s * 2.86667, s * 12.9);
    path.lineTo(s * 2.86667, s * 32.9667);
    path.cubicTo(s * 2.86667, s * 33.7693, s * 3.49733, s * 34.4, s * 4.3, s * 34.4);
    path.lineTo(s * 15.7667, s * 34.4);
    path.cubicTo(s * 16.5693, s * 34.4, s * 17.2, s * 33.7693, s * 17.2, s * 32.9667);
    path.lineTo(s * 17.2, s * 25.3987);
    path.lineTo(s * 17.6013, s * 25.8);
    path.lineTo(s * 20.0667, s * 28.2653);
    path.lineTo(s * 20.0667, s * 37.2667);
    path.cubicTo(s * 20.0667, s * 40.42, s * 17.4867, s * 43.0, s * 14.3333, s * 43.0);
    path.lineTo(s * 5.73333, s * 43.0);
    path.cubicTo(s * 2.58, s * 43.0, s * 0.0, s * 40.42, s * 0.0, s * 37.2667);
    path.lineTo(s * 0.0, s * 11.4667);
    path.cubicTo(s * 0.0, s * 8.31333, s * 2.58, s * 5.73333, s * 5.73333, s * 5.73333);
    path.lineTo(s * 14.3333, s * 5.73333);
    path.cubicTo(s * 15.3653, s * 5.73333, s * 16.3687, s * 6.02, s * 17.2, s * 6.50733);
    path.lineTo(s * 17.2, s * 1.43333);
    path.cubicTo(s * 17.2, s * 0.630667, s * 17.8307, s * 0.0, s * 18.6333, s * 0.0);
    path.close();
    path.moveTo(s * 12.9, s * 37.2667);
    path.lineTo(s * 7.16667, s * 37.2667);
    path.cubicTo(s * 6.364, s * 37.2667, s * 5.73333, s * 37.8973, s * 5.73333, s * 38.7);
    path.cubicTo(s * 5.73333, s * 39.5027, s * 6.364, s * 40.1333, s * 7.16667, s * 40.1333);
    path.lineTo(s * 12.9, s * 40.1333);
    path.cubicTo(s * 13.7027, s * 40.1333, s * 14.3333, s * 39.5027, s * 14.3333, s * 38.7);
    path.cubicTo(s * 14.3333, s * 37.8973, s * 13.7027, s * 37.2667, s * 12.9, s * 37.2667);
    path.close();
    path.moveTo(s * 28.6953, s * 27.692);
    path.lineTo(s * 29.0107, s * 27.692);
    path.cubicTo(s * 30.702, s * 27.8067, s * 31.992, s * 29.2687, s * 31.8773, s * 30.96);
    path.cubicTo(s * 31.8487, s * 31.5333, s * 31.648, s * 32.1067, s * 31.304, s * 32.5653);
    path.lineTo(s * 31.132, s * 32.7947);
    path.cubicTo(s * 30.53, s * 33.4827, s * 29.6987, s * 33.8553, s * 28.8673, s * 33.9127);
    path.lineTo(s * 28.5233, s * 33.9127);
    path.cubicTo(s * 27.8067, s * 33.884, s * 27.09, s * 33.626, s * 26.488, s * 33.0813);
    path.lineTo(s * 26.2013, s * 32.7947);
    path.cubicTo(s * 25.112, s * 31.5333, s * 25.2267, s * 29.584, s * 26.488, s * 28.466);
    path.cubicTo(s * 26.9753, s * 28.036, s * 27.5773, s * 27.778, s * 28.208, s * 27.7207);
    path.cubicTo(s * 28.38, s * 27.692, s * 28.552, s * 27.692, s * 28.6953, s * 27.692);
    path.close();
    path.moveTo(s * 23.0193, s * 27.3767);
    path.lineTo(s * 22.5893, s * 27.778);
    path.lineTo(s * 21.8727, s * 27.0327);
    path.lineTo(s * 20.0667, s * 25.2267);
    path.lineTo(s * 19.1207, s * 24.2807);
    path.cubicTo(s * 19.2927, s * 24.1087, s * 19.4647, s * 23.9653, s * 19.608, s * 23.822);
    path.lineTo(s * 20.0667, s * 23.4207);
    path.cubicTo(s * 22.6519, s * 21.2711, s * 25.9483, s * 20.1672, s * 29.3067, s * 20.3264);
    path.cubicTo(s * 32.6651, s * 20.4856, s * 35.8423, s * 21.8962, s * 38.2127, s * 24.2807);
    path.lineTo(s * 34.744, s * 27.778);
    path.cubicTo(s * 33.1387, s * 26.144, s * 31.046, s * 25.3127, s * 28.9247, s * 25.2553);
    path.lineTo(s * 28.4087, s * 25.2553);
    path.cubicTo(s * 26.488, s * 25.3127, s * 24.5673, s * 26.0293, s * 23.0193, s * 27.3767);
    path.close();
    path.moveTo(s * 28.6667, s * 12.9);
    path.cubicTo(s * 34.056, s * 12.9287, s * 38.7287, s * 14.7347, s * 42.6847, s * 18.3467);
    path.cubicTo(s * 43.086, s * 18.7193, s * 43.1147, s * 19.3213, s * 42.742, s * 19.694);
    path.lineTo(s * 39.9327, s * 22.532);
    path.cubicTo(s * 37.1291, s * 19.6861, s * 33.3465, s * 18.0152, s * 29.3547, s * 17.8593);
    path.lineTo(s * 28.6667, s * 17.8307);
    path.cubicTo(s * 25.6853, s * 17.8307, s * 22.6753, s * 18.6907, s * 20.0667, s * 20.382);
    path.lineTo(s * 19.608, s * 20.6687);
    path.cubicTo(s * 18.834, s * 21.2133, s * 18.0887, s * 21.844, s * 17.4007, s * 22.532);
    path.lineTo(s * 14.62, s * 19.7513);
    path.cubicTo(s * 14.4586, s * 19.5924, s * 14.3585, s * 19.3815, s * 14.3375, s * 19.1559);
    path.cubicTo(s * 14.3165, s * 18.9304, s * 14.376, s * 18.7046, s * 14.5053, s * 18.5187);
    path.lineTo(s * 14.6487, s * 18.3467);
    path.cubicTo(s * 18.6047, s * 14.706, s * 23.2773, s * 12.8713, s * 28.6667, s * 12.9);
    path.close();

    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}



// ==========================================
// ENTRY POINT PPOB SCREEN
// ==========================================
class PpobScreen extends StatefulWidget {
  final int initialTab; // 0: Pulsa & Kuota, 1: Listrik PLN
  const PpobScreen({super.key, this.initialTab = 0});

  @override
  State<PpobScreen> createState() => _PpobScreenState();
}

class _PpobScreenState extends State<PpobScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.initialTab == 1) {
      return const ListrikScreen();
    }
    return const PulsaInputScreen();
  }
}

// ==========================================
// SCREEN 1: INPUT NOMOR HANDPHONE (Pulsa & Kuota)
// Sesuai Desain Figma: Header Ungu, Input Phonebook, Floating Check, Custom Keypad
// ==========================================
class PulsaInputScreen extends StatefulWidget {
  const PulsaInputScreen({super.key});

  @override
  State<PulsaInputScreen> createState() => _PulsaInputScreenState();
}

class _PulsaInputScreenState extends State<PulsaInputScreen> {
  String _phone = '';
  bool _isKeypadOpen = false;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleHardwareKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleHardwareKey);
    super.dispose();
  }

  // Dukungan input keyboard fisik laptop/PC & keypad layar HP
  bool _handleHardwareKey(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return false;

    final key = event.logicalKey;
    final char = event.character;

    // Backspace / Delete
    if (key == LogicalKeyboardKey.backspace || key == LogicalKeyboardKey.delete) {
      _onBackspace();
      return true;
    }

    // Angka 0-9
    if (char != null && RegExp(r'^[0-9]$').hasMatch(char)) {
      if (!_isKeypadOpen) {
        setState(() => _isKeypadOpen = true);
      }
      _onKeyPress(char);
      return true;
    }

    // Enter / Numpad Enter -> Lanjut ke katalog jika nomor tidak kosong
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
      if (_phone.isNotEmpty) {
        _goToCatalog();
      } else {
        setState(() => _isKeypadOpen = false);
      }
      return true;
    }

    // Escape -> Tutup keypad
    if (key == LogicalKeyboardKey.escape) {
      if (_isKeypadOpen) {
        setState(() => _isKeypadOpen = false);
        return true;
      }
    }

    return false;
  }

  void _onKeyPress(String val) {
    if (_phone.length >= 16) return;
    HapticFeedback.lightImpact();
    setState(() {
      _phone += val;
    });
  }

  void _onBackspace() {
    HapticFeedback.lightImpact();
    if (_phone.isNotEmpty) {
      setState(() {
        _phone = _phone.substring(0, _phone.length - 1);
      });
    }
  }

  void _goToCatalog() {
    HapticFeedback.mediumImpact();
    if (_phone.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Silakan masukkan nomor handphone terlebih dahulu',
            style: GoogleFonts.robotoSlab(),
          ),
          backgroundColor: const Color(0xFF52086B),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    setState(() {
      _isKeypadOpen = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PulsaCatalogScreen(phoneNumber: _phone),
      ),
    );
  }

  Widget _buildKeypadButton(String label, {VoidCallback? onTap, Widget? customChild}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: InkWell(
          onTap: onTap ?? () => _onKeyPress(label),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x18000000),
                  blurRadius: 3,
                  offset: Offset(0, 1.5),
                ),
              ],
            ),
            child: Center(
              child: customChild ??
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1C0823),
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isKeypadOpen,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_isKeypadOpen) {
          setState(() => _isKeypadOpen = false);
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFFD373FC),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF52086B), size: 28),
            onPressed: () {
              if (_isKeypadOpen) {
                setState(() => _isKeypadOpen = false);
                return;
              }
              Navigator.pop(context);
            },
          ),
          titleSpacing: 0,
          title: Text(
            'Pulsa & Paket Data',
            style: GoogleFonts.robotoSlab(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF52086B),
            ),
          ),
          centerTitle: false,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 18),
              child: Center(
                child: CustomPaint(
                  size: Size(26, 26),
                  painter: _PhoneWifiIconPainter(),
                ),
              ),
            ),
          ],
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (_isKeypadOpen) {
              setState(() => _isKeypadOpen = false);
            }
          },
          child: Column(
            children: [
              // Bagian Atas: Label & Input Nomor Handphone (Kotak Abu-Abu)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nomor Handphone',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1C0823),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Retangle Abu-Abu: Klik untuk buka/tutup keyboard
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          _isKeypadOpen = !_isKeypadOpen;
                        });
                      },
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFAEADAD),
                          borderRadius: BorderRadius.circular(10),
                          border: _isKeypadOpen
                              ? Border.all(color: const Color(0xFF52086B), width: 2)
                              : null,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0C000000),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.phone_android_rounded,
                              color: Color(0xFF1C0823),
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            // Garis ujung kiri hanya tampil saat nomor masih kosong.
                            // Saat mulai diisi angka, garis ini hilang digantikan angka yang diisi.
                            if (_phone.isEmpty) ...[
                              Container(
                                width: 1.5,
                                height: 22,
                                color: const Color(0xFF52086B),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      _phone.isEmpty ? 'Masukan Nomor Handphone' : _phone,
                                      style: GoogleFonts.robotoSlab(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: _phone.isEmpty
                                            ? const Color(0xFF4A4A4A)
                                            : const Color(0xFF1C0823),
                                        letterSpacing: 0.5,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // Kursor indikator aktif saat keyboard terbuka
                                  if (_isKeypadOpen)
                                    Container(
                                      width: 2,
                                      height: 20,
                                      margin: const EdgeInsets.only(left: 3),
                                      color: const Color(0xFF52086B),
                                    ),
                                ],
                              ),
                            ),
                            if (_phone.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    _phone = '';
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  child: Icon(Icons.cancel, color: Color(0xFF52086B), size: 18),
                                ),
                              ),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  _phone = '085189898989';
                                  _isKeypadOpen = true;
                                });
                              },
                              child: _buildContactBookIcon(width: 22, height: 24),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Tombol Melayang Ceklis Ungu di Atas Keypad (Persis Desain Figma)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, bottom: 12),
                  child: InkWell(
                    onTap: _goToCatalog,
                    borderRadius: BorderRadius.circular(26),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: Color(0xFFCA31FF),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x60CA31FF),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.check, color: Colors.white, size: 28),
                      ),
                    ),
                  ),
                ),
              ),

              // Custom Numeric Keypad 4x4 (Muncul saat kotak abu-abu diklik)
              if (_isKeypadOpen)
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D9D9),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            _buildKeypadButton('1'),
                            _buildKeypadButton('2'),
                            _buildKeypadButton('3'),
                            _buildKeypadButton('-', onTap: () => _onKeyPress('-')),
                          ],
                        ),
                        Row(
                          children: [
                            _buildKeypadButton('4'),
                            _buildKeypadButton('5'),
                            _buildKeypadButton('6'),
                            _buildKeypadButton(
                              '_',
                              onTap: _onBackspace,
                              customChild: const Icon(Icons.remove, color: Color(0xFF1C0823), size: 22),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _buildKeypadButton('7'),
                            _buildKeypadButton('8'),
                            _buildKeypadButton('9'),
                            _buildKeypadButton(
                              '⌫',
                              onTap: _onBackspace,
                              customChild: const Icon(Icons.backspace_outlined, color: Color(0xFF1C0823), size: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _buildKeypadButton(',', onTap: () => _onKeyPress(',')),
                            _buildKeypadButton('0'),
                            _buildKeypadButton('.', onTap: () => _onKeyPress('.')),
                            _buildKeypadButton(
                              '✓',
                              onTap: _goToCatalog,
                              customChild: const Icon(Icons.check, color: Color(0xFF1C0823), size: 24),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              if (!_isKeypadOpen)
                const SafeArea(
                  top: false,
                  child: SizedBox(height: 8),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 2: CATALOG PULSA & KUOTA (Figma: Pulsa & Kuota)
// Tab Pulsa / Paket Data, Telkomsel Logo, 8 Card Nominal, Touch Animation
// ==========================================
class PulsaCatalogScreen extends StatefulWidget {
  final String phoneNumber;
  final int initialTab; // 0: Pulsa, 1: Paket Data

  const PulsaCatalogScreen({
    super.key,
    required this.phoneNumber,
    this.initialTab = 0,
  });

  @override
  State<PulsaCatalogScreen> createState() => _PulsaCatalogScreenState();
}

class _PulsaCatalogScreenState extends State<PulsaCatalogScreen> {
  int _selectedTab = 0; // 0: Pulsa, 1: Paket Data
  late String _currentPhone;
  bool _isKeypadOpen = false;

  // Daftar Nominal Pulsa Telkomsel (8 Pilihan)
  final List<Map<String, dynamic>> _pulsaItems = [
    {'title': '15.000', 'badge': '', 'subtitle': 'Masa aktif 30 hari', 'price': 'Rp16.500', 'basePrice': 16500},
    {'title': '25.000', 'badge': '', 'subtitle': 'Masa aktif 30 hari', 'price': 'Rp26.500', 'basePrice': 26500},
    {'title': '50.000', 'badge': '', 'subtitle': 'Masa aktif 45 hari', 'price': 'Rp50.500', 'basePrice': 50500},
    {'title': '100.000', 'badge': '', 'subtitle': 'Masa aktif 60 hari', 'price': 'Rp99.000', 'basePrice': 99000},
    {'title': '150.000', 'badge': '', 'subtitle': 'Masa aktif 75 hari', 'price': 'Rp148.500', 'basePrice': 148500},
    {'title': '200.000', 'badge': '', 'subtitle': 'Masa aktif 90 hari', 'price': 'Rp198.000', 'basePrice': 198000},
    {'title': '300.000', 'badge': '', 'subtitle': 'Masa aktif 120 hari', 'price': 'Rp297.000', 'basePrice': 297000},
    {'title': '500.000', 'badge': '', 'subtitle': 'Masa aktif 150 hari', 'price': 'Rp495.000', 'basePrice': 495000},
  ];

  // Daftar Paket Data Kuota Telkomsel (8 Pilihan)
  final List<Map<String, dynamic>> _kuotaItems = [
    {'title': '50rb', 'badge': '14 GB', 'subtitle': 'Berlaku untuk 30 hari', 'price': 'Rp52.000', 'basePrice': 52000},
    {'title': '50rb', 'badge': '15 GB', 'subtitle': 'Berlaku untuk 7 hari', 'price': 'Rp51.500', 'basePrice': 51500},
    {'title': '35rb', 'badge': '5 GB', 'subtitle': 'Berlaku untuk 7 hari', 'price': 'Rp37.000', 'basePrice': 37000},
    {'title': '50rb', 'badge': '15 GB', 'subtitle': 'Berlaku untuk 7 hari', 'price': 'Rp51.500', 'basePrice': 51500},
    {'title': '30rb', 'badge': '12 GB', 'subtitle': 'Berlaku untuk 14 hari', 'price': 'Rp31.000', 'basePrice': 31000},
    {'title': '50rb', 'badge': '15 GB', 'subtitle': 'Berlaku untuk 7 hari', 'price': 'Rp51.500', 'basePrice': 51500},
    {'title': '10rb', 'badge': '3 GB', 'subtitle': 'Berlaku untuk 3 hari', 'price': 'Rp12.500', 'basePrice': 12500},
    {'title': '20rb', 'badge': '8 GB', 'subtitle': 'Berlaku untuk 7 hari', 'price': 'Rp25.500', 'basePrice': 25500},
  ];

  @override
  void initState() {
    super.initState();
    _currentPhone = widget.phoneNumber;
    _selectedTab = widget.initialTab;
    HardwareKeyboard.instance.addHandler(_handleHardwareKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleHardwareKey);
    super.dispose();
  }

  bool _handleHardwareKey(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return false;
    final key = event.logicalKey;
    final char = event.character;

    if (key == LogicalKeyboardKey.backspace || key == LogicalKeyboardKey.delete) {
      _onKeypadDelete();
      return true;
    }
    if (char != null && RegExp(r'^[0-9]$').hasMatch(char)) {
      if (!_isKeypadOpen) {
        setState(() => _isKeypadOpen = true);
      }
      _onKeypadDigit(char);
      return true;
    }
    if (key == LogicalKeyboardKey.escape || key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
      if (_isKeypadOpen) {
        setState(() => _isKeypadOpen = false);
        return true;
      }
    }
    return false;
  }

  void _onKeypadDigit(String digit) {
    if (_currentPhone.length >= 16) return;
    HapticFeedback.lightImpact();
    setState(() {
      _currentPhone += digit;
    });
  }

  void _onKeypadDelete() {
    HapticFeedback.lightImpact();
    if (_currentPhone.isNotEmpty) {
      setState(() {
        _currentPhone = _currentPhone.substring(0, _currentPhone.length - 1);
      });
    }
  }

  Widget _buildKeypadButton(String label, {VoidCallback? onTap, Widget? customChild}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: InkWell(
          onTap: onTap ?? () => _onKeypadDigit(label),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x18000000),
                  blurRadius: 3,
                  offset: Offset(0, 1.5),
                ),
              ],
            ),
            child: Center(
              child: customChild ??
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1C0823),
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSelectItem(Map<String, dynamic> item) {
    if (_currentPhone.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Silakan masukkan nomor handphone terlebih dahulu',
            style: GoogleFonts.robotoSlab(),
          ),
          backgroundColor: const Color(0xFF52086B),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() => _isKeypadOpen = false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PulsaKonfirmasiScreen(
          phoneNumber: _currentPhone,
          isKuota: _selectedTab == 1,
          title: item['title'] as String,
          badge: item['badge'] as String,
          subtitle: item['subtitle'] as String,
          priceFormatted: item['price'] as String,
          basePrice: item['basePrice'] as int,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentItems = _selectedTab == 0 ? _pulsaItems : _kuotaItems;

    return PopScope(
      canPop: !_isKeypadOpen,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_isKeypadOpen) {
          setState(() => _isKeypadOpen = false);
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFFD373FC),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF52086B), size: 28),
            onPressed: () {
              if (_isKeypadOpen) {
                setState(() => _isKeypadOpen = false);
                return;
              }
              Navigator.pop(context);
            },
          ),
          titleSpacing: 0,
          title: Text(
            'Pulsa & Paket Data',
            style: GoogleFonts.robotoSlab(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF52086B),
            ),
          ),
          centerTitle: false,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 18),
              child: Center(
                child: CustomPaint(
                  size: Size(26, 26),
                  painter: _PhoneWifiIconPainter(),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _isKeypadOpen
            ? Container(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x18000000),
                      blurRadius: 6,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          _buildKeypadButton('1'),
                          _buildKeypadButton('2'),
                          _buildKeypadButton('3'),
                          _buildKeypadButton('-', onTap: () => _onKeypadDigit('-')),
                        ],
                      ),
                      Row(
                        children: [
                          _buildKeypadButton('4'),
                          _buildKeypadButton('5'),
                          _buildKeypadButton('6'),
                          _buildKeypadButton(
                            '_',
                            onTap: _onKeypadDelete,
                            customChild: const Icon(Icons.remove, color: Color(0xFF1C0823), size: 22),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildKeypadButton('7'),
                          _buildKeypadButton('8'),
                          _buildKeypadButton('9'),
                          _buildKeypadButton(
                            '⌫',
                            onTap: _onKeypadDelete,
                            customChild: const Icon(Icons.backspace_outlined, color: Color(0xFF1C0823), size: 20),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildKeypadButton(',', onTap: () => _onKeypadDigit(',')),
                          _buildKeypadButton('0'),
                          _buildKeypadButton('.', onTap: () => _onKeypadDigit('.')),
                          _buildKeypadButton(
                            '✓',
                            onTap: () => setState(() => _isKeypadOpen = false),
                            customChild: const Icon(Icons.check, color: Color(0xFF1C0823), size: 24),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : null,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (_isKeypadOpen) {
              setState(() => _isKeypadOpen = false);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label "Nomor Handphone"
                Text(
                  'Nomor Handphone',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1C0823),
                  ),
                ),
                const SizedBox(height: 8),

                // Card Nomor Handphone dengan Logo Telkomsel (Kotak Abu-Abu Interaktif & Bisa Diedit)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      _isKeypadOpen = !_isKeypadOpen;
                    });
                  },
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFAEADAD), // Retangle abu-abu persis permintaan user
                      borderRadius: BorderRadius.circular(10),
                      border: _isKeypadOpen
                          ? Border.all(color: const Color(0xFF52086B), width: 2)
                          : null,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 4,
                          offset: Offset(0, 1.5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _buildTelkomselLogo(size: 30),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  _currentPhone.isEmpty ? 'Masukan Nomor Handphone' : _currentPhone,
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: _currentPhone.isEmpty
                                        ? const Color(0xFF4A4A4A)
                                        : const Color(0xFF000000),
                                    letterSpacing: 0.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (_isKeypadOpen)
                                Container(
                                  width: 2,
                                  height: 20,
                                  margin: const EdgeInsets.only(left: 3),
                                  color: const Color(0xFF52086B),
                                ),
                            ],
                          ),
                        ),
                        if (_currentPhone.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              setState(() {
                                _currentPhone = '';
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(Icons.cancel, color: Color(0xFF52086B), size: 19),
                            ),
                          ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _currentPhone = '085189898989';
                              _isKeypadOpen = true;
                            });
                          },
                          child: _buildContactBookIcon(width: 22, height: 24),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Tab Switcher: Pulsa | Paket Data (Persis Desain Figma)
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1.0,
                        color: const Color(0xFFE0E0E0),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _selectedTab = 0),
                            child: Column(
                              children: [
                                Text(
                                  'Pulsa',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 17,
                                    fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.w500,
                                    color: _selectedTab == 0 ? const Color(0xFF000000) : const Color(0xFF8E8E8E),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: 52,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: _selectedTab == 0 ? const Color(0xFFCA31FF) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _selectedTab = 1),
                            child: Column(
                              children: [
                                Text(
                                  'Paket Data',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 17,
                                    fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.w500,
                                    color: _selectedTab == 1 ? const Color(0xFF000000) : const Color(0xFF8E8E8E),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: 86,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: _selectedTab == 1 ? const Color(0xFFCA31FF) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Label "Pilih Nominal"
                Text(
                  'Pilih Nominal',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 12),

                // 8 Card Nominal 2-Kolom dengan Animasi Sentuh Interaktif
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: currentItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 153 / 110, // Layout W153 H110 persis Figma
                  ),
                  itemBuilder: (context, index) {
                    final item = currentItems[index];
                    return _PulsaInteractiveCard(
                      item: item,
                      isKuota: _selectedTab == 1,
                      onTap: () => _onSelectItem(item),
                    );
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// INTERACTIVE NOMINAL CARD (PULSA & KUOTA)
// Animasi hover/tap lembut, badge masa aktif / kuota, border stroke Figma
// ==========================================
class _PulsaInteractiveCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isKuota;
  final VoidCallback onTap;

  const _PulsaInteractiveCard({
    required this.item,
    required this.isKuota,
    required this.onTap,
  });

  @override
  State<_PulsaInteractiveCard> createState() => _PulsaInteractiveCardState();
}

class _PulsaInteractiveCardState extends State<_PulsaInteractiveCard> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final title = widget.item['title'] as String;
    final badge = widget.item['badge'] as String;
    final subtitle = widget.item['subtitle'] as String;
    final price = widget.item['price'] as String;

    final double scale = _isPressed ? 0.96 : (_isHovered ? 1.02 : 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF2FF), // Warna card persis Figma (#FBF2FF)
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (_isPressed || _isHovered) ? const Color(0xFFCA31FF) : const Color(0xFFC5C3C8),
                width: (_isPressed || _isHovered) ? 1.8 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: (_isPressed || _isHovered) ? const Color(0x28CA31FF) : const Color(0x06000000),
                  blurRadius: (_isPressed || _isHovered) ? 8 : 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Baris Atas: Nominal Utama (Ukuran 32) & Badge Top-Right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          style: GoogleFonts.robotoSlab(
                            fontSize: 32, // Ukuran title 32 persis permintaan
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF000000),
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 58,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF827979),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          badge,
                          style: GoogleFonts.robotoSlab(
                            fontSize: 14, // Pon 14 persis permintaan
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Keterangan Subtitle Jika Paket Data (contoh: "Berlaku untuk 3 hari") - Dibuat lebih terang & jelas kontras
                if (widget.isKuota && subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: GoogleFonts.robotoSlab(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF222222),
                    ),
                  ),

                // Baris Bawah: Harga
                Text(
                  price,
                  style: GoogleFonts.robotoSlab(
                    fontSize: 15, // Ukuran font harga 15 persis permintaan
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1C0823),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// CUSTOM DASHED DIVIDER FIGMA
// ==========================================
class _DashedDivider extends StatelessWidget {
  final Color color;
  final double height;
  final double dashWidth;
  final double dashSpace;

  const _DashedDivider({
    this.color = const Color(0xFFC0C0C0),
    this.height = 1.0,
    this.dashWidth = 5.0,
    this.dashSpace = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _DashedLinePainter(
          color: color,
          dashWidth: dashWidth,
          dashSpace: dashSpace,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const _DashedLinePainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.height
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// SCREEN 3: KONFIRMASI PULSA / PAKET DATA (Figma: Pulsa 1 & Kuota 1)
// Card Informasi Pelanggan & Detail Pembayaran Ber-Stroke Halus, Tombol Konfirmasi
// ==========================================
class PulsaKonfirmasiScreen extends StatelessWidget {
  final String phoneNumber;
  final bool isKuota;
  final String title;
  final String badge;
  final String subtitle;
  final String priceFormatted;
  final int basePrice;

  const PulsaKonfirmasiScreen({
    super.key,
    required this.phoneNumber,
    required this.isKuota,
    required this.title,
    required this.badge,
    required this.subtitle,
    required this.priceFormatted,
    required this.basePrice,
  });

  static Widget _buildDetailRow(
    String label,
    String value, {
    double fontSize = 16,
    FontWeight labelWeight = FontWeight.w400,
    FontWeight valueWeight = FontWeight.bold,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoSlab(
            fontSize: fontSize,
            fontWeight: labelWeight,
            color: const Color(0xFF444444),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.robotoSlab(
            fontSize: fontSize,
            fontWeight: valueWeight,
            color: const Color(0xFF000000),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const int adminFee = 1500;
    final int totalPrice = basePrice + adminFee;
    final String formattedTotal = 'Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD373FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF52086B), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Text(
          'Pulsa & Paket Data',
          style: GoogleFonts.robotoSlab(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF52086B),
          ),
        ),
        centerTitle: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: Center(
              child: CustomPaint(
                size: Size(26, 26),
                painter: _PhoneWifiIconPainter(),
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Label "Nomor Handphone"
                          Text(
                            'Nomor Handphone',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF555555),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Card Nomor Handphone dengan Logo Telkomsel, Clear Icon & Icon Contact (Persis Figma)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFD0D0D0), width: 1.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x08000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 1.5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                _buildTelkomselLogo(size: 30),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    phoneNumber,
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                ),
                                const _ClearXCircleIcon(size: 19),
                                const SizedBox(width: 14),
                                _buildContactBookIcon(width: 22, height: 24),
                              ],
                            ),
                          ),

                          const SizedBox(height: 56),

                          // Tab Teks Status (Pulsa atau Paket Data)
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Positioned(
                                bottom: 0,
                                left: -16,
                                right: -16,
                                child: Container(
                                  height: 1.5,
                                  color: const Color(0xFFBDBDBD), // Garis lebih terang & jelas persis Figma
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Pulsa',
                                          style: GoogleFonts.robotoSlab(
                                            fontSize: 16.5,
                                            fontWeight: !isKuota ? FontWeight.bold : FontWeight.w500,
                                            color: !isKuota ? const Color(0xFF000000) : const Color(0xFF8E8E8E),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          width: 36,
                                          height: 3,
                                          decoration: BoxDecoration(
                                            color: !isKuota ? const Color(0xFFCA31FF) : Colors.transparent,
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Paket Data',
                                          style: GoogleFonts.robotoSlab(
                                            fontSize: 16.5,
                                            fontWeight: isKuota ? FontWeight.bold : FontWeight.w500,
                                            color: isKuota ? const Color(0xFF000000) : const Color(0xFF8E8E8E),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          width: 78,
                                          height: 3,
                                          decoration: BoxDecoration(
                                            color: isKuota ? const Color(0xFFCA31FF) : Colors.transparent,
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // WHITE SHEET CONTAINER PERSIS FIGMA
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x0A000000),
                              blurRadius: 10,
                              offset: Offset(0, -3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(0, 34, 0, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SECTION 1: INFORMASI PELANGGAN
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Informasi Pelanggan',
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 24, // pon Informasi Pelanggan itu 24
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  _buildDetailRow('Nomor Ponsel', phoneNumber, fontSize: 16),
                                  const SizedBox(height: 16),
                                  if (!isKuota) ...[
                                    _buildDetailRow(
                                      'Nominal Pulsa',
                                      'Rp ${basePrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                    ),
                                  ] else ...[
                                    _buildDetailRow('Voucher Telkomsel', badge),
                                    const SizedBox(height: 16),
                                    _buildDetailRow('Masa Aktif', subtitle.isNotEmpty ? subtitle : '30 hari'),
                                  ],
                                ],
                              ),
                            ),

                            // SOLID GREY DIVIDER LEBAR & ABU-ABU PERSIS FIGMA (Lebar 7px, abu-abu 0xFFD9D9D9, full-width)
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              height: 7.0,
                              color: const Color(0xFFD9D9D9),
                            ),
                            const SizedBox(height: 22),

                            // SECTION 2: DETAIL PEMBAYARAN & TOTAL
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Detail Pembayaran',
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  _buildDetailRow(
                                    isKuota ? 'Harga Voucher' : 'Harga Pulsa',
                                    'Rp ${basePrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                  ),
                                  const SizedBox(height: 14),
                                  _buildDetailRow('Biaya Admin', 'Rp 1.500'),
                                  const SizedBox(height: 14),
                                  _buildDetailRow('Total Transaksi', formattedTotal),

                                  // DASHED DIVIDER PERSIS FIGMA
                                  const SizedBox(height: 20),
                                  const _DashedDivider(color: Color(0xFFC0C0C0), height: 1.0, dashWidth: 5.0, dashSpace: 4.0),
                                  const SizedBox(height: 22),

                                  // SECTION 3: TOTAL PEMBAYARAN (Font size 24 persis permintaan)
                                  Text(
                                    'Total Pembayaran',
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 24, // pon Total Pembayaran itu 24
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                  const SizedBox(height: 22),
                                  Text(
                                    formattedTotal,
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),

                                  const SizedBox(height: 18),

                                  // TOMBOL KONFIRMASI PILL CENTERED (Persis Figma W188 H46)
                                  Align(
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: () {
                                        HapticFeedback.mediumImpact();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PinPulsaScreen(
                                              phoneNumber: phoneNumber,
                                              isKuota: isKuota,
                                              title: title,
                                              badge: badge,
                                              priceFormatted: priceFormatted,
                                              totalFormatted: formattedTotal,
                                            ),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(23),
                                      child: Container(
                                        width: 188,
                                        height: 46,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFCA31FF),
                                          borderRadius: BorderRadius.circular(23),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x50CA31FF),
                                              blurRadius: 8,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Konfirmasi',
                                            style: GoogleFonts.robotoSlab(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 28),
                                ],
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
          );
        }
      ),
    );
  }
}

// ==========================================
// SCREEN 4: PIN PULSA / PAKET DATA (Figma: Pin pulsa & PIN KUOTA)
// ==========================================

// ==========================================
// KEYPAD BUTTON DENGAN ANIMASI SENTUHAN KEYBOARD
// ==========================================
class _PinKeyButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _PinKeyButton({
    required this.label,
    required this.onTap,
  });

  @override
  State<_PinKeyButton> createState() => _PinKeyButtonState();
}

class _PinKeyButtonState extends State<_PinKeyButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) {
            HapticFeedback.lightImpact();
            setState(() => _isPressed = true);
          },
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _isPressed ? 0.88 : 1.0,
            duration: const Duration(milliseconds: 80),
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 80),
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isPressed ? const Color(0x18000000) : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  widget.label,
                  style: GoogleFonts.robotoSlab(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PinCheckButton extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _PinCheckButton({
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<_PinCheckButton> createState() => _PinCheckButtonState();
}

class _PinCheckButtonState extends State<_PinCheckButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      onLongPress: widget.onLongPress,
      child: AnimatedScale(
        scale: _isPressed ? 0.88 : 1.0,
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeInOut,
        child: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFCA31FF),
          ),
          child: const Center(
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class PinPulsaScreen extends StatefulWidget {
  final String phoneNumber;
  final bool isKuota;
  final String title;
  final String badge;
  final String priceFormatted;
  final String totalFormatted;

  const PinPulsaScreen({
    super.key,
    required this.phoneNumber,
    required this.isKuota,
    required this.title,
    required this.badge,
    required this.priceFormatted,
    required this.totalFormatted,
  });

  @override
  State<PinPulsaScreen> createState() => _PinPulsaScreenState();
}

class _PinPulsaScreenState extends State<PinPulsaScreen> {
  String _pin = '';

  void _onKeyPress(String val) {
    if (_pin.length < 6) {
      HapticFeedback.lightImpact();
      setState(() => _pin += val);
      if (_pin.length == 6) {
        _submitPin();
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  void _submitPin() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BuktiTransaksiPulsaScreen(
          phoneNumber: widget.phoneNumber,
          isKuota: widget.isKuota,
          title: widget.title,
          badge: widget.badge,
          priceFormatted: widget.priceFormatted,
          totalFormatted: widget.totalFormatted,
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String label, {VoidCallback? onTap}) {
    return _PinKeyButton(
      label: label,
      onTap: onTap ?? () => _onKeyPress(label),
    );
  }

  Widget _buildKeypadRow(List<String> values) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: values.map((val) => _buildKeypadButton(val)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar dengan Tombol Back Melingkar Hitam Persis Figma
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 12, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF000000), width: 2.0),
                    ),
                    child: const Center(
                      child: Icon(Icons.arrow_back, color: Color(0xFF000000), size: 20),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Icon Kunci Ungu Kotak Membulat dengan Watermark Dompet Faint di Belakangnya (Persis Figma)
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: -20,
                  top: -16,
                  child: const CustomPaint(
                    size: Size(110, 88),
                    painter: _XemaWalletExactPainter(
                      strokeColor: Color(0x30E0B0FF),
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C0823),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x20000000),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: CustomPaint(
                      size: Size(44, 30),
                      painter: _HorizontalKeyPainter(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Judul "Konfirmasi PIN" (Font Poppins Bold Persis Figma)
            Text(
              'Konfirmasi PIN',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF000000),
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle (Font Poppins Persis Figma)
            Text(
              'Masukkan 6-digit PIN Trasaksi kamu',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF555555),
              ),
            ),

            const SizedBox(height: 48),

            // Indikator 6 Bulatan PIN (Warna Hitam saat sudah disentuh/diisi persis instruksi)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                final isFilled = index < _pin.length;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.symmetric(horizontal: 6.5),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? const Color(0xFF000000) : const Color(0xFFD9D9D9),
                  ),
                );
              }),
            ),

            const Spacer(),

            // Custom Keypad (Font RobotoSlab Bold & Tombol Checkmark Persis Figma)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildKeypadRow(['1', '2', '3']),
                  const SizedBox(height: 28),
                  _buildKeypadRow(['4', '5', '6']),
                  const SizedBox(height: 28),
                  _buildKeypadRow(['7', '8', '9']),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Expanded(child: SizedBox(height: 52)),
                      _buildKeypadButton('0'),
                      Expanded(
                        child: Center(
                          child: _PinCheckButton(
                            onTap: () {
                              if (_pin.length == 6) {
                                _submitPin();
                              } else if (_pin.isNotEmpty) {
                                _onBackspace();
                              }
                            },
                            onLongPress: () {
                              HapticFeedback.lightImpact();
                              setState(() => _pin = '');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 5: BUKTI TRANSAKSI PULSA / PAKET DATA (Figma: Bukti transaksi Pulsa & Kuota)
// ==========================================
class BuktiTransaksiPulsaScreen extends StatelessWidget {
  final String phoneNumber;
  final bool isKuota;
  final String title;
  final String badge;
  final String priceFormatted;
  final String totalFormatted;

  const BuktiTransaksiPulsaScreen({
    super.key,
    required this.phoneNumber,
    required this.isKuota,
    required this.title,
    required this.badge,
    required this.priceFormatted,
    required this.totalFormatted,
  });

  static Widget _buildReceiptRow(String label, String value, {double fontSize = 16}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoSlab(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF000000),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.robotoSlab(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cleanPrice = priceFormatted.replaceFirst('Rp', '').trim();
    final formattedHarga = 'Rp $cleanPrice';

    final cleanTotal = totalFormatted.replaceFirst('Rp', '').trim();
    final formattedTotal = 'Rp $cleanTotal';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Header Ungu Persis Figma (Node 569:386 / 569:392)
          Container(
            height: 220,
            width: double.infinity,
            color: const Color(0xFFD373FC),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Column(
                children: [
                  // Icon Share di Pojok Kanan Atas Header Ungu (Putih Persis Figma)
                  Padding(
                    padding: const EdgeInsets.only(right: 6, top: 4),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tautan struk bukti transaksi berhasil disalin!')),
                          );
                        },
                        child: Image.memory(
                          base64Decode(_shareFigmaBase64),
                          width: 24,
                          height: 26,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Terompet Pesta Party Popper Putih di Tengah Header Ungu (Geser ke kanan sedikit sesuai instruksi)
                  Center(
                    child: Transform.translate(
                      offset: const Offset(12, 0),
                      child: Image.memory(
                        base64Decode(_tightPartyPopperBase64),
                        width: 113,
                        height: 105,
                        fit: BoxFit.fill,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // KARTU STRUK BUKTI TRANSAKSI (Sesuai Desain Figma: Warna Lembut #F6E2FE, Stroke Halus)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6E2FE),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFECC2FE), width: 1.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x4DCA31FF),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Color(0x18000000),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // SECTION 1: HEADER STRUK DENGAN CHECKMARK & DETAIL NO TUJUAN
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 24, 18, 0),
                          child: Column(
                            children: [
                              // Icon Ceklis Putih Lingkaran Ungu Besar Persis Figma (Diameter 67x67)
                              Container(
                                width: 67,
                                height: 67,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFCA31FF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(Icons.check, color: Colors.white, size: 42),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Judul "Bukti Transaksi" (pon 24 persis instruksi)
                              Text(
                                'Bukti Transaksi',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 24, // kata bukti transaksi itu pon nya 24
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 28),

                              _buildReceiptRow('Nomor Referensi', '45499730898', fontSize: 14),
                              const SizedBox(height: 8),
                              _buildReceiptRow('Tanggal Transaksi', '1 Okt 2026  09:18:67 WIB', fontSize: 14),
                              const SizedBox(height: 8),
                              _buildReceiptRow('Nomor Tujuan:', phoneNumber, fontSize: 14),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),

                        // GARIS PEMISAH FULL-WIDTH EDGE TO EDGE (Stroke persis Figma)
                        const Divider(color: Color(0xFFDCC4E8), thickness: 1.2, height: 1.2),

                        // SECTION 2: SUKSES DENGAN GLOW SHADOW & RINCIAN PRODUK / SN
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 28, 18, 0),
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  'SUKSES!',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFCA31FF),
                                    letterSpacing: 0.8,
                                    shadows: const [
                                      Shadow(
                                        color: Color(0x60CA31FF),
                                        blurRadius: 10,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 36),
                              _buildReceiptRow('Produk', isKuota ? 'Kuota Telkomsel $badge' : 'Pulsa Telkomsel $title'),
                              const SizedBox(height: 8),
                              _buildReceiptRow('SN', '089384756182'),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),

                        // GARIS PEMISAH FULL-WIDTH EDGE TO EDGE
                        const Divider(color: Color(0xFFDCC4E8), thickness: 1.2, height: 1.2),

                        // SECTION 3: RINCIAN HARGA & BIAYA ADMIN
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 22, 18, 0),
                          child: Column(
                            children: [
                              _buildReceiptRow('Harga', formattedHarga),
                              const SizedBox(height: 8),
                              _buildReceiptRow('Biaya Admin', 'Rp 1.500'),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),

                        // GARIS PEMISAH FULL-WIDTH EDGE TO EDGE
                        const Divider(color: Color(0xFFDCC4E8), thickness: 1.2, height: 1.2),

                        // SECTION 4: ROW TOTAL
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TOTAL',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                formattedTotal,
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // TOMBOL "OK" DI DASAR LAYAR (KEMBALI KE BERANDA, DIMENSI & BENTUK PERSIS FIGMA)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: _AnimatedOkButton(
                      height: 44,
                      borderRadius: 22,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const BerandaScreen()),
                          (route) => false,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ==========================================
// SCREEN 1: LISTRIK (PLN.png & MASUK NO METER.png)
// ==========================================

// ==========================================
// SCREEN 1: LISTRIK (Node 1348-1868 / Foto 2)
// ==========================================
// ==========================================
// ANIMATED NOMINAL CARD (Hover, Touch, Selected Animation)
// Sesuai Figma & Foto User: Border 2.5px #CA31FF, Glowing Shadow, Tactile Scale
// ==========================================
class _AnimatedNominalCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;

  const _AnimatedNominalCard({
    required this.item,
    required this.isSelected,
    this.isEnabled = true,
    required this.onTap,
  });

  @override
  State<_AnimatedNominalCard> createState() => _AnimatedNominalCardState();
}

class _AnimatedNominalCardState extends State<_AnimatedNominalCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isActive = widget.isEnabled && (_isHovered || _isPressed || widget.isSelected);

    return MouseRegion(
      cursor: widget.isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) {
        if (widget.isEnabled) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (widget.isEnabled) setState(() => _isHovered = false);
      },
      child: GestureDetector(
        onTapDown: (_) {
          if (widget.isEnabled) setState(() => _isPressed = true);
        },
        onTapUp: (_) {
          if (widget.isEnabled) setState(() => _isPressed = false);
        },
        onTapCancel: () {
          if (widget.isEnabled) setState(() => _isPressed = false);
        },
        onTap: () {
          if (widget.isEnabled) {
            HapticFeedback.lightImpact();
          }
          widget.onTap();
        },
        child: AnimatedOpacity(
          opacity: widget.isEnabled ? 1.0 : 0.65,
          duration: const Duration(milliseconds: 200),
          child: AnimatedScale(
            scale: widget.isEnabled && _isPressed ? 0.96 : (widget.isEnabled && _isHovered ? 1.025 : 1.0),
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFF0D0FF) : const Color(0xFFF3D8FF),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFFCA31FF),
                  width: isActive ? 2.5 : 1.0,
                ),
                boxShadow: isActive
                    ? const [
                        BoxShadow(
                          color: Color(0x66CA31FF), // Glowing vibrant purple shadow
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ]
                    : const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.item['nominal'],
                    style: GoogleFonts.poltawskiNowy(
                      textStyle: const TextStyle(fontFamily: 'PoltawskiNowy'),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 3),
                  if (widget.item['hasDiscount']) ...[
                    Text(
                      widget.item['original'],
                      style: GoogleFonts.poltawskiNowy(
                        textStyle: const TextStyle(fontFamily: 'PoltawskiNowy'),
                        fontSize: 11,
                        color: const Color(0xFF9C9C9C),
                        decoration: TextDecoration.lineThrough,
                        decorationColor: const Color(0xFF9C9C9C),
                      ),
                    ),
                  ],
                  Text(
                    widget.item['discount'],
                    style: GoogleFonts.poltawskiNowy(
                      textStyle: const TextStyle(fontFamily: 'PoltawskiNowy'),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListrikScreen extends StatefulWidget {
  final bool isEmbedded;
  const ListrikScreen({super.key, this.isEmbedded = false});

  @override
  State<ListrikScreen> createState() => _ListrikScreenState();
}

class _ListrikScreenState extends State<ListrikScreen> {
  final TextEditingController _meterController = TextEditingController();
  final FocusNode _meterFocusNode = FocusNode();
  int _selectedType = 0; // 0: Token, 1: Tagihan
  bool _showCustomKeypad = false; // Keypad hanya muncul setelah 'Masukan ID PEL' ditekan
  String? _selectedNominal; // Nominal token yang dipilih

  final List<Map<String, dynamic>> _denominations = [
    {
      'nominal': '20.000',
      'original': 'Rp20.000',
      'discount': 'Rp19.000',
      'numericPrice': 19000,
      'hasDiscount': true,
    },
    {
      'nominal': '50.000',
      'original': 'Rp50.000',
      'discount': 'Rp49.000',
      'numericPrice': 49000,
      'hasDiscount': true,
    },
    {
      'nominal': '100.000',
      'original': 'Rp100.000',
      'discount': 'Rp99.000',
      'numericPrice': 99000,
      'hasDiscount': true,
    },
    {
      'nominal': '200.000',
      'original': 'Rp200.000',
      'discount': 'Rp199.000',
      'numericPrice': 199000,
      'hasDiscount': true,
    },
    {
      'nominal': '500.000',
      'original': 'Rp500.000',
      'discount': 'Rp499.000',
      'numericPrice': 499000,
      'hasDiscount': true,
    },
    {
      'nominal': '1.000.000',
      'original': '',
      'discount': 'Rp1.000.000',
      'numericPrice': 1000000,
      'hasDiscount': false,
    },
    {
      'nominal': '5.000.000',
      'original': '',
      'discount': 'Rp5.000.000',
      'numericPrice': 5000000,
      'hasDiscount': false,
    },
    {
      'nominal': '10.000.000',
      'original': '',
      'discount': 'Rp10.000.000',
      'numericPrice': 10000000,
      'hasDiscount': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _meterController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _meterController.dispose();
    _meterFocusNode.dispose();
    super.dispose();
  }

  void _onKeypadTap(String value) {
    HapticFeedback.lightImpact();
    setState(() {
      _meterController.text += value;
    });
  }

  void _onKeypadBackspace() {
    HapticFeedback.lightImpact();
    final text = _meterController.text;
    if (text.isNotEmpty) {
      setState(() {
        _meterController.text = text.substring(0, text.length - 1);
      });
    }
  }

  void _showWarningMasukanNomorMeter() {
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Harap masukkan nomor meteran dulu!',
                style: GoogleFonts.robotoSlab(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFC764F6),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _proceedToTagihanConfirmation() {
    if (_meterController.text.trim().isEmpty) {
      _showWarningMasukanNomorMeter();
      return;
    }
    HapticFeedback.mediumImpact();
    final idPel = _meterController.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KonfirmasiPembayaranTagihanScreen(
          idPel: idPel,
          namaPelanggan: 'LISA ARUNIAH',
          tarifDaya: 'R1 / 900 VA',
          totalLembar: '1',
          periode: 'SEP/26',
          jumlahTagihanFormatted: 'Rp 300.000',
          numericPrice: 300000,
        ),
      ),
    );
  }

  Widget _buildKeypadButton({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Container(
        height: 46,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x15000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomKeypad() {
    return Container(
      color: const Color(0xFFD9D9D9),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildKeypadButton(
                child: Text('1', style: GoogleFonts.robotoSlab(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823))),
                onTap: () => _onKeypadTap('1'),
              ),
              _buildKeypadButton(
                child: Text('2', style: GoogleFonts.robotoSlab(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823))),
                onTap: () => _onKeypadTap('2'),
              ),
              _buildKeypadButton(
                child: Text('3', style: GoogleFonts.robotoSlab(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823))),
                onTap: () => _onKeypadTap('3'),
              ),
              _buildKeypadButton(
                child: Text('-', style: GoogleFonts.robotoSlab(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823))),
                onTap: () => _onKeypadTap('-'),
              ),
            ],
          ),
          Row(
            children: [
              _buildKeypadButton(
                child: Text('4', style: GoogleFonts.robotoSlab(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823))),
                onTap: () => _onKeypadTap('4'),
              ),
              _buildKeypadButton(
                child: Text('5', style: GoogleFonts.robotoSlab(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823))),
                onTap: () => _onKeypadTap('5'),
              ),
              _buildKeypadButton(
                child: Text('6', style: GoogleFonts.robotoSlab(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823))),
                onTap: () => _onKeypadTap('6'),
              ),
              _buildKeypadButton(
                child: Container(
                  width: 14,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C0823),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                onTap: () => _onKeypadTap('—'),
              ),
            ],
          ),
          Row(
            children: [
              _buildKeypadButton(
                child: Text('7', style: GoogleFonts.robotoSlab(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823))),
                onTap: () => _onKeypadTap('7'),
              ),
              _buildKeypadButton(
                child: Text('8', style: GoogleFonts.robotoSlab(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823))),
                onTap: () => _onKeypadTap('8'),
              ),
              _buildKeypadButton(
                child: Text('9', style: GoogleFonts.robotoSlab(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823))),
                onTap: () => _onKeypadTap('9'),
              ),
              _buildKeypadButton(
                child: const Icon(Icons.backspace_outlined, size: 20, color: Color(0xFF1C0823)),
                onTap: _onKeypadBackspace,
              ),
            ],
          ),
          Row(
            children: [
              _buildKeypadButton(
                child: Text(',', style: GoogleFonts.robotoSlab(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823))),
                onTap: () => _onKeypadTap(','),
              ),
              _buildKeypadButton(
                child: Text('0', style: GoogleFonts.robotoSlab(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823))),
                onTap: () => _onKeypadTap('0'),
              ),
              _buildKeypadButton(
                child: Text('.', style: GoogleFonts.robotoSlab(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823))),
                onTap: () => _onKeypadTap('.'),
              ),
              _buildKeypadButton(
                child: const Icon(Icons.check, size: 22, color: Color(0xFF1C0823)),
                onTap: _proceedToTagihanConfirmation,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKonfirmasiButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFCA31FF),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x60CA31FF),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: _proceedToTagihanConfirmation,
          child: Center(
            child: Text(
              'Konfirmasi',
              style: GoogleFonts.robotoSlab(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.isEmbedded
          ? null
          : AppBar(
              backgroundColor: const Color(0xFFC764F6),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF3B0054), size: 28),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Listrik',
                style: GoogleFonts.robotoSlab(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3B0054),
                ),
              ),
              centerTitle: false,
            ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (_showCustomKeypad) {
            setState(() {
              _showCustomKeypad = false;
            });
          }
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Input Card Sesuai Desain Figma (Warna EDD0F9 untuk Tagihan)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedType == 1 ? const Color(0xFFEDD0F9) : const Color(0xFFF3D8FF),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFFCA31FF), width: 1.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x26000000),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Label & TextField (Tap to show keyboard)
                            InkWell(
                              onTap: () {
                                if (_selectedType == 1) {
                                  setState(() {
                                    _showCustomKeypad = true;
                                  });
                                }
                              },
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedType == 0 ? 'Nomor Meter' : 'ID PELANGGAN (ID PEL)',
                                      style: GoogleFonts.robotoSlab(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1C0823),
                                      ),
                                    ),
                                    TextField(
                                      controller: _meterController,
                                      focusNode: _meterFocusNode,
                                      showCursor: _selectedType == 1 ? _showCustomKeypad : true,
                                      readOnly: _selectedType == 1,
                                      onTap: () {
                                        if (_selectedType == 1) {
                                          setState(() {
                                            _showCustomKeypad = true;
                                          });
                                        }
                                      },
                                      keyboardType: TextInputType.number,
                                      style: GoogleFonts.robotoSlab(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1C0823),
                                      ),
                                      decoration: InputDecoration(
                                        hintText: _selectedType == 0 ? 'Masukan Nomor Meter' : 'Masukan ID PEL',
                                        hintStyle: GoogleFonts.robotoSlab(
                                          fontSize: 18,
                                          color: const Color(0xFFA58AA8),
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(height: 1, color: Colors.transparent),
                            // Switch Token / Tagihan (Pill Putih di Bagian Bawah)
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(14),
                                  bottomRight: Radius.circular(14),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Token Option
                                  InkWell(
                                    onTap: () => setState(() {
                                      _selectedType = 0;
                                      _showCustomKeypad = false;
                                    }),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: _selectedType == 0 ? const Color(0xFF00E676) : const Color(0xFF1C0823),
                                              width: 2,
                                            ),
                                          ),
                                          child: _selectedType == 0
                                              ? Center(
                                                  child: Container(
                                                    width: 12,
                                                    height: 12,
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xFF00E676),
                                                    ),
                                                  ),
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Token',
                                          style: GoogleFonts.robotoSlab(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF1C0823),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  // Tagihan Option
                                  InkWell(
                                    onTap: () => setState(() {
                                      _selectedType = 1;
                                      _showCustomKeypad = false;
                                    }),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: _selectedType == 1 ? const Color(0xFF00E676) : const Color(0xFF1C0823),
                                              width: 2,
                                            ),
                                          ),
                                          child: _selectedType == 1
                                              ? Center(
                                                  child: Container(
                                                    width: 12,
                                                    height: 12,
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xFF00E676),
                                                    ),
                                                  ),
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Tagihan',
                                          style: GoogleFonts.robotoSlab(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF1C0823),
                                          ),
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

                    // BODY UNTUK TOKEN LISTRIK
                    if (_selectedType == 0) ...[
                      // Section "Bayar lagi"
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          'Bayar lagi',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1C0823),
                          ),
                        ),
                      ),

                      // Card Bayar Lagi (PLN Token LISA ARUNIA - Persis Desain Figma Node 551-256)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 46),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _meterController.text = '45994543223';
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEDDF4),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x14000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                _buildPlnExactLogo(width: 32, height: 41, radius: 5),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '45994543223',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF2B1732),
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'PLN Token . LISA ARUNIA',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF2B1732),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Denominations Grid
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _denominations.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.42,
                          ),
                          itemBuilder: (context, index) {
                            final item = _denominations[index];
                            final isSelected = _selectedNominal == item['nominal'];
                            final hasMeterNumber = _meterController.text.trim().isNotEmpty;

                            return _AnimatedNominalCard(
                              item: item,
                              isSelected: isSelected,
                              isEnabled: hasMeterNumber,
                              onTap: () async {
                                if (!hasMeterNumber) {
                                  _showWarningMasukanNomorMeter();
                                  return;
                                }

                                setState(() {
                                  _selectedNominal = item['nominal'];
                                });
                                await Future.delayed(const Duration(milliseconds: 100));
                                if (!mounted || !context.mounted) return;
                                final meterNo = _meterController.text.trim();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PembayaranListrikScreen(
                                      meterNumber: meterNo,
                                      customerName: 'LISA ARUNIA',
                                      serviceType: 'PLN Token',
                                      tarifDaya: 'R1/900',
                                      nominalLabel: item['nominal'],
                                      originalPrice: item['original'],
                                      discountedPrice: item['discount'],
                                      numericPrice: item['numericPrice'],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                    ] else ...[
                      // ==========================================
                      // BODY UNTUK TAGIHAN LISTRIK (PERSIS FOTO 2)
                      // ==========================================
                      const SizedBox(height: 18),

                      // Card Saved PLN Token LISA ARUNIA (Persis Desain Figma Node 283-208)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 46),
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _meterController.text = '45994543223';
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEDDF4),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x14000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                _buildPlnExactLogo(width: 32, height: 41, radius: 5),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '45994543223',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF2B1732),
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'PLN Token . LISA ARUNIA',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF2B1732),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ],
                ),
              ),
            ),

            // Tombol Konfirmasi untuk Tagihan di bagian bawah layar
            if (_selectedType == 1) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildKonfirmasiButton(),
              ),
              if (_showCustomKeypad) ...[
                const SizedBox(height: 18), // Jarak dekat tapi tidak terlalu dekat dengan keyboard
                _buildCustomKeypad(),
              ] else ...[
                const SizedBox(height: 60), // Sedikit geser ke atas dari dasar layar
              ],
            ],
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 2 TAGIHAN: KONFIRMASI PEMBAYARAN (Node 1348-1988 / Foto 3)
// ==========================================
class KonfirmasiPembayaranTagihanScreen extends StatelessWidget {
  final String idPel;
  final String namaPelanggan;
  final String tarifDaya;
  final String totalLembar;
  final String periode;
  final String jumlahTagihanFormatted;
  final int numericPrice;

  const KonfirmasiPembayaranTagihanScreen({
    super.key,
    this.idPel = '1718800221359',
    this.namaPelanggan = 'LISA ARUNIAH',
    this.tarifDaya = 'R1 / 900 VA',
    this.totalLembar = '1',
    this.periode = 'SEP/26',
    this.jumlahTagihanFormatted = 'Rp 300.000',
    this.numericPrice = 300000,
  });

  static Widget _buildTagihanRow(String label, String value, {bool isBold = false, double fontSize = 15}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoSlab(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: const Color(0xFF1C0823),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.robotoSlab(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: const Color(0xFF1C0823),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC764F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3B0054), size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Konfirmasi Pembayaran',
          style: GoogleFonts.robotoSlab(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF3B0054),
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 42, 16, 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD0D0D0), width: 1.0),
            boxShadow: const [
              BoxShadow(
                color: Color(0x28000000),
                blurRadius: 12,
                spreadRadius: 1,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detail Tagihan',
                style: GoogleFonts.robotoSlab(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1C0823),
                ),
              ),
              const SizedBox(height: 16),
              _buildTagihanRow('Nama layanan', 'PLN'),
              const SizedBox(height: 14),
              _buildTagihanRow('IDPEL', idPel),
              const SizedBox(height: 14),
              _buildTagihanRow('NAMA', namaPelanggan),
              const SizedBox(height: 14),
              _buildTagihanRow('TOTAL LEMBAR TAGIHAN', totalLembar),
              const SizedBox(height: 14),
              _buildTagihanRow('BLN/TH', periode),
              const SizedBox(height: 22),
              _buildTagihanRow('JLH Tagihan', jumlahTagihanFormatted, isBold: true, fontSize: 15),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: Border.all(color: const Color(0xFFD0D0D0), width: 1.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x28000000),
              blurRadius: 12,
              spreadRadius: 1,
              offset: Offset(0, -3),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomPaint(
                    size: Size(38, 32),
                    painter: _XemaWalletExactPainter(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Xema',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'sisa  saldo',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF000000),
                              ),
                            ),
                            Text(
                              'Rp 76.565.000,00',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1C0823),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x4DCA31FF),
                      blurRadius: 14,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PinPlnScreen(
                          meterNumber: idPel,
                          customerName: namaPelanggan,
                          nominalFormatted: jumlahTagihanFormatted,
                          totalFormatted: jumlahTagihanFormatted,
                          isTagihan: true,
                          idPel: idPel,
                          periode: periode,
                          totalLembar: totalLembar,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCA31FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bayar',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            jumlahTagihanFormatted,
                            style: GoogleFonts.robotoSlab(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          CustomPaint(
                            size: const Size(20, 20),
                            painter: _PaperPlanePainter(),
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
      ),
    );
  }
}

// SCREEN 2 TOKEN: PEMBAYARAN LISTRIK (TOKEN)
// ==========================================
// ==========================================
// SCREEN 2: PEMBAYARAN LISTRIK (Node 185:39 / 205:95 / 205:91 / 211:1077)
// ==========================================
class PembayaranListrikScreen extends StatelessWidget {
  final String meterNumber;
  final String customerName;
  final String serviceType;
  final String tarifDaya;
  final String nominalLabel;
  final String originalPrice;
  final String discountedPrice;
  final int numericPrice;

  const PembayaranListrikScreen({
    super.key,
    required this.meterNumber,
    required this.customerName,
    required this.serviceType,
    required this.tarifDaya,
    required this.nominalLabel,
    required this.originalPrice,
    required this.discountedPrice,
    required this.numericPrice,
  });

  static Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoSlab(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF000000),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.robotoSlab(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF000000),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const int adminFee = 1500;
    final int totalPrice = numericPrice + adminFee;
    final String formattedTotal = 'Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD373FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF52086B), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Listrik',
          style: GoogleFonts.robotoSlab(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF52086B),
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  // CARD 1: DETAIL TRANSAKSI (Figma Node 205:95)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD0D0D0), width: 1.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x28000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DETAIL TRANSAKSI',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF000000),
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildDetailRow('Nama layanan', serviceType),
                        const SizedBox(height: 10),
                        _buildDetailRow('NAMA', 'L*************'),
                        const SizedBox(height: 10),
                        _buildDetailRow('TARIF/DAYA', tarifDaya),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // CARD 2: RINCIAN PEMBAYARAN (Figma Node 205:91)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD0D0D0), width: 1.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x28000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rincian Pembayaran',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        const SizedBox(height: 14),
                        // NOMINAL ROW
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'NOMINAL',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1C0823),
                              ),
                            ),
                            Row(
                              children: [
                                if (originalPrice.isNotEmpty) ...[
                                  Text(
                                    originalPrice,
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 14,
                                      color: const Color(0xFF9C9C9C),
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  discountedPrice,
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1C0823),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // ADMIN BANK ROW
                        _buildDetailRow('ADMIN BANK', 'Rp1.500'),
                        const SizedBox(height: 12),
                        // ASURANSI ROW
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Asuransi rumah & listrik',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1C0823),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Rp 500',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 14,
                                    color: const Color(0xFF9C9C9C),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Rp0',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1C0823),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        // TOTAL ROW
                        Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF00FF11), width: 1.8),
                              ),
                              child: const Center(
                                child: Text(
                                  r'$',
                                  style: TextStyle(
                                    color: Color(0xFF00FF11),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Total Pembayaran',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1C0823),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              formattedTotal,
                              style: GoogleFonts.robotoSlab(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1C0823),
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
          ),

          // BOTTOM SHEET / PERSISTENT FOOTER (Figma Node 211:1077 / 565:268 / 551:258)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              border: Border.all(color: const Color(0xFFD0D0D0), width: 1.0),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 12,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Baris 1: Logo Xema & Nama Xema (Persis Desain Figma)
                  Row(
                    children: [
                      const CustomPaint(
                        size: Size(36, 30),
                        painter: _XemaWalletExactPainter(),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Xema',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Baris 2: sisa saldo di kiri, Rp. 76.565.000,00 di kanan (Persis Desain Figma)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          'sisa  saldo',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ),
                      Text(
                        'Rp. 76.565.000,00',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1C0823),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Row 3: Button Bayar Sesuai Desain Figma
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PinPlnScreen(
                            meterNumber: meterNumber,
                            customerName: customerName,
                            nominalFormatted: discountedPrice,
                            totalFormatted: formattedTotal,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCA31FF),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x60CA31FF),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Bayar',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 16.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            formattedTotal,
                            style: GoogleFonts.robotoSlab(
                              fontSize: 16.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          CustomPaint(
                            size: const Size(20, 20),
                            painter: _PaperPlanePainter(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ==========================================
// SCREEN 3: PIN PLN (Node 1348-2015 / Foto 4)
// ==========================================
class PinPlnScreen extends StatefulWidget {
  final String meterNumber;
  final String customerName;
  final String nominalFormatted;
  final String totalFormatted;
  final bool isTagihan;
  final String idPel;
  final String periode;
  final String totalLembar;

  const PinPlnScreen({
    super.key,
    required this.meterNumber,
    required this.customerName,
    required this.nominalFormatted,
    required this.totalFormatted,
    this.isTagihan = false,
    this.idPel = '1718800221359',
    this.periode = 'SEP/26',
    this.totalLembar = '1',
  });

  @override
  State<PinPlnScreen> createState() => _PinPlnScreenState();
}

class _PinPlnScreenState extends State<PinPlnScreen> {
  String _pin = '';

  void _onKeyPress(String val) {
    if (_pin.length < 6) {
      HapticFeedback.lightImpact();
      setState(() => _pin += val);
      if (_pin.length == 6) {
        _submitPin();
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  void _submitPin() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BuktiTransaksiScreen(
          meterNumber: widget.meterNumber,
          customerName: widget.customerName,
          nominalFormatted: widget.nominalFormatted,
          totalFormatted: widget.totalFormatted,
          isTagihan: widget.isTagihan,
          idPel: widget.idPel,
          periode: widget.periode,
          totalLembar: widget.totalLembar,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar dengan Tombol Back Melingkar Ungu Tua (Node 283:163 / 283:173 / Foto Figma)
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 12, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF52086B), width: 2.2),
                    ),
                    child: const Center(
                      child: Icon(Icons.arrow_back, color: Color(0xFF52086B), size: 24),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Icon Kunci Ungu Kotak Membulat Besar (Node 283:174 / Foto Figma)
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: const Color(0xFF1C0823),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x331C0823),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: CustomPaint(
                  size: Size(48, 32),
                  painter: _HorizontalKeyPainter(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Judul Konfirmasi PIN
            Text(
              'Konfirmasi PIN',
              style: GoogleFonts.robotoSlab(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF000000),
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Masukkan 6-digit PIN Trasaksi kamu',
              style: GoogleFonts.robotoSlab(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF000000),
              ),
            ),

            const SizedBox(height: 48),

            // Indikator 6 Bulatan PIN Besar Berjarak Lebar (Persis Figma)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                final isFilled = index < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 9),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? const Color(0xFFCA31FF) : const Color(0xFFD9D9D9),
                  ),
                );
              }),
            ),

            const SizedBox(height: 48),

            // Teks Lupa PIN?
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur reset PIN telah dikirim ke nomor HP kamu.')),
                );
              },
              child: Text(
                'Lupa PIN?',
                style: GoogleFonts.robotoSlab(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF772096),
                ),
              ),
            ),

            const Spacer(),

            // Custom Numeric Keypad Persis Sesuai Figma & Foto User
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildKeypadRow(['1', '2', '3']),
                  const SizedBox(height: 28),
                  _buildKeypadRow(['4', '5', '6']),
                  const SizedBox(height: 28),
                  _buildKeypadRow(['7', '8', '9']),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      // Spacer kosong sebelah kiri (dapat di-tap untuk backspace / hapus PIN)
                      Expanded(
                        child: InkWell(
                          onTap: _onBackspace,
                          borderRadius: BorderRadius.circular(30),
                          child: const SizedBox(height: 52),
                        ),
                      ),
                      // Angka 0 tepat di tengah
                      Expanded(
                        child: _buildNumberKey('0'),
                      ),
                      // Tombol Submit / Checkmark Ungu Persis Figma
                      Expanded(
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              if (_pin.length == 6) {
                                _submitPin();
                              }
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFCA31FF),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x60CA31FF),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(Icons.check, color: Colors.white, size: 24),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadRow(List<String> values) {
    return Row(
      children: values
          .map((val) => Expanded(child: _buildNumberKey(val)))
          .toList(),
    );
  }

  Widget _buildNumberKey(String val) {
    return InkWell(
      onTap: () => _onKeyPress(val),
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        height: 52,
        child: Center(
          child: Text(
            val,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF000000),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 4: BUKTI TRANSAKSI (Node 1348-1837 / Foto 5)
// ==========================================
class BuktiTransaksiScreen extends StatelessWidget {
  final String meterNumber;
  final String customerName;
  final String nominalFormatted;
  final String totalFormatted;
  final bool isTagihan;
  final String idPel;
  final String totalLembar;
  final String periode;

  const BuktiTransaksiScreen({
    super.key,
    required this.meterNumber,
    required this.customerName,
    required this.nominalFormatted,
    required this.totalFormatted,
    this.isTagihan = false,
    this.idPel = '1718800221359',
    this.totalLembar = '1',
    this.periode = 'SEP/26',
  });

  static Widget _buildPartyPopper() {
    return Image.memory(
      base64Decode(_partyPopperBase64),
      width: 175,
      height: 145,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/party_popper.png',
        width: 175,
        height: 145,
        fit: BoxFit.contain,
      ),
    );
  }

  static Widget _buildShareIcon() {
    return Image.memory(
      base64Decode(_shareFigmaBase64),
      width: 28,
      height: 28,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/share_figma.png',
        width: 28,
        height: 28,
        fit: BoxFit.contain,
      ),
    );
  }

  static Widget _buildReceiptRow(String label, String value, {double fontSize = 13.5}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoSlab(
            fontSize: fontSize,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.robotoSlab(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveMeter = meterNumber.length > 5 ? meterNumber : '45994543223';
    final effectiveNominal = nominalFormatted.isNotEmpty ? nominalFormatted : 'Rp 49.000';
    final effectiveTotal = totalFormatted.isNotEmpty ? totalFormatted : 'Rp 50.500';
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Header Ungu di bagian atas
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topPadding + 215,
            child: Container(
              color: const Color(0xFFD373FC),
            ),
          ),

          // Konten Scrollable
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  // HEADER DENGAN ILUSTRASI CELEBRATION FIGMA & SHARE
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Center(
                            child: Transform.translate(
                              offset: const Offset(22, 0),
                              child: _buildPartyPopper(),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: _buildShareIcon(),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Membuka menu berbagi...')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // KARTU TIDAK FULL (FLOATING CARD DENGAN STROKE & EFFECTS SESUAI FIGMA)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF6E1FF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(34),
                        topRight: Radius.circular(34),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                      border: Border(
                        top: BorderSide(color: Color(0xFFE2C8EF), width: 1.0),
                        left: BorderSide(color: Color(0xFFE2C8EF), width: 1.0),
                        right: BorderSide(color: Color(0xFFE2C8EF), width: 1.0),
                        bottom: BorderSide(color: Color(0xFFE2C8EF), width: 1.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x66CA31FF), // 40% Pure Glowing Magenta Shadow
                          blurRadius: 24,
                          spreadRadius: 3,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(33),
                        topRight: Radius.circular(33),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                      child: Column(
                        children: [
                          if (isTagihan) ...[
                            // ==========================================
                            // BUKTI TRANSAKSI TAGIHAN LISTRIK (FOTO 5)
                            // ==========================================
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                              child: Column(
                                children: [
                                  // Checkmark Bulat Magenta #CA31FF dengan bayangan
                                  Container(
                                    width: 62,
                                    height: 62,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFCA31FF),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x66CA31FF),
                                          blurRadius: 14,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 38,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Judul Transaksi Sukses
                                  Text(
                                    'Transaksi Sukses',
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Kotak Ungu Muda Lavender Detail Tagihan Sesuai Foto 5
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDDBAEA),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x26570374),
                                          blurRadius: 8,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            _buildPlnExactLogo(size: 38, radius: 6),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Rincian transaksi',
                                              style: GoogleFonts.robotoSlab(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF1C0823),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        _buildReceiptRow('Nama layanan', 'PLN', fontSize: 13.5),
                                        const SizedBox(height: 8),
                                        _buildReceiptRow('IDPEL', idPel.isNotEmpty ? idPel : '1718800221359', fontSize: 13.5),
                                        const SizedBox(height: 8),
                                        _buildReceiptRow('NAMA', customerName.isNotEmpty ? customerName : 'LISA ARUNIAH', fontSize: 13.5),
                                        const SizedBox(height: 8),
                                        _buildReceiptRow('TOTAL LEMBAR TAGIHAN', totalLembar.isNotEmpty ? totalLembar : '1', fontSize: 13.5),
                                        const SizedBox(height: 8),
                                        _buildReceiptRow('BLN/TH', periode.isNotEmpty ? periode : 'SEP/26', fontSize: 13.5),
                                        const SizedBox(height: 14),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'JLH Tagihan',
                                              style: GoogleFonts.robotoSlab(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              totalFormatted.isNotEmpty ? totalFormatted : 'Rp 300.000',
                                              style: GoogleFonts.robotoSlab(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        const Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.keyboard_arrow_up,
                                            color: Color(0xFF1C0823),
                                            size: 28,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            // ==========================================
                            // BUKTI TRANSAKSI TOKEN LISTRIK (LAYOUT LAMA)
                            // ==========================================
                            // SECTION 1: HEADER & DETAIL TRANSAKSI
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                              child: Column(
                                children: [
                                  // Checkmark Bulat Magenta #CA31FF
                                  Container(
                                    width: 58,
                                    height: 58,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFCA31FF),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Judul Bukti Transaksi
                                  Text(
                                    'Bukti Transaksi',
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1C0823),
                                    ),
                                  ),

                                  const SizedBox(height: 18),

                                  // Detail Referensi, Rekening, Tanggal
                                  _buildReceiptRow('Nomor Referensi', '45499730898'),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Dari Rekening',
                                        style: GoogleFonts.robotoSlab(
                                          fontSize: 13.5,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            customerName.isNotEmpty ? customerName : 'LISA ARUNIA',
                                            style: GoogleFonts.robotoSlab(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            '085123435656',
                                            style: GoogleFonts.robotoSlab(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  _buildReceiptRow('Tanggal Pembelian', '1 Okt 2026 |09:18:67 WIB'),
                                ],
                              ),
                            ),

                            // GARIS PEMISAH 1
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(color: Color(0xFFE2C8EF), thickness: 1),
                            ),

                            // SECTION 2: KOTAK TOKEN 20 DIGIT
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDDBAEA),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            '2055 4421 9034 1801',
                                            style: TextStyle(
                                              fontFamily: 'RobotoSlab',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF570374),
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            '0719',
                                            style: TextStyle(
                                              fontFamily: 'RobotoSlab',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF570374),
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    _CopyTokenButton(textToCopy: '2055 4421 9034 1801 0719'),
                                  ],
                                ),
                              ),
                            ),

                            // SECTION 3: DETAIL NO METER, IDPEL, NOMINAL, ADMIN BANK
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
                              child: Column(
                                children: [
                                  _buildReceiptRow('NO METER', effectiveMeter),
                                  const SizedBox(height: 8),
                                  _buildReceiptRow('IDPEL', '1718800221359'),
                                  const SizedBox(height: 12),
                                  const Divider(color: Color(0xFFE2C8EF), thickness: 1),
                                  const SizedBox(height: 10),
                                  _buildReceiptRow('NOMINAL', effectiveNominal),
                                  const SizedBox(height: 8),
                                  _buildReceiptRow('ADMIN BANK', 'Rp 1.500'),
                                ],
                              ),
                            ),

                            // GARIS PEMISAH 3
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(color: Color(0xFFE2C8EF), thickness: 1),
                            ),

                            // SECTION 4: TOTAL ROW
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'TOTAL',
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    effectiveTotal,
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // TOMBOL "OK" DI DASAR LAYAR DENGAN ANIMASI INTERAKTIF & KEMBALI KE BERANDA
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _AnimatedOkButton(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const BerandaScreen()),
                          (route) => false,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
