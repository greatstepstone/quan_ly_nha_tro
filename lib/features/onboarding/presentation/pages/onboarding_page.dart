import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/resources/color_manager.dart';
import '../providers/onboarding_providers.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _items = [
    OnboardingData(
      title: 'Chào mừng đến với\nQuản Lý Nhà Trọ',
      description: 'Giải pháp toàn diện giúp bạn quản lý các bất động sản cho thuê một cách chuyên nghiệp và hiệu quả.',
      image: 'assets/icons/onboarding_welcome.png',
    ),
    OnboardingData(
      title: 'Quản lý Phòng & Khách\nDễ dàng hơn bao giờ hết',
      description: 'Lưu trữ thông tin chi tiết về từng phòng, hợp đồng thuê và thông tin khách hàng chỉ trong vài bước.',
      image: 'assets/icons/onboarding_manage.png',
    ),
    OnboardingData(
      title: 'Theo dõi Hóa đơn\n& Báo cáo tài chính',
      description: 'Tự động tính toán tiền điện nước, tạo hóa đơn và xem báo cáo doanh thu minh bạch nhất.',
      image: 'assets/icons/onboarding_finance.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: Text(
                  'Bỏ qua',
                  style: GoogleFonts.manrope(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _OnboardingContent(data: _items[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _items.length,
                      (index) => _buildDot(index),
                    ),
                  ),
                  _buildButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    final isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.primaryLight,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildButton() {
    final isLastPage = _currentPage == _items.length - 1;
    return ElevatedButton(
      onPressed: () {
        if (isLastPage) {
          _completeOnboarding();
        } else {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(120, 56),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Text(
          isLastPage ? 'Bắt đầu ngay' : 'Tiếp theo',
          key: ValueKey(_currentPage),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _completeOnboarding() {
    ref.read(onboardingSeenProvider.notifier).completeOnboarding();
    context.go('/login');
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String image;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
  });
}

class _OnboardingContent extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: AppColors.surfaceBright,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                data.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

