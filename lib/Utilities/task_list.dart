import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Function(int, bool?) onToggleCheckbox;
  final Function(int) onDeleteItem; // Add this line

  const TaskList({
    Key? key,
    required this.items,
    required this.onToggleCheckbox,
    required this.onDeleteItem, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    items[index]['text'],
                    style: TextStyle(
                      fontSize: 16,
                      decoration: items[index]['isChecked']
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
                Checkbox(
                  value: items[index]['isChecked'],
                  onChanged: (bool? value) {
                    onToggleCheckbox(index, value);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    onDeleteItem(index); // Call delete function
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
