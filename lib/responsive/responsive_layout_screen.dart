import 'package:flutter/material.dart';
import 'package:omar/providers/user_provider.dart';
import 'package:omar/screens/login_screen.dart';
import 'package:omar/utils/dimensions.dart';
import 'package:provider/provider.dart';

class RsponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const RsponsiveLayout({
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  });

  @override
  State<RsponsiveLayout> createState() => _RsponsiveLayoutState();
}

class _RsponsiveLayoutState extends State<RsponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  // call the provider as soon as the Responsive class get started
  void addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          // show web screen
          return widget.webScreenLayout;
        }
        // show mobile screen
        return widget.mobileScreenLayout;
      },
    );
  }
}
