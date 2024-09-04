import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:farmdriverzootech/production/dashboard/provider/init_provider.dart';
import 'package:farmdriverzootech/production/synthese/widgets/filters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/feed_provider.dart';
import '../widgets/feed_post.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  bool isLoading = false;
  bool failedToFetch = false;
  int? site;
  String? siteName;
  int count = 10;

  void siteGetter(siteId, siteNm) {
    setState(() {
      site = siteId;
      siteName = siteNm;
    });
    fetchPosts(context);
  }

  @override
  void initState() {
    fetchPosts(context);
    super.initState();
  }

  void fetchPosts(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<FeedProvider>(context, listen: false).fetchFeedPosts(count, site).then((_) {
        setState(() {
          isLoading = false;
          failedToFetch = false;
        });
      });
    } catch (e) {
      int? statusCode = int.tryParse(e.toString().replaceAll('Exception:', '').trim());
      if (statusCode == 401) {
        try {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.tryAutoLogin().then((_) {
            fetchPosts(context);
          });
        } catch (e) {
          Navigator.of(context).pushNamed("auth-screen/");
        }
      } else {
        AlertsDialog.doUreallyWant(
          context,
          "Echec",
          "échec de récupération des données",
          "Réessayer",
          true,
          fetchPosts,
        );
      }
      setState(() {
        isLoading = false;
        failedToFetch = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List posts = Provider.of<FeedProvider>(context).feedPosts;
    List sites = Provider.of<InitProvider>(context, listen: false).slidesData.map((e) {
      return {
        "siteId": e.siteId,
        "siteName": e.siteName
      };
    }).toList();
    sites.insert(0, {
      "siteId": false,
      "siteName": "GLOBAL"
    });
    return posts.isEmpty
        ? const SizedBox(
            height: 400,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.subtitles_off_outlined,
                    color: Colors.grey,
                    size: 50,
                  ),
                  Text(
                    "Fil d'actualité vide",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
          )
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: OutlinedButton(
                    onPressed: () {
                      Filters.showActionSheet(context, sites, siteGetter);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(14),
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(siteName ?? "SITE"),
                        const Icon(
                          Icons.location_on,
                          size: 17,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                    children: posts.map((post) {
                  return FeedPost(post: post);
                }).toList()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        count = count + 10;
                        fetchPosts(context);
                      },
                      child: isLoading ? const CupertinoActivityIndicator() : const Text("Voir Plus"),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
