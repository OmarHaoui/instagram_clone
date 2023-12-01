import 'package:flutter/material.dart';
import 'package:omar/screens/add_post_screen.dart';
import 'package:omar/screens/feed_screen.dart';

const webScreenSize = 600;

var homeScreenItems = [
  FeedScreen(),
  Center(
    child: Text('search'),
  ),
  AddPostScreen(),
  Center(
    child: Text('favorite'),
  ),
  Center(
    child: Text('profile'),
  ),
];
