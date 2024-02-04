// import 'package:alwrite/controllers/StatController.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:get/get.dart';

// Future<void> main() async {
//   runApp(
//     StatefulShellRouteExampleApp(),
//   );
// }

// class ScaffoldBottomNavigationBar extends StatelessWidget {
//   const ScaffoldBottomNavigationBar({
//     required this.navigationShell,
//     Key? key,
//   }) : super(key: key ?? const ValueKey<String>('ScaffoldBottomNavigationBar'));

//   final StatefulNavigationShell navigationShell;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: navigationShell,
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Section_A'),
//           BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Section_B'),
//         ],
//         currentIndex: navigationShell.currentIndex,
//         onTap: (int tappedIndex) {
//           navigationShell.goBranch(tappedIndex);
//         },
//       ),
//     );
//   }
// }

// class StatefulShellRouteExampleApp extends StatelessWidget {
//   StatefulShellRouteExampleApp({super.key});

//   final GoRouter _router = GoRouter(
//     initialLocation: '/login',
//     routes: <RouteBase>[
//       GoRoute(
//         path: '/login',
//         builder: (BuildContext context, GoRouterState state) {
//           return const LoginScreen();
//         },
//         routes: <RouteBase>[
//           GoRoute(
//             path: 'detailLogin',
//             builder: (BuildContext context, GoRouterState state) {
//               return const DetailLoginScreen();
//             },
//           ),
//         ],
//       ),
//       StatefulShellRoute.indexedStack(
//         builder: (BuildContext context, GoRouterState state,
//             StatefulNavigationShell navigationShell) {
//           return ScaffoldBottomNavigationBar(
//             navigationShell: navigationShell,
//           );
//         },
//         branches: <StatefulShellBranch>[
//           StatefulShellBranch(
//             routes: <RouteBase>[
//               GoRoute(
//                 path: '/sectionA',
//                 builder: (BuildContext context, GoRouterState state) {
//                   return const RootScreen(
//                     label: 'Section A',
//                     detailsPath: '/sectionA/details',
//                   );
//                 },
//                 routes: <RouteBase>[
//                   GoRoute(
//                     path: 'details',
//                     builder: (BuildContext context, GoRouterState state) {
//                       return const DetailsScreen(label: 'A');
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: <RouteBase>[
//               GoRoute(
//                 path: '/sectionB',
//                 builder: (BuildContext context, GoRouterState state) {
//                   return const RootScreen(
//                     label: 'Section B',
//                     detailsPath: '/sectionB/details',
//                   );
//                 },
//                 routes: <RouteBase>[
//                   GoRoute(
//                     path: 'details',
//                     builder: (BuildContext context, GoRouterState state) {
//                       return const DetailsScreen(label: 'B');
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     ],
//   );

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'Go_router Complex Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.orange,
//       ),
//       routerConfig: _router,
//     );
//   }
// }

// class RootScreen extends StatelessWidget {
//   const RootScreen({
//     required this.label,
//     required this.detailsPath,
//     super.key,
//   });

//   final String label;
//   final String detailsPath;

//   @override
//   Widget build(BuildContext context) {
//     final Controller c = Get.put(Controller());

//     return Scaffold(
//       appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Text(
//               'Screen $label',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const Padding(padding: EdgeInsets.all(4)),
//             TextButton(
//               onPressed: () {
//                 c.increment();
//                 GoRouter.of(context).go(detailsPath);
//               },
//               child: const Text('View details'),
//             ),
//             const Padding(padding: EdgeInsets.all(4)),
//             TextButton(
//               onPressed: () {
//                 GoRouter.of(context).go('/login');
//               },
//               child: const Text('Logout'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DetailsScreen extends StatefulWidget {
//   const DetailsScreen({
//     required this.label,
//     super.key,
//   });

//   final String label;

//   @override
//   State<StatefulWidget> createState() => DetailsScreenState();
// }

// class DetailsScreenState extends State<DetailsScreen> {
//   int _counter = 0;

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Details Screen - ${widget.label}'),
//       ),
//       body: _build(context),
//     );
//   }

//   Widget _build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Text(
//             'Details for ${widget.label} - Counter: $_counter',
//             style: Theme.of(context).textTheme.titleLarge,
//           ),
//           const Padding(padding: EdgeInsets.all(4)),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 _counter++;
//               });
//             },
//             child: const Text('Increment counter'),
//           ),
//           const Padding(padding: EdgeInsets.all(8)),
//           const Padding(padding: EdgeInsets.all(4)),
//           TextButton(
//             onPressed: () {
//               GoRouter.of(context).go('/login');
//             },
//             child: const Text('Logout'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final Controller c = Get.put(Controller());

//     return Scaffold(
//       appBar: AppBar(title: Text("${c.count}")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 context.go('/login/detailLogin');
//               },
//               child: const Text('Go to the Details Login screen'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DetailLoginScreen extends StatelessWidget {
//   const DetailLoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Details Login Screen')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <ElevatedButton>[
//             ElevatedButton(
//               onPressed: () {
//                 // context.go('/sectionA');
//                 context.go('/sectionB');
//               },
//               child: const Text('Go to BottomNavBar'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
