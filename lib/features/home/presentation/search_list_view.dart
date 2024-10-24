import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/home/presentation/vendor_card.dart';
import 'package:flutter/material.dart';

class SearchListScreen extends StatefulWidget {
  const SearchListScreen({super.key});

  @override
  State<SearchListScreen> createState() => SearchListScreenState();
}

class SearchListScreenState extends State<SearchListScreen> {
  bool isScrolled = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(onScroll);
    super.initState();
  }

  void onScroll() {
    setState(() {
      isScrolled = _scrollController.offset > 35;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> section =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    String sectionTitle = section['title'];
    List<Vendor> vendors = section['vendors'];

    return Material(
      child: ScrollbarTheme(
        data: ScrollbarThemeData(
          thickness: MaterialStateProperty.all(5),
        ),
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
                surfaceTintColor: Theme.of(context).colorScheme.background,
                backgroundColor: Theme.of(context).colorScheme.background,
                elevation: 3,
                title: AnimatedOpacity(
                  opacity: isScrolled ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Text(sectionTitle),
                )),
            SliverFillRemaining(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.93,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          sectionTitle,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 13),
                    for (var vendor in vendors)
                      VendorCard(
                        key: Key(vendor.id.toString()),
                        vendor: vendor,
                        searchListView: true,
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
