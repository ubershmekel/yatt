import 'package:flutter/material.dart';
import 'package:yout/src/language_select/language_select_view.dart';

class Page {
  final String text;
  final String image;
  final String buttonText;

  Page({required this.text, required this.image, required this.buttonText});
}

class WelcomeView extends StatelessWidget {
  WelcomeView({super.key});
  final PageController controller = PageController();

  final List<Page> _pages = [
    Page(
        text: 'Listen to a phrase in your native language',
        image: 'assets/images/speaker.png',
        buttonText: 'Cool'),
    Page(
        text: "Then say it out loud in the language you're learning",
        image: 'assets/images/speech_balloon.png',
        buttonText: 'Got it'),
    Page(
        text: 'Hands-free language learning...',
        image: 'assets/images/all_flags.png',
        buttonText: "Next"),
    Page(
        text: 'You are the translator',
        image: 'assets/images/3.0x/yatt_logo.png',
        buttonText: "Let's start!"),
  ];

  Widget _imageTextButton(BuildContext context, Page page) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Image.asset(page.image),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(page.text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 30.0, fontWeight: FontWeight.bold)),
          ),
          FloatingActionButton.extended(
              // `heroTag` to avoid " multiple heroes that share the same tag within a subtree" error
              // https://stackoverflow.com/a/69342661/177498
              heroTag: UniqueKey(),
              icon: const Icon(Icons.arrow_forward),
              label: Text(page.buttonText),
              onPressed: () {
                final currentPage = controller.page!.round();
                if (currentPage < _pages.length - 1) {
                  controller.animateToPage(currentPage + 1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut);
                } else {
                  Navigator.restorablePopAndPushNamed(
                    context,
                    LanguageItemListView.nativeRoute,
                  );
                }
              })
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
            controller: controller,
            children: _pages.map((Page page) {
              return _imageTextButton(context, page);
            }).toList()));
  }
}
