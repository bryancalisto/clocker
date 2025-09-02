import 'package:clocker/factories/platform_wrapper.dart';
import 'package:clocker/state.dart';
import 'package:clocker/views/chronometer_vw.dart';
import 'package:clocker/views/timer_vw.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class App extends StatelessWidget {
  final GetIt getIt;
  const App({Key? key, required this.getIt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: getIt<AppState>().themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          color: Colors.transparent,
          theme: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light().copyWith(
              primary: Colors.black,
              onPrimary: Colors.white,
            ),
            splashFactory: InkRipple.splashFactory,
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.light().copyWith(
              primary: const Color(0xff711c91),
              onPrimary: const Color(0xffea00d9),
              secondary: const Color(0xff133e7c),
              onSecondary: const Color(0xff0abdc6),
            ),
            splashFactory: InkRipple.splashFactory,
          ),
          themeMode: currentMode,
          home: createPlatformWrapper(const MainView()),
        );
      },
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = GetIt.I<AppState>().themeNotifier.value == ThemeMode.dark;
    final tabBarColor = isDark ? Colors.white : Colors.black;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: tabBarColor,
            labelColor: tabBarColor,
            unselectedLabelColor: tabBarColor.withOpacity(0.5),
            tabs: const [
              Tab(text: 'Chronometer'),
              Tab(text: 'Timer'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ChronometerVw(),
                TimerVw(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
