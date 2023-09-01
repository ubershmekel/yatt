import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  static const String routeName = '/welcome';

  Widget _imageTextButton(BuildContext context, Page page, List<Page> pages) {
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
                if (currentPage < pages.length - 1) {
                  controller.animateToPage(currentPage + 1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut);
                } else {
                  Navigator.restorablePopAndPushNamed(
                    context,
                    LanguageItemListView.learnRoute,
                  );
                }
              })
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final List<Page> pages = [
      Page(
          text: AppLocalizations.of(context)!.welcomeListen,
          image: 'assets/images/speaker.png',
          buttonText: AppLocalizations.of(context)!.cool),
      Page(
          text: AppLocalizations.of(context)!.welcomeSay,
          image: 'assets/images/speech_balloon.png',
          buttonText: AppLocalizations.of(context)!.gotit),
      Page(
          text: AppLocalizations.of(context)!.welcomeHandsFree,
          image: 'assets/images/all_flags.png',
          buttonText: AppLocalizations.of(context)!.next),
      Page(
          text: AppLocalizations.of(context)!.welcomeYouAreTheTranslator,
          image: 'assets/images/3.0x/yatt_logo.png',
          buttonText: AppLocalizations.of(context)!.letsStart),
    ];
    return Scaffold(
        body: PageView(
            controller: controller,
            children: pages.map((Page page) {
              return _imageTextButton(context, page, pages);
            }).toList()));
  }
}
