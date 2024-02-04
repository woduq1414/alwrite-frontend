import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const SideBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('SideBar'));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(230, 31, 31, 31),
      ),
      width: 250,
      child: Column(
        children: [
          SizedBox(
            height: 150,
          ),
          SideBarMenu(
              isActive: navigationShell.currentIndex == 0,
              route: '/home',
              icon: Icon(Icons.home,color: Color.fromARGB(255, 62, 117, 161)),
              label: '홈'),
          SideBarMenu(
              isActive: navigationShell.currentIndex == 1,
              route: '/document',
              icon: Icon(Icons.document_scanner_outlined,color:  Color.fromARGB(255, 62, 117, 161)),
              label: '인용문 찾기'),
          SideBarMenu(
              isActive: navigationShell.currentIndex == 2,
              route: '/graph',
              icon: Icon(Icons.bar_chart, color:Color.fromARGB(255, 62, 117, 161)),
              label: '그래프 제작소'),
        ],
      ),
    );
  }
}

class SideBarMenu extends StatelessWidget {
  final bool isActive;
  final String route;
  final Icon icon;
  final String label;
  const SideBarMenu(
      {required this.isActive,
      required this.route,
      required this.icon,
      required this.label,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).go(route);
      },
      child: Material(
        color: isActive ? const Color.fromARGB(255, 48, 60, 70) : Colors.transparent,
        child: ListTile(
          
          leading: icon,
          title: Text(
            label,
            style: TextStyle(color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
