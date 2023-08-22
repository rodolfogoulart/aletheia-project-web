import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'gradient.custom.dart';
import 'http.request.dart';
import 'model/data.cards.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

///Para versão web ter o Scroll na Horizontal
///
///https://docs.flutter.dev/release/breaking-changes/default-scroll-behavior-drag#setting-a-custom-scrollbehavior-for-a-specific-widget
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aletheia',
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff042b4a), brightness: Brightness.dark),
      ),
      home: FutureBuilder(
        future: requestAllData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            isLoading.value = true;
          } else {
            isLoading.value = false;
          }
          return const MyHomePage(title: 'Aletheia');
        },
      ),
      scrollBehavior: MyCustomScrollBehavior(),
    );
  }
}

ValueNotifier<String?> body = ValueNotifier<String?>('');
ValueNotifier<String?> bottom = ValueNotifier<String?>('');
ValueNotifier<List<DataCards>?> cards = ValueNotifier<List<DataCards>?>([]);
ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);

requestAllData() async {
  body.value = await requestDataBody();
  bottom.value = await requestDataBottom();
  cards.value = await requestDataCards();
}

Future<void> _launchUrl(url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $uri');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    TextStyle style = GoogleFonts.libreFranklin().copyWith(fontSize: 25);
    // TextStyle style = GoogleFonts.cormorantUnicase().copyWith(fontSize: 25);
    var screenWidth = MediaQuery.of(context).size.width;
    // var screenHeight = MediaQuery.of(context).size.height;
    var controllerScrollPage = ScrollController();

    ValueNotifier turnRow = ValueNotifier(false);
    controllerScrollPage.addListener(() {
      if (controllerScrollPage.offset > 50) {
        turnRow.value = true;
      } else {
        turnRow.value = false;
      }
    });

    bool isMobile = screenWidth < 400;
    double titleSize = 72;
    if (isMobile) {
      titleSize /= 2;
      style = style.copyWith(fontSize: 16);
    }

    //
    return CustomGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              width: screenWidth,
              child: ValueListenableBuilder(
                  valueListenable: turnRow,
                  builder: (context, value, child) {
                    Widget text = Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 25, 8),
                      child: FittedBox(
                        child: RepaintBoundary(
                          child: SizedBox(
                            height: titleSize + 8,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Builder(builder: (context) {
                                  ValueNotifier textProject = ValueNotifier('Aletheia');
                                  return MouseRegion(
                                    onEnter: (event) {
                                      textProject.value = 'ἀλήθεια'.capitalize;
                                    },
                                    onExit: (event) {
                                      textProject.value = 'Aletheia';
                                    },
                                    child: ValueListenableBuilder(
                                        valueListenable: textProject,
                                        builder: (context, value, child) {
                                          return SizedBox(
                                            width: 9 * (titleSize * .5),
                                            child: Text(
                                              textProject.value,
                                              style: GoogleFonts.cormorantUnicase().copyWith(
                                                color: Colors.white,
                                                fontSize: titleSize,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }),
                                  );
                                }),
                                Text(
                                  ' Project',
                                  style: GoogleFonts.cormorantUnicase().copyWith(
                                    color: Colors.white,
                                    fontSize: titleSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                    Widget image = Image.asset('assets/images/aletheia-icon.png',
                        fit: BoxFit.scaleDown, width: isMobile ? 42 : 128, height: isMobile ? 42 : 128);
                    // .animate(
                    //   delay: 2.seconds,
                    //   onComplete: (controller) {
                    //     controller.repeat(period: 3.seconds);
                    //   },
                    // )
                    // .shimmer(duration: 3.seconds, delay: 2.seconds);

                    return turnRow.value
                        ? Builder(builder: (context) {
                            var widget = Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: image,
                                ),
                                text
                              ],
                            ).animate().fade(duration: 300.milliseconds);
                            if (isMobile) {
                              return FittedBox(child: widget);
                            }
                            return widget;
                          })
                        : Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [text, image],
                          ).animate().fade(duration: 300.milliseconds);
                  }),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ValueListenableBuilder(
                    valueListenable: isLoading,
                    builder: (context, value, child) {
                      if (isLoading.value) {
                        return Center(
                                child: Text('Carregando...', style: style)
                                    .animate(
                                      delay: 2.seconds,
                                      onComplete: (controller) {
                                        controller.repeat(period: 3.seconds);
                                      },
                                    )
                                    .shimmer(duration: 3.seconds, delay: 2.seconds))
                            .animate()
                            .fade();
                      }

                      return SingleChildScrollView(
                        controller: controllerScrollPage,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: isMobile ? 10 : 25, right: isMobile ? 10 : 25),
                              child: ValueListenableBuilder(
                                valueListenable: body,
                                builder: (context, value, child) {
                                  // if (snapshot.connectionState == ConnectionState.waiting) {
                                  //   return const Center(child: CircularProgressIndicator.adaptive());
                                  // }
                                  if (body.value?.isNotEmpty == true) {
                                    //https://editorhtmlonline.clevert.com.br/html.php
                                    return Html(
                                      data: body.value!,
                                      onLinkTap: (url, attributes, element) async {
                                        await _launchUrl(url);
                                      },
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 50, bottom: 50),
                              child: Builder(builder: (context) {
                                var controllerScroll = ScrollController();
                                return Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: isMobile ? 4 : 8),
                                      child: IconButton(
                                          onPressed: () async {
                                            await controllerScroll.animateTo(controllerScroll.offset - 250,
                                                duration: 200.milliseconds, curve: Curves.bounceInOut);
                                          },
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            size: 35,
                                          )).animate().fade(),
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        controller: controllerScroll,
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        child: ValueListenableBuilder(
                                          valueListenable: cards,
                                          builder: (context, value, child) {
                                            if (value?.isNotEmpty == true) {
                                              return Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: value!.map((e) {
                                                  return CardImages(
                                                      style: style,
                                                      image: e.url,
                                                      title: e.title,
                                                      subtitle: e.subtitle,
                                                      asset: e.asset);
                                                }).toList(),
                                              );
                                            }
                                            return Container();
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: isMobile ? 4 : 8),
                                      child: IconButton(
                                          onPressed: () async {
                                            await controllerScroll.animateTo(controllerScroll.offset + 250,
                                                duration: 200.milliseconds, curve: Curves.bounceInOut);
                                          },
                                          icon: const Icon(
                                            Icons.arrow_forward,
                                            size: 35,
                                          )).animate().fade(),
                                    ),
                                  ],
                                );
                              }),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: isMobile ? 50 : 100, bottom: 30),
                              child: Builder(builder: (context) {
                                var bottomStyle = style.copyWith(fontSize: style.fontSize! - 3, color: Colors.white);
                                return SizedBox(
                                  width: screenWidth,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Divider(),
                                      const SizedBox(height: 30),
                                      ValueListenableBuilder(
                                        valueListenable: bottom,
                                        builder: (context, value, child) {
                                          if (value?.isNotEmpty == true) {
                                            //https://editorhtmlonline.clevert.com.br/html.php
                                            return Html(
                                              data: value!,
                                              onLinkTap: (url, attributes, element) async {
                                                await _launchUrl(url);
                                              },
                                            );
                                          }
                                          return Container();
                                        },
                                      ),
                                      // RichText(
                                      //     textAlign: TextAlign.center,
                                      //     text: TextSpan(
                                      //       style: bottomStyle,
                                      //       children: [
                                      //         TextSpan(
                                      //           text: 'I53',
                                      //           style: bottomStyle.copyWith(fontSize: 42),
                                      //         ),
                                      //         const TextSpan(
                                      //             text: '\n\nEste é um projeto de um Missionário e desenvolvedor por hobby.'),
                                      //         const TextSpan(
                                      //             text:
                                      //                 '\n\nMeu anseio é que esta ferramenta seja uma benção em sua vida, que você dia a dia venha ir mais profundo na palavra,'),
                                      //         const TextSpan(
                                      //             text:
                                      //                 ' \ne que a palavra de Deus venha ser falada com sabedoria e poder no Espírito Santo para que todos venham conhecer nosso Senhor Jesus Cristo.'),
                                      //         const TextSpan(
                                      //             text:
                                      //                 '\n\nQue o Ide venha ser cumprido, e que Todos os Povos venham ouvir das boas novas do Reino de Deus, então finalmente encontraremos nosso Senhor.'),
                                      //         const TextSpan(
                                      //             text:
                                      //                 '\n\nDeseja saber mais ou contribuir para o projeto (financeiramente e no desenvolvimento), entre em contato:\n'),
                                      //         const TextSpan(text: 'Instagram '),
                                      //         TextSpan(
                                      //             text: 'rm_goulart',
                                      //             style: style.copyWith(
                                      //               color: Colors.blue.shade300,
                                      //               decoration: TextDecoration.underline,
                                      //               decorationColor: Colors.blue.shade300,
                                      //             ),
                                      //             recognizer: TapGestureRecognizer()
                                      //               ..onTap = () async {
                                      //                 await _launchUrl('https://www.instagram.com/rm_goulart/');
                                      //               }),
                                      //       ],
                                      //     )),
                                    ],
                                  ),
                                );
                              }),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardImages extends StatelessWidget {
  const CardImages({
    super.key,
    required this.style,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.asset,
  });
  final TextStyle style;
  final String image;
  final String title;
  final String? subtitle;
  final bool asset;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    bool isMobile = screenWidth < 400;

    return SizedBox(
      width: isMobile ? screenWidth * .6 : 512,
      child: Card(
        elevation: 1,
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        // title:
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      size: isMobile ? null : 35,
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: isMobile ? screenWidth : screenWidth * .75,
                              height: isMobile ? null : screenHeight * .75,
                              child: asset
                                  ? Image.asset(
                                      image,
                                      fit: BoxFit.fitWidth,
                                      width: isMobile ? screenWidth : 512,
                                    )
                                  : Image.network(
                                      image,
                                      fit: BoxFit.fitWidth,
                                      width: isMobile ? screenWidth : 512,
                                    ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Image.asset(
                image,
                fit: BoxFit.scaleDown,
              ),
            ),
            ListTile(
              title: Text(
                title,
                style: style,
              ),
              subtitle: subtitle != null ? Text(subtitle ?? '', style: style) : null,
            )
          ],
        ),
      ),
    ).animate().fade();
  }
}
