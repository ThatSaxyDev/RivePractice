import 'package:anim/bottom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  //! list of pages
  List<Widget> pages = [
    Container(
      color: Colors.red,
    ),
    Container(
      color: Colors.blue,
    ),
    Container(
      color: Colors.green,
    ),
    Container(
      color: Colors.brown,
    ),
    Container(
      color: Colors.yellow,
    ),
  ];

  void updatePage(int page) {
    setState(() {
      currentActiveIndex = page;
    });
  }

  //! list of state machine inputs
  List<SMIInput<bool>?> inputs = [];

  //! list of artboards
  List<Artboard> artboards = [];

  //! list of rive asset paths
  List<String> assetPaths = [
    'assets/rive/landscape.riv',
    'assets/rive/flower.riv',
    'assets/rive/slider.riv',
    'assets/rive/fire.riv',
    'assets/rive/koala.riv',
  ];

  int currentActiveIndex = 0;

  initializeArtboard() async {
    for (var path in assetPaths) {
      //loop through the asset path
      final data = await rootBundle.load(path);

      final file = RiveFile.import(data); // import rive files
      final artboard = file.mainArtboard; //contains designs
      SMIInput<bool>? input;

      final controller =
          StateMachineController.fromArtboard(artboard, 'State Machine 1');
      if (controller != null) {
        artboard.addController(controller);
        input = controller.findInput<bool>('status');
        input!.value = true;
      }
      inputs.add(input);
      artboards.add(artboard);
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await initializeArtboard();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: pages[currentActiveIndex],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: artboards.map<Widget>((artboard) {
                    final index = artboards.indexOf(artboard);
                    return BottomAppBarItem(
                      artboard: artboard,
                      currentIndex: currentActiveIndex,
                      input: inputs[index],
                      tabIndex: index,
                      onpress: () {
                        setState(() {
                          currentActiveIndex = index;
                          updatePage(currentActiveIndex);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
