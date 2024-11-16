import 'dart:async';
import 'package:flutter/material.dart';
import '/Auth/SignUp/SignUpPage.dart';
import '/Auth/Signin/Signin.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _carouselTimer;

  final List<Map<String, dynamic>> carouselItems = [
    {
      "title": "Gọi video ổn định",
      "subtitle":
          "Trò chuyện thật đã với chất lượng video ổn định mọi lúc, mọi nơi",
      "icon": Icons.video_call_rounded,
    },
    {
      "title": "Nhắn tin miễn phí",
      "subtitle": "Kết nối với bạn bè và người thân mọi lúc",
      "icon": Icons.chat_rounded,
    },
    {
      "title": "Chia sẻ khoảnh khắc",
      "subtitle": "Dễ dàng chia sẻ hình ảnh và video",
      "icon": Icons.share_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < carouselItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    _carouselTimer?.cancel(); // Cancel existing timer when user manually swipes
    _startAutoPlay(); // Restart the autoplay timer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          const Text(
            'Zalo',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w700,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            flex: 3,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: carouselItems.length,
              itemBuilder: (context, index) {
                return buildCarouselItem(
                  title: carouselItems[index]["title"],
                  subtitle: carouselItems[index]["subtitle"],
                  icon: carouselItems[index]["icon"],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              carouselItems.length,
              (index) => buildIndicator(index == _currentPage),
            ),
          ),
          const SizedBox(height: 20),
          signInButton(),
          const SizedBox(height: 10),
          signUpButton(),
          const Spacer(flex: 2),
          languageSelectionRow(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildCarouselItem(
      {required String title,
      required String subtitle,
      required IconData icon}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 80,
          color: Colors.blue[300],
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 12.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Widget signInButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.blue,
      ),
      child: const Text(
        'Đăng nhập',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget signUpButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.white,
        side: const BorderSide(color: Colors.grey),
      ),
      child: const Text(
        'Đăng ký',
        style: TextStyle(fontSize: 18, color: Colors.blue),
      ),
    );
  }

  Widget languageSelectionRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Tiếng Việt",
          style: TextStyle(
            fontSize: 14,
            decoration: TextDecoration.underline,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 10),
        Text(
          "English",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        SizedBox(width: 10),
        Text(
          "မြန်မာ",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}
