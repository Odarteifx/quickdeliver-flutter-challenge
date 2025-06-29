import 'package:flutter/material.dart';
import 'package:quickdeliver_flutter_challenge/views/onboarding/onboarding_view_one.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  bool onlastpage = false;
  final pages = [PageViewOne(), Text('fry'), Text('data'), Text('datalast')];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        PageView.builder(
          controller: _controller,
          onPageChanged: (value) {
            setState(() {
              onlastpage = (value == pages.length - 1);
            });
          },
          itemCount: pages.length,
          itemBuilder: (context, index) {
            return pages[index % pages.length];
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
              alignment: const Alignment(0, 0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  onlastpage
                      ? const TextButton(onPressed: null, child: Text(''))
                      : TextButton(
                          onPressed: () {
                            _controller.jumpToPage(3);
                          },
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.black
                            ),
                          )),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: pages.length,
                    effect: ExpandingDotsEffect(
                        activeDotColor: const Color(0xFFFFC107),
                        dotWidth: 8,
                        dotHeight: 8,
                        spacing: 6),
                  ),
                  onlastpage
                      ? FilledButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OnboardingScreen(),
                                ));
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFFFC107),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: Text(
                            'Done',
                          ))
                      : FilledButton(
                          onPressed: () {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeIn);
                          },
                          style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFFFC107),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: Text(
                            'Next',
                          ))
                ],
              )),
        )
      ],
    )));
  }
}
