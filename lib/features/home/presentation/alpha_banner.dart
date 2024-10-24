import 'package:curb_companion/utils/helpers/helper.dart';
import 'package:flutter/material.dart';

class BetaBanner extends StatefulWidget {
  const BetaBanner({super.key});

  @override
  State<BetaBanner> createState() => _BetaBannerState();
}

class _BetaBannerState extends State<BetaBanner> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 22, 16.0, 0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () => {
                    launchUrlInWebView(
                        'https://curbcompanion.atlassian.net/servicedesk/customer/portal/1')
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "Beta",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "This app is in beta.\nPlease report any bugs or features you would like to see to the developers.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 1, // Width of the divider
                color: Colors.white.withOpacity(0.35),
                height: double.infinity,
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => {
                    launchUrlInWebView(
                        'https://curbcompanion.atlassian.net/servicedesk/customer/portal/1')
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Give feedback here 👇 ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 25,
                          child: Text(
                            "Reach out!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
