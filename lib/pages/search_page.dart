import 'dart:developer';

import 'package:chat_demo/helper/helper_function.dart';
import 'package:chat_demo/pages/chat_page.dart';
import 'package:chat_demo/service/database_service.dart';
import 'package:chat_demo/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../theme/app_theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  bool isJoined = false;
  User? user;

  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        // backgroundColor: Theme.of(context).primaryColor,
        title: FxText.bodyMedium(
          "Search Group",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: FxSpacing.only(left: 20, right: 20, top: 20),
          //   child: FxContainer(
          //     borderRadiusAll: 4,
          //     padding: FxSpacing.all(8),
          //     height: 50,
          //     child: Row(
          //       children: <Widget>[
          //         Expanded(
          //           child: Container(
          //             margin: const EdgeInsets.only(left: 16),
          //             child: TextFormField(
          //               style: FxTextStyle.bodyMedium(
          //                   letterSpacing: 0,
          //                   color: Colors.black,
          //                   fontWeight: 500),
          //               decoration: InputDecoration(
          //                 hintText: "Search messages",
          //                 hintStyle: FxTextStyle.bodyMedium(
          //                     letterSpacing: 0,
          //                     color: Colors.black54,
          //                     fontWeight: 500),
          //                 border: const OutlineInputBorder(
          //                     borderRadius: BorderRadius.all(
          //                       Radius.circular(8),
          //                     ),
          //                     borderSide: BorderSide.none),
          //                 enabledBorder: const OutlineInputBorder(
          //                     borderRadius: BorderRadius.all(
          //                       Radius.circular(8),
          //                     ),
          //                     borderSide: BorderSide.none),
          //                 focusedBorder: const OutlineInputBorder(
          //                     borderRadius: BorderRadius.all(
          //                       Radius.circular(8),
          //                     ),
          //                     borderSide: BorderSide.none),
          //                 isDense: true,
          //                 contentPadding: const EdgeInsets.all(0),
          //               ),
          //               textInputAction: TextInputAction.search,
          //               textCapitalization: TextCapitalization.sentences,
          //             ),
          //           ),
          //         ),
          //         GestureDetector(
          //           onTap: () {
          //             initiateSearchMethod();
          //           },
          //           child: Container(
          //             padding: const EdgeInsets.all(4),
          //             decoration: const BoxDecoration(
          //                 color: Colors.indigoAccent,
          //                 borderRadius: BorderRadius.all(Radius.circular(4))),
          //             child: const Icon(
          //               MdiIcons.magnify,
          //               color: Colors.white,
          //               size: 20,
          //             ),
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          Padding(
            padding: FxSpacing.only(left: 20, right: 20, top: 20),
            child: Container(
              decoration: BoxDecoration(
                  // color: Colors.indigoAccent,
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4)),
              padding: const EdgeInsets.symmetric(vertical: 10),
              // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 16),
                      child: TextFormField(
                        controller: searchController,
                        style: FxTextStyle.bodyMedium(
                            letterSpacing: 0,
                            color: Colors.black,
                            fontWeight: 500),
                        decoration: InputDecoration(
                          // border: InputBorder.none,
                          hintText: "Search groups....",
                          hintStyle: FxTextStyle.bodyMedium(
                              letterSpacing: 0,
                              color: Colors.black54,
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
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearchMethod();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          // color: Colors.indigoAccent,
                          color: theme.colorScheme.primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4))),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 29,
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.indigo),
                )
              : groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    log('init');
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService()
          .searchByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                userName,
                searchSnapshot!.docs[index]['groupId'],
                searchSnapshot!.docs[index]['groupName'],
                searchSnapshot!.docs[index]['admin'],
              );
            },
          )
        : Container(
            child: FxText.bodyMedium("Search Your Groups!!"),
          );
  }

  joinedOrNot(
      String userName, String groupId, String groupname, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupname, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    // function to check whether user already exists in group
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.indigoAccent.shade200,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title:
          Text(groupName, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid)
              .toggleGroupJoin(groupId, userName, groupName);
          if (isJoined) {
            setState(() {
              isJoined = !isJoined;
            });
            showSnackbar(context, Colors.green, "Successfully joined he group");
            Future.delayed(const Duration(seconds: 2), () {
              nextScreen(
                  context,
                  ChatPage(
                      groupId: groupId,
                      groupName: groupName,
                      userName: userName));
            });
          } else {
            setState(() {
              isJoined = !isJoined;
              showSnackbar(context, Colors.indigo, "Left the group $groupName");
            });
          }
        },
        child: isJoined
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Joined",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.indigoAccent
                    // color: Theme.of(context).primaryColor,
                    ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text("Join Now",
                    style: TextStyle(color: Colors.white)),
              ),
      ),
    );
  }
}
