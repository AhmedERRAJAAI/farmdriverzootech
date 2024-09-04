import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/production/dashboard/provider/feed_provider.dart';
import 'package:farmdriverzootech/production/dashboard/widgets/comment_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import 'sub-wigets/image_network.dart';
import 'sub-wigets/user_identification.dart';

class FeedPost extends StatefulWidget {
  final Map post;
  const FeedPost({super.key, required this.post});

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  bool isLoading = false;
  bool failedToFetch = false;
  Widget getReactionSection() {
    return const CommentSection();
  }

  bool isLiked = false;
  bool isSaved = false;

  // Takes observ id and returns value
  String observTheme(int obTheme) {
    switch (1) {
      case 1:
        return 'sanitaire';
      case 2:
        return 'services généraux';
      case 3:
        return 'météo';
      case 5:
        return "usine d'aliment";
      case 6:
        return "MP & FP";
      case 7:
        return "Formulation";
      default:
        return "";
    }
  }

  // DELETE POST
  Future<void> deletePost(context, int id) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<FeedProvider>(context, listen: false).deletePost(id).then((_) {
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
            deletePost(context, id);
          });
        } catch (e) {
          Navigator.of(context).pushNamed("auth-screen/");
        }
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Durations.long4,
            backgroundColor: Colors.deepOrange,
            content: Text('Échec de suppression'),
          ),
        );
      }
      setState(() {
        isLoading = false;
        failedToFetch = true;
      });
    }
  }

  // POST ACTIONS
  void _showLotsFilterActionSheet(BuildContext context, int id) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Actions  '),
            if (isLoading) const CupertinoActivityIndicator()
          ],
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              deletePost(context, id);
              Navigator.of(context).pop();
            },
            isDestructiveAction: true,
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context, listen: true).getUserId;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // post header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserIdentification(
                fName: widget.post["user_fname"],
                stName: widget.post["user_stname"],
                role: widget.post["role_value"],
                site: widget.post["site"] ?? "GLOBAL",
                time: widget.post["time"] ?? "--",
                date: widget.post["date"] ?? "--",
              ),
              if (userId == widget.post["user_id"])
                IconButton(
                  onPressed: () {
                    _showLotsFilterActionSheet(context, widget.post["id"]);
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
            ],
          ),

          // post text
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 2),
            child: Row(
              children: [
                const Icon(
                  Icons.circle,
                  color: Colors.indigo,
                  size: 10,
                ),
                Text(
                  observTheme(widget.post["role"]),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 14,
                        color: Colors.indigo,
                      ),
                ),
              ],
            ),
          ),

          //Post content
          ReadMoreText(
            "${widget.post["observ_text"]}: ${widget.post["other"]}",
            textAlign: TextAlign.left,
            trimMode: TrimMode.Line,
            trimLines: 1,
            style: const TextStyle(fontSize: 12.6, fontWeight: FontWeight.w400),
            trimCollapsedText: ' Voir plus',
            trimExpandedText: ' voir moins',
            moreStyle: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.normal),
            lessStyle: const TextStyle(fontSize: 12, color: Colors.purpleAccent, fontWeight: FontWeight.normal),
          ),

          // Post image
          if (widget.post["image"] != "")
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ImageNetwork(imgUrl: widget.post["image"]),
              ),
            ),

          // Comment section

          // Reaction section
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             isLiked = !isLiked;
          //           });
          //         },
          //         child: Column(
          //           children: [
          //             Icon(isLiked ? Icons.thumb_up : Icons.thumb_up_outlined, size: 18, color: isLiked ? Colors.blue : Colors.grey),
          //             Text("J'aime", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: isLiked ? Colors.blue : Colors.grey))
          //           ],
          //         )),
          //     GestureDetector(
          //         onTap: () {
          //           PoppupSerfaces.showPopupSurface(context, getReactionSection, MediaQuery.of(context).size.height / 2, false);
          //         },
          //         child: Column(
          //           children: [
          //             const Icon(Icons.chat_outlined, size: 18, color: Colors.grey),
          //             Text(
          //               "Commentaire",
          //               style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),
          //             )
          //           ],
          //         )),
          //     GestureDetector(
          //       onTap: () {
          //         setState(() {
          //           isSaved = !isSaved;
          //         });
          //       },
          //       child: Column(
          //         children: [
          //           Icon(isSaved ? Icons.bookmark : Icons.bookmark_outline, size: 18, color: isSaved ? Colors.blue : Colors.grey),
          //           Text(
          //             "Sauvgarder",
          //             style: Theme.of(context).textTheme.bodySmall!.copyWith(color: isSaved ? Colors.blue : Colors.grey),
          //           )
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          const Divider(),
        ],
      ),
    );
  }
}
