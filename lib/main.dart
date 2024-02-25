import 'package:alwrite/controllers/StatController.dart';
import 'package:alwrite/pages/documentSimilarPage.dart';
import 'package:alwrite/pages/documentWritePage.dart';
import 'package:alwrite/pages/graphEditPage.dart';
import 'package:alwrite/pages/graphRangePage.dart';
import 'package:alwrite/pages/graphSelectStatPage.dart';
import 'package:alwrite/widgets/SideBar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  Intl.defaultLocale = 'ko_KR';
  // setPathUrlStrategy();
  runApp(
    StatefulShellRouteExampleApp(),
  );
}

class ScaffoldSideBar extends StatelessWidget {
  const ScaffoldSideBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldSideBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        SideBar(navigationShell: navigationShell),
        Expanded(child: navigationShell),
      ]),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Section_A'),
      //     BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Section_B'),
      //   ],
      //   currentIndex: navigationShell.currentIndex,
      //   onTap: (int tappedIndex) {
      //     navigationShell.goBranch(tappedIndex);
      //   },
      // ),
    );
  }
}

class StatefulShellRouteExampleApp extends StatelessWidget {
  StatefulShellRouteExampleApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/home',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          return ScaffoldSideBar(
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home',
                builder: (BuildContext context, GoRouterState state) {
                  return const RootScreen(
                    label: 'home',
                    detailsPath: '/home/details',
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/document',
                builder: (BuildContext context, GoRouterState state) {
                  return DocumentWritePage();
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: 'result',
                    builder: (BuildContext context, GoRouterState state) {
                      return DocumentSimilarPage();
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/graph',
                builder: (BuildContext context, GoRouterState state) {
                  return GraphSelectStatPage();
                },
                routes: <RouteBase>[
                  GoRoute(
                      path: 'range',
                      builder: (BuildContext context, GoRouterState state) {
                        return GraphRangePage();
                      },
                      routes: [
                        GoRoute(
                          path: 'edit',
                          builder: (BuildContext context, GoRouterState state) {
                            return GraphEditPage();
                          },
                        ),
                      ]),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ALWRITE',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      routerConfig: _router,
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({
    required this.label,
    required this.detailsPath,
    super.key,
  });

  final String label;
  final String detailsPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: '국회 데이터를\n글쓰기에\n손쉽게 활용하세요.\n',
                style: TextStyle(fontSize: 80, height: 1.1),
              ),
              WidgetSpan(child: 
              SizedBox(
                height: 120,
              ),),
              TextSpan(
                text: 'ALWRITE',
                style: TextStyle(fontSize: 95, fontWeight:FontWeight.bold, color: Colors.blue, letterSpacing: 8),
              ),
            ]))
          ],
        ),
      ),
    );
  }
}

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    required this.label,
    super.key,
  });

  final String label;

  @override
  State<StatefulWidget> createState() => DetailsScreenState();
}

class DetailsScreenState extends State<DetailsScreen> {
  int _counter = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Screen - ${widget.label}'),
      ),
      body: _build(context),
    );
  }

  Widget _build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Details for ${widget.label} - Counter: $_counter',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Padding(padding: EdgeInsets.all(4)),
          TextButton(
            onPressed: () {
              setState(() {
                _counter++;
              });
            },
            child: const Text('Increment counter'),
          ),
          const Padding(padding: EdgeInsets.all(8)),
          const Padding(padding: EdgeInsets.all(4)),
          TextButton(
            onPressed: () {
              GoRouter.of(context).go('/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HELELO")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                context.go('/login/detailLogin');
              },
              child: const Text('Go to the Details Login screen'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailLoginScreen extends StatelessWidget {
  const DetailLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details Login Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <ElevatedButton>[
            ElevatedButton(
              onPressed: () {
                // context.go('/sectionA');
                context.go('/graph');
              },
              child: const Text('Go to BottomNavBar'),
            ),
          ],
        ),
      ),
    );
  }
}
