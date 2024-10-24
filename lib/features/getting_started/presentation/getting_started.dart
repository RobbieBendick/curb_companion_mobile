import 'package:carousel_slider/carousel_slider.dart';
import 'package:curb_companion/features/getting_started/presentation/theme_toggle_button.dart';
import 'package:curb_companion/utils/helpers/helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:provider/provider.dart' as provider;
import 'package:curb_companion/features/theme/app/theme_service.dart';

class GettingStartedScreen extends StatefulWidget {
  const GettingStartedScreen({Key? key}) : super(key: key);

  @override
  State<GettingStartedScreen> createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  double fontSize = 14.0;

  int firstCarouselIndex = 0;
  int secondCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.78,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 35),
                  SizedBox(
                    child: Image.asset(provider.Provider.of<ThemeService>(
                                context,
                                listen: false)
                            .isDarkMode()
                        ? 'assets/images/logo_with_name_dark.png'
                        : 'assets/images/logo_with_name.png'),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Your new mobile vendor platform',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Stack(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          onPageChanged: (index, _) {
                            setState(() {
                              firstCarouselIndex = index;
                            });
                          },
                          height: 100,
                          viewportFraction: 1,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: [
                          Row(
                            children: [
                              Image.asset('assets/images/burger.png'),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Discover the best street food.',
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/food_truck_event.png',
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                flex: 4,
                                child: Text(
                                    'Make catering requests for your next event.',
                                    style: TextStyle(fontSize: fontSize)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: CarouselIndicator(
                            count: 2,
                            index: firstCarouselIndex,
                            activeColor: Theme.of(context).iconTheme.color!,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                  Stack(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          onPageChanged: (index, _) {
                            setState(() {
                              secondCarouselIndex = index;
                            });
                          },
                          height: 100,
                          viewportFraction: 1,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: [
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Text(
                                  'Order items for pickup from your favorite vendor.',
                                  style: TextStyle(fontSize: fontSize),
                                ),
                              ),
                              SizedBox(
                                width: 120,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    'assets/images/food_truck_stand.png',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'List your mobile vendor and use our tools to grow your business.',
                                    style: TextStyle(fontSize: fontSize),
                                  ),
                                ),
                              ),
                              Container(
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    'assets/images/breakfast_burger.png',
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: CarouselIndicator(
                            count: 2,
                            index: secondCarouselIndex,
                            activeColor: Theme.of(context).iconTheme.color!,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 38,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Get Started',
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 300,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        'By proceeding to use Curb Companion, you agree to our ',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color),
                                  ),
                                  TextSpan(
                                    text: 'terms of service',
                                    style: TextStyle(
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrlInWebView(
                                            'https://curbcompanion.com/terms-and-conditions');
                                      },
                                  ),
                                  TextSpan(
                                      text: ' and ',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color)),
                                  TextSpan(
                                    text: 'privacy policy',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        fontSize: 12),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        launchUrlInWebView(
                                            'https://example.com/terms-of-service%27');
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            top: 45,
            right: 0,
            child: ThemeToggleButton(),
          ),
        ],
      ),
    );
  }
}
