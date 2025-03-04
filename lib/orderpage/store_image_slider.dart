import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/store_info_provider.dart';

/// 가게 이미지 슬라이더 위젯
/// 가게의 이미지를 슬라이드 형태로 표시
class StoreImageSlider extends StatelessWidget {
  final StoreProvider storeProv;
  final PageController pageController;
  final int currentPage;
  final Function(int) onPageChanged;

  const StoreImageSlider({
    Key? key,
    required this.storeProv,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provider에서 이미지 URL 목록 가져오기
    final imageUrls = storeProv.storeImages;

    return Stack(
      children: [
        // 이미지 슬라이더
        PageView.builder(
          controller: pageController,
          itemCount: imageUrls.isNotEmpty ? imageUrls.length : 1,
          onPageChanged: onPageChanged,
          itemBuilder: (context, index) {
            if (imageUrls.isNotEmpty) {
              // 실제 저장된 이미지 표시
              final imageUrl = imageUrls[index];
              return Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  // 이미지 로딩 중 Shimmer 효과 표시
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.white),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  // 이미지 로드 실패 시 기본 이미지 표시
                  return Image.network(
                    'https://i.ibb.co/JwCxP9br/1000007044.jpg',
                    fit: BoxFit.cover,
                  );
                },
              );
            } else {
              // 이미지가 없을 때 기본 이미지 표시
              return Image.network(
                'https://i.ibb.co/JwCxP9br/1000007044.jpg',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.white),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.broken_image, size: 50));
                },
              );
            }
          },
        ),

        // 페이지 인디케이터 (점)
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              imageUrls.isNotEmpty ? imageUrls.length : 1,
                  (index) {
                bool isActive = (index == currentPage);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 10 : 8,
                  height: isActive ? 10 : 8,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}