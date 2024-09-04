import 'package:farmdriverzootech/production/dashboard/widgets/sub-wigets/circular_image.dart';
import 'package:flutter/material.dart';

class UserIdentification extends StatelessWidget {
  final String fName;
  final String stName;
  final String site;
  final String role;
  final String time;
  final String date;
  const UserIdentification({
    super.key,
    required this.fName,
    required this.stName,
    required this.site,
    required this.role,
    required this.time,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 4),
          child: CircularImageWidget(
            height: 40,
            width: 40,
            imagePath: 'assets/images/man.png',
            isAssetImage: true,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$fName $stName",
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
                  "$site | @$role",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            Text(
              "$date - $time",
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        )
      ],
    );
  }
}
