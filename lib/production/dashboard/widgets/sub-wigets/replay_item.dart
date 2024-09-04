import 'package:farmdriverzootech/production/dashboard/widgets/sub-wigets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class ReplyItem extends StatefulWidget {
  final String name;
  final String jobTitle;
  final String site;
  final String commentText;
  final bool isLiked;
  const ReplyItem({
    super.key,
    required this.name,
    required this.jobTitle,
    required this.site,
    required this.commentText,
    required this.isLiked,
  });

  @override
  State<ReplyItem> createState() => _ReplyItemState();
}

class _ReplyItemState extends State<ReplyItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Padding(
            padding: EdgeInsets.only(right: 4),
            child: CircularImageWidget(
              height: 30,
              width: 30,
              imagePath: 'assets/images/man.png',
              isAssetImage: true,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User identification
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 13.5),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Theme.of(context).textTheme.bodySmall!.color,
                          size: 12,
                        ),
                        Text(
                          "${widget.site} | @${widget.jobTitle}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    )
                  ],
                ),

                // Comment content
                const SizedBox(height: 3),
                ReadMoreText(
                  widget.commentText,
                  textAlign: TextAlign.left,
                  trimMode: TrimMode.Line,
                  trimLines: 1,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  trimCollapsedText: ' Voir plus',
                  trimExpandedText: ' voir moins',
                  moreStyle: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.normal),
                  lessStyle: const TextStyle(fontSize: 12, color: Colors.purpleAccent, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
