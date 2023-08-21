import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'gradient.custom.dart';

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
      home: const MyHomePage(title: 'Aletheia'),
      scrollBehavior: MyCustomScrollBehavior(),
    );
  }
}

Future<void> _launchUrl(url) async {
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
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
    TextStyle style = GoogleFonts.anticDidone().copyWith(fontSize: 25);
    // TextStyle style = GoogleFonts.cormorantUnicase().copyWith(fontSize: 25);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var controllerScrollPage = ScrollController();

    ValueNotifier turnRow = ValueNotifier(false);
    controllerScrollPage.addListener(() {
      if (controllerScrollPage.offset > 50) {
        turnRow.value = true;
      } else {
        turnRow.value = false;
      }
    });

    var urlDownload = 'https://github.com/rodolfogoulart/aletheia-core-model/releases';

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
                      child: RepaintBoundary(
                        child: SizedBox(
                          height: 72 + 8,
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
                                          width: 8 * (72 * .5),
                                          child: Text(
                                            textProject.value,
                                            style: GoogleFonts.cormorantUnicase().copyWith(
                                              color: Colors.white,
                                              fontSize: 72,
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
                                  fontSize: 72,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    Widget image = RepaintBoundary(
                      child: Image.asset('assets/images/aletheia-icon-dpi130.png', fit: BoxFit.fitWidth, width: 128, height: 128)
                          .animate(
                            delay: 2.seconds,
                            onComplete: (controller) {
                              controller.repeat(period: 3.seconds);
                            },
                          )
                          .shimmer(duration: 3.seconds, delay: 2.seconds),
                    );

                    return turnRow.value
                        ? Row(
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
                          ).animate().fade(duration: 300.milliseconds)
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
                padding: const EdgeInsets.only(top: 25, left: 50, right: 50),
                child: SingleChildScrollView(
                  controller: controllerScrollPage,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableText.rich(
                        TextSpan(text: 'O que é o Projeto Aletheia?\n', children: [
                          const TextSpan(
                              text: ' * Projeto Aletheia é um software para estudo da Bíblia de forma mais aprofundada.\n'),
                          const TextSpan(
                              text:
                                  ' * O projeto tem como objetivo disponibilizar um software em diferentes plataforma para viabilizar o estudo bíblico mais aprofundado da palavra'),
                          const TextSpan(
                              text:
                                  '\n\nO Projeto Aletheia se define um projeto Cristão Protestante, portanto temos como objetivo ampliar a oportunidade de que pessoas simples venham ter uma ferramenta para estudo da biblia de forma mais simples e também aprofundada.'),
                          const TextSpan(text: '\n\nComo surgiu a idéia?\n'),
                          const TextSpan(
                              text:
                                  ' * A ideia do projeto Aletheia surgiu com a necessidade de uma plataforma para estudo da bíblia mais aprofundada, no começo a idéia era somente a visualização da bíblia off-line e mostrando uma versão para comparar. Não é como se fosse nova a idéia, sendo que encontramos vários sites na internet que disponibilizam ferramentas para comparar, mas o diferencial do Aletheia é que a comparação dos textos bíblicos se dá de verso a verso e mostrando todas as outras versões disponíveis. O projeto cresceu e surgiu idéias como [Referência Bíblica], [Anotações do Verso pessoal],  [Dicionário de palavras], [Comentário bíblico], [Dicionário Léxico (Strong)]. E assim o projeto tem estado em desenvolvimento para disponibilizar em uma só plataforma o máximo de funcionalidades e também de forma simples e bem usual.'),
                          const TextSpan(text: '\n\nOnde posso encontrar o projeto?\n'),
                          const TextSpan(
                              text:
                                  ' * O Projeto se encontra em desenvolvimento, mas pode ser baixado em uma pasta publica do projeto abaixo:\n\n'),
                          TextSpan(
                              text: urlDownload,
                              style: style.copyWith(
                                color: Colors.blue.shade300,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue.shade300,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await _launchUrl(urlDownload);
                                }),
                        ]),
                        style: style,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 50, left: 80, right: 80),
                        child: Builder(builder: (context) {
                          var controllerScroll = ScrollController();
                          return Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
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
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CardImages(
                                          style: style,
                                          image: 'assets/showcase/screen1.png',
                                          title: 'Tela inícial com Verso para comparar',
                                          subtitle: ''),
                                      CardImages(
                                          style: style,
                                          image: 'assets/showcase/screen2.png',
                                          title: 'Tela inícial com Refêrencias Verso',
                                          subtitle: ''),
                                      CardImages(
                                          style: style,
                                          image: 'assets/showcase/screen3.png',
                                          title: 'Tela inícial com Anotações Verso',
                                          subtitle: ''),
                                      CardImages(
                                          style: style,
                                          image: 'assets/showcase/screen4.png',
                                          title: 'Tela inícial de pesquisa',
                                          subtitle: ''),
                                      CardImages(
                                          style: style,
                                          image: 'assets/showcase/screen5.png',
                                          title: 'Tela inícial de pesquisa',
                                          subtitle: ''),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
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
                        padding: const EdgeInsets.only(top: 100, bottom: 30),
                        child: Builder(builder: (context) {
                          var bottomStyle = style.copyWith(fontSize: style.fontSize! - 3, color: Colors.white);
                          return SizedBox(
                            width: screenWidth,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Divider(),
                                const SizedBox(height: 30),
                                RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: bottomStyle,
                                      children: [
                                        TextSpan(
                                          text: 'I53',
                                          style: bottomStyle.copyWith(fontSize: 42),
                                        ),
                                        const TextSpan(
                                            text: '\n\nEste é um projeto de um Missionário e desenvolvedor por hobby.'),
                                        const TextSpan(
                                            text:
                                                '\n\nMeu anseio é que esta ferramenta seja uma benção em sua vida, que você dia a dia venha ir mais profundo na palavra,'),
                                        const TextSpan(
                                            text:
                                                ' \ne que a palavra de Deus venha ser falada com sabedoria e poder no Espírito Santo para que todos venham conhecer nosso Senhor Jesus Cristo.'),
                                        const TextSpan(
                                            text:
                                                '\n\nQue o Ide venha ser cumprido, e que Todos os Povos venham ouvir das boas novas do Reino de Deus, então finalmente encontraremos nosso Senhor.'),
                                        const TextSpan(
                                            text:
                                                '\n\nDeseja saber mais ou contribuir para o projeto (financeiramente e no desenvolvimento), entre em contato:\n'),
                                        const TextSpan(text: 'Instagram '),
                                        TextSpan(
                                            text: 'rm_goulart',
                                            style: style.copyWith(
                                              color: Colors.blue.shade300,
                                              decoration: TextDecoration.underline,
                                              decorationColor: Colors.blue.shade300,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                await _launchUrl('https://www.instagram.com/rm_goulart/');
                                              }),
                                      ],
                                    )),
                              ],
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                ),
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
  });
  final TextStyle style;
  final String image;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: 512,
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
                        title: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  size: 35,
                                )),
                          ],
                        ),
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(),
                        content: SizedBox(
                          width: screenWidth * .75,
                          height: screenHeight * .75,
                          child: Image.asset(
                            image,
                            fit: BoxFit.scaleDown,
                          ),
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
