import 'package:flutter/material.dart';

import 'sub-wigets/comment_item.dart';

class CommentSection extends StatefulWidget {
  const CommentSection({super.key});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SizedBox(
          height: 600,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.blue,
                        )),
                    Text(
                      "Section commentaires",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                const Column(
                  children: [
                    CommentItem(
                      name: "Ahmed ERRAJAAI",
                      jobTitle: "Admin",
                      site: "Agrowert",
                      commentText: "ndustry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a",
                    ),
                    CommentItem(
                      name: "Ahmed ERRAJAAI",
                      jobTitle: "Admin",
                      site: "Agrowert",
                      commentText: "ndustry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a",
                    ),
                  ],
                ),
              ],
            ),
          ), // Column(children: [],),
        ),
      ),
    );
  }
}
