import 'dart:developer';

import 'package:chat_demo/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutx/flutx.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;
  ProfilePage({Key? key, required this.email, required this.userName})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                FeatherIcons.chevronLeft,
                color: Colors.indigoAccent,
              )),
          centerTitle: true,
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          color: Colors.white,
          height: 500,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
          // padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('assets/profile-outline.png'),
                      // ("assets/avatar_2.jpg"),
                      fit: BoxFit.fill),
                ),
                // child: const Icon(Icons.account_circle),
              ),
              FxText.headlineSmall(widget.userName,
                  fontWeight: 700, letterSpacing: 0),
              FxText.titleSmall(widget.email, fontWeight: 600),
              FxSpacing.height(60),
              FxButton.rounded(
                onPressed: () async {
                  log('logout clicked');
                  AuthService().signOut(context);
                  // await GoogleSignIn().signOut();
                  // await authService.signOut(context);
                  // Navigator.of(context).pushAndRemoveUntil(
                  //     MaterialPageRoute(
                  //         builder: (context) => const LoginScreen()),
                  //     (route) => false);
                },
                elevation: 2,
                backgroundColor: const Color(0xff1529e8),
                child: FxText.labelLarge(
                  "LOGOUT",
                  color: Colors.white,
                ),
              )
            ],
          ),
        ));

    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: const Color(0xff3C4EC5),
    //     // backgroundColor: Theme.of(context).primaryColor,
    //     elevation: 0,
    //     title: FxText.bodyMedium(
    //       "Profile",
    //       style: const TextStyle(color: Colors.white),
    //     ),
    //   ),
    //   drawer: Drawer(
    //       child: ListView(
    //     padding: const EdgeInsets.symmetric(vertical: 50),
    //     children: <Widget>[
    //       Icon(
    //         Icons.account_circle,
    //         size: 150,
    //         color: Colors.grey[700],
    //       ),
    //       const SizedBox(
    //         height: 15,
    //       ),
    //       Text(
    //         widget.userName,
    //         textAlign: TextAlign.center,
    //         style: const TextStyle(fontWeight: FontWeight.bold),
    //       ),
    //       const SizedBox(
    //         height: 30,
    //       ),
    //       const Divider(
    //         height: 2,
    //       ),
    //       ListTile(
    //         onTap: () {
    //           nextScreen(context, const HomePage());
    //         },
    //         contentPadding:
    //             const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    //         leading: const Icon(Icons.group),
    //         title: const Text(
    //           "Groups",
    //           style: TextStyle(color: Colors.black),
    //         ),
    //       ),
    //       ListTile(
    //         onTap: () {},
    //         selected: true,
    //         selectedColor: Theme.of(context).primaryColor,
    //         contentPadding:
    //             const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    //         leading: const Icon(Icons.group),
    //         title: const Text(
    //           "Profile",
    //           style: TextStyle(color: Colors.black),
    //         ),
    //       ),
    //       ListTile(
    //         onTap: () async {
    //           showDialog(
    //               barrierDismissible: false,
    //               context: context,
    //               builder: (context) {
    //                 return AlertDialog(
    //                   title: const Text("Logout"),
    //                   content: const Text("Are you sure you want to logout?"),
    //                   actions: [
    //                     IconButton(
    //                       onPressed: () {
    //                         Navigator.pop(context);
    //                       },
    //                       icon: const Icon(
    //                         Icons.cancel,
    //                         color: Colors.red,
    //                       ),
    //                     ),
    //                     IconButton(
    //                       onPressed: () async {
    //                         await authService.signOut();
    //                         Navigator.of(context).pushAndRemoveUntil(
    //                             MaterialPageRoute(
    //                                 builder: (context) => const LoginPage()),
    //                             (route) => false);
    //                       },
    //                       icon: const Icon(
    //                         Icons.done,
    //                         color: Colors.green,
    //                       ),
    //                     ),
    //                   ],
    //                 );
    //               });
    //         },
    //         contentPadding:
    //             const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    //         leading: const Icon(Icons.exit_to_app),
    //         title: const Text(
    //           "Logout",
    //           style: TextStyle(color: Colors.black),
    //         ),
    //       )
    //     ],
    //   )),
    //   body: Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: [
    //         Icon(
    //           Icons.account_circle,
    //           size: 200,
    //           color: Colors.grey[700],
    //         ),
    //         const SizedBox(
    //           height: 15,
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             const Text("Full Name", style: TextStyle(fontSize: 17)),
    //             Text(widget.userName, style: const TextStyle(fontSize: 17)),
    //           ],
    //         ),
    //         const Divider(
    //           height: 20,
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             const Text("Email", style: TextStyle(fontSize: 17)),
    //             Text(widget.email, style: const TextStyle(fontSize: 17)),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
