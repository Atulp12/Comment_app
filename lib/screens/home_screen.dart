import 'package:comment_app/providers/comment_provider.dart';

import 'package:comment_app/utils/colors.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool maskEmail = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<CommentProvider>(context, listen: false);
      provider.getAllComments();
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.fetch();
      await remoteConfig.fetchAndActivate();
      setState(() {
        maskEmail = remoteConfig.getBool('mask_email');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CommentProvider>(context);
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        title: const Text(
          'Comment',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      body: provider.isLoading
          ? loadingScreen()
          : provider.error.isNotEmpty
              ? errorScreen(provider.error)
              : ListView.builder(
                  itemCount: provider.comment.length,
                  itemBuilder: (context, index) {
                    final comment = provider.comment[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Card(
                        elevation: 0,
                        child: Container(
                          height: 150,
                          width: 450,
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: greyColor,
                                child: Text(
                                  comment.name[0].toUpperCase(),
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      color: boldColor,
                                      fontSize: 18),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Name: ',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontStyle: FontStyle.italic,
                                            color: greyColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            comment.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Email: ',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontStyle: FontStyle.italic,
                                            color: greyColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            maskEmail
                                                ? maskEmailString(comment.email)
                                                : comment.email,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      comment.body,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 4,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget loadingScreen() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget errorScreen(String error) {
    return Center(
      child: Text(error),
    );
  }

  String maskEmailString(String email) {
    if (email.length <= 3) {
      return email;
    }
    int atIndex = email.indexOf('@');
    if (atIndex <= 3) {
      return email;
    }

    String firstPart = email.substring(0, 3);
    String domainPart = email.substring(atIndex);
    String maskedPart =
        email.substring(3, atIndex).replaceAll(RegExp(r'[a-zA-Z0-9_.]'), '*');
    return '$firstPart$maskedPart$domainPart';
  }
}
