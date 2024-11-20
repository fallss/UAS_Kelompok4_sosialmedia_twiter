import 'package:flutter/material.dart';
import 'package:uas_twitter_mediasosial/auth/auth_gate.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPage < 2) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthGate()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: [
              buildPage(
                color: const Color.fromARGB(255, 0, 0, 0),
                image: 'lib/images/birds.png',
                title: 'Welcome to our social app!',
                subtitle: 'A place where connections and conversations happen',
              ),
              buildPage(
                color: const Color.fromARGB(255, 164, 76, 95),
                image: 'lib/images/slide2.png',
                title: 'Explore our superior features:',
                subtitle: 'Log in or register easily, find trending topics, display a photo and bio on your profile, send messages via the chat feature, set the appearance of the application with a dark or light theme, and enjoy a friendly initial appearance when you first use the application.',
              ),
              buildPage(
                color: const Color.fromARGB(255, 47, 95, 106),
                image: 'lib/images/slide3.png',
                title: 'Join and start your social journey now!',
                subtitle: 'Sign up now to start connecting, sharing moments, and enjoying fun social experiences on our app!',
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthGate()),
                    );
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                Row(
                  children: List.generate(
                    3,
                    (index) => GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPage == index ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: nextPage,
                  child: Text(
                    currentPage == 2 ? 'Done' : 'Next',
                    style: const TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage({
    required Color color,
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Container(
      color: color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
