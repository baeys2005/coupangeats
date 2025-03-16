import 'package:flutter/material.dart';

class PromotionalBanner extends StatelessWidget {
  const PromotionalBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaffold 대신 SliverAppBar를 직접 반환합니다
    return SliverAppBar(
      expandedHeight: 155, // 이미지 높이를 조금 더 증가
      floating: false,
      pinned: false, // 스크롤하면 완전히 사라지게 함
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.loose, // 스택이 유연하게 공간을 활용하도록 설정
          children: [
            // 배경색상
            Container(
              color: Color(0xff346AFF),
            ),

            // 프로모션 텍스트와 버튼을 포함하는 컨테이너
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // 상하 패딩 감소
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // 필요한 만큼만 공간 차지
                children: [
                  SizedBox(height: 10,),
                  // "WOW!" 텍스트
                  const Center(
                    child: Text(
                      "WOW!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28, // 폰트 크기 약간 감소
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  // 한국어 텍스트 (외우회원님 [미사용 특별 혜택]이 있습니다)
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19, // 폰트 크기 감소
                          fontWeight: FontWeight.bold
                        ),
                        children: [
                          const TextSpan(
                            text: "외우회원님 ",
                          ),
                          TextSpan(
                            text: "[미사용 특별 혜택]",
                            style: TextStyle(
                              color: Colors.yellow[300],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: "이 있습니다", style: TextStyle(fontFamily:'Neo Sans Pro' )
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 13), // 간격 줄임

                  // 흰색 컨테이너에 쿠폰 정보와 버튼
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18), // 패딩 감소
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        // 쿠폰 텍스트
                        SizedBox(height: 15,),
                        Flexible(
                          child: Text(
                            "10,000원 쿠폰 + 무료배달",
                            style: TextStyle(
                              fontSize: 18, // 폰트 크기 감소
                              fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(width: 6), // 간격 줄임

                        // 버튼
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16), // 둥근 모서리 감소
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // 패딩 감소
                            minimumSize: Size.zero, // 최소 크기 제한 제거
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 버튼 주변 공간 최소화
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                "지금 받기",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13, // 폰트 크기 감소
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 14, // 아이콘 크기 감소
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 닫기 버튼

          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}