import 'package:flutter/material.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({Key? key}) : super(key: key);

  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
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
            Center(
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
                child: Icon(
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
