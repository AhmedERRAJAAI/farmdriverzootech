import 'package:farmdriverzootech/production/performaces_table/constants.dart';
import 'package:farmdriverzootech/production/performaces_table/model.dart';
import 'package:flutter/material.dart';

class ToggleTableColumns extends StatelessWidget {
  final List<TableTitle> titles;
  final Function toggleActive;
  const ToggleTableColumns({
    super.key,
    required this.titles,
    required this.toggleActive,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 4.5,
      crossAxisSpacing: 4,
      children: titles.map((title) {
        return GestureDetector(
          onTap: () {
            toggleActive(title.name);
          },
          child: Chip(
              backgroundColor: TableTitles.colors[title.colorIndex],
              label: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title.title,
                    style: TextStyle(decoration: title.isActive ? null : TextDecoration.lineThrough, color: Colors.black),
                  ),
                  title.isActive
                      ? const Icon(
                          Icons.check_box_outlined,
                          color: Colors.green,
                        )
                      : const Icon(Icons.check_box_outline_blank)
                ],
              )),
        );
      }).toList(),
    );
  }
}
