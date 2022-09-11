import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/bookmark_model.dart';
import 'login_screen.dart';

class BookmarkScreen extends StatefulWidget {
  final String name;
  final String id;
  const BookmarkScreen({Key? key, required this.name, required this.id})
      : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isLoading = true;
  late List<Bookmark> _bookmarks;
  late String _key;

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> getUserBookmarks(token) async {
    try {
      final Response response = await Dio().get(
          "https://api.libromarko.xyz/bookmark/group/${widget.id}",
          options: Options(headers: {"Authorization": "Bearer $token"}));

      setState(() {
        _bookmarks =
            (response.data as List).map((i) => Bookmark.fromJson(i)).toList();
        _isLoading = false;
      });
    } on DioError catch (e) {
      _isLoading = false;
      if (e.response?.statusCode == 401) {
        _prefs.then((SharedPreferences prefs) {
          prefs.remove('access_token');

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        });
      }
    }
  }

  @override
  void initState() {
    _prefs.then((SharedPreferences prefs) {
      var key = prefs.getString('access_token');
      setState(() {
        _key = key!;
      });
      getUserBookmarks(key);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookmarks.isNotEmpty
              ? RefreshIndicator(
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  onRefresh: () async {
                    await getUserBookmarks(_key);
                  },
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final bookmark = _bookmarks[index];

                      return ListTile(
                        title: Text(bookmark.description),
                        subtitle: Text(bookmark.url),
                        trailing: const Icon(Icons.link),
                        onTap: () =>
                            {_launchInBrowser(Uri.parse(bookmark.url))},
                      );
                    },
                    itemCount: _bookmarks.length,
                  ),
                )
              : const Center(
                  child: Text("The group does not contain bookmarks."),
                ),
    );
  }
}
