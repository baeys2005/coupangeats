import 'package:flutter/material.dart';
import 'package:coupangeats/theme.dart';

class HomeWowBanner extends StatefulWidget {
  const HomeWowBanner({Key? key}) : super(key: key);

  @override
  State<HomeWowBanner> createState() => _HomeWowBannerState();
}

class _HomeWowBannerState extends State<HomeWowBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _bannerImages = [
    'assets/homepage_wow_1.png',
    'assets/homepage_wow_2.png',
    'assets/homepage_wow_3.png',
  ];

  @override
  void initState() {
    super.initState();
    // Auto slide the banner every 5 seconds
    Future.delayed(Duration.zero, () {
      _autoSlide();
    });
  }

  void _autoSlide() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _bannerImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        if (mounted) {
          _autoSlide();
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding1),
      height: 180,
      child: Stack(
        children: [
          // Banner images
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _bannerImages.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  _bannerImages[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),

          // Close button
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  // Hide banner logic can be added here
                },
              ),
            ),
          ),

          // Page indicator
          Positioned(
            bottom: 10,
            right: 10,
            child: Row(
              children: List.generate(
                _bannerImages.length,
                    (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.blue
                        : Colors.grey.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}