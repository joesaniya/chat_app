import 'dart:developer';
import 'package:chat_demo/pages/profile_page.dart';
import 'package:chat_demo/pages/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../helper/helper_function.dart';
import '../service/auth_service.dart';
import '../service/database_service.dart';
import '../theme/app_theme.dart';
import '../widgets/group_tile.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    gettingUserData();
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
            body: ListView(
          padding: FxSpacing.zero,
          children: <Widget>[
            Container(
              color: theme.colorScheme.primary,
              padding: FxSpacing.fromLTRB(0, 42, 0, 32),
              child: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: FxSpacing.left(32),
                        child: FxText.headlineSmall("Chats",
                            color: theme.colorScheme.onPrimary,
                            fontWeight: 700),
                      ),
                      Container(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage(
                                              userName: userName,
                                              email: email,
                                            )));
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: theme.colorScheme.onPrimary,
                                // child: const Text(
                                //   'A',
                                //   // email[0].toUpperCase(),
                                //   textAlign: TextAlign.center,
                                //   style: TextStyle(
                                //       color: Colors.indigoAccent,
                                //       fontWeight: FontWeight.w500),
                                // ),
                                child: const Image(
                                    image: AssetImage(
                                        'assets/profile-outline.png')),
                              ),
                            ),
                            FxSpacing.width(10)
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: FxSpacing.top(16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: FxSpacing.left(20),
                              child: InkWell(
                                onTap: () {
                                  popUpDialog(context);
                                },
                                child: Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: theme.colorScheme.onPrimary
                                          .withAlpha(90),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                  padding: FxSpacing.fromLTRB(16, 16, 0, 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4)),
                                            color: theme.colorScheme.onPrimary),
                                        padding: FxSpacing.all(2),
                                        child: Icon(
                                          Icons.add,
                                          size: 18,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                      Container(
                                        margin: FxSpacing.top(8),
                                        child: FxText.titleSmall('New Chat',
                                            color: theme.colorScheme.onPrimary),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: theme.colorScheme.primary,
              child: Container(
                decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))),
                // padding: FxSpacing.all(20),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: FxSpacing.only(left: 20, right: 20, top: 20),
                      child: GestureDetector(
                        onTap: () {
                          log('search');
                          nextScreen(context, const SearchPage());
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             const SearchPage()));
                        },
                        child: FxContainer(
                          borderRadiusAll: 4,
                          padding: FxSpacing.all(8),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 16),
                                  child: TextFormField(
                                    keyboardType: TextInputType.none,
                                    showCursor: true,
                                    readOnly: true,
                                    style: FxTextStyle.bodyMedium(
                                        letterSpacing: 0,
                                        color: theme.colorScheme.onBackground,
                                        fontWeight: 500),
                                    decoration: InputDecoration(
                                      hintText: "Search messages",
                                      hintStyle: FxTextStyle.bodyMedium(
                                          letterSpacing: 0,
                                          color: theme.colorScheme.onBackground,
                                          fontWeight: 500),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          borderSide: BorderSide.none),
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          borderSide: BorderSide.none),
                                      focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          borderSide: BorderSide.none),
                                      isDense: true,
                                      contentPadding: const EdgeInsets.all(0),
                                    ),
                                    textInputAction: TextInputAction.search,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4))),
                                child: Icon(
                                  MdiIcons.magnify,
                                  color: theme.colorScheme.onPrimary,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   margin: FxSpacing.top(20),
                    // ),
                    groupList(),
                  ],
                ),
              ),
            )
          ],
        )));

    // return Scaffold(
    //   appBar: AppBar(
    //     actions: [
    //       IconButton(
    //           onPressed: () {
    //             nextScreen(context, const SearchPage());
    //           },
    //           icon: const Icon(
    //             Icons.search,
    //           ))
    //     ],
    //     elevation: 0,
    //     centerTitle: true,
    //     backgroundColor: Theme.of(context).primaryColor,
    //     title: const Text(
    //       "Groups",
    //       style: TextStyle(
    //           color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
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
    //         userName,
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
    //         onTap: () {},
    //         selectedColor: Theme.of(context).primaryColor,
    //         selected: true,
    //         contentPadding:
    //             const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    //         leading: const Icon(Icons.group),
    //         title: const Text(
    //           "Groups",
    //           style: TextStyle(color: Colors.black),
    //         ),
    //       ),
    //       ListTile(
    //         onTap: () {
    //           nextScreenReplace(
    //               context,
    //               ProfilePage(
    //                 userName: userName,
    //                 email: email,
    //               ));
    //         },
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
    //   body: groupList(),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       popUpDialog(context);
    //     },
    //     elevation: 0,
    //     backgroundColor: Theme.of(context).primaryColor,
    //     child: const Icon(
    //       Icons.add,
    //       color: Colors.white,
    //       size: 30,
    //     ),
    //   ),
    // );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Create a group",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.indigoAccent),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.indigoAccent),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.indigoAccent),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(userName,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackbar(
                          context, Colors.green, "Group created successfully.");
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  child: const Text("CREATE"),
                )
              ],
            );
          }));
        });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['fullName']);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
              ),
            ],
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // GestureDetector(
          //   onTap: () {
          //     popUpDialog(context);
          //   },
          //   child: Icon(
          //     Icons.add_circle,
          //     color: Colors.grey[700],
          //     size: 75,
          //   ),
          // ),
          const SizedBox(
            height: 20,
          ),
          FxText.bodyLarge(
            "You've not joined any groups, tap on the New Chat to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
