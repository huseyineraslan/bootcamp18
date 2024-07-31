import 'package:flutter/material.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  AdBannerState createState() => AdBannerState();
}

class AdBannerState extends State<AdBanner> {
  bool _showAd = true;

  @override
  void initState() {
    super.initState();
    _startAdTimer();
  }

  void _startAdTimer() {
    Future.delayed(const Duration(minutes: 3), () {
      if (mounted) {
        setState(() {
          _showAd = true;
        });
        _startAdTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      bottom: _showAd ? 0 : -100,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        color: Colors.blueAccent,
        child: Stack(
          children: [
            const Center(
              child: Text(
                'Bu bir reklamdır',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showAd = false;
                  });
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
