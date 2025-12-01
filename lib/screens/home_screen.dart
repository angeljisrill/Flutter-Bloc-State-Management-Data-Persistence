import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/item_cubit.dart';
import '../models/item_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();

  // Confirmation dialog for deletion
  Future<void> _confirmDelete(String itemId) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Do you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) {
      context.read<ItemCubit>().deleteItem(itemId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFFD34E4E); // AppBar, Checkbox, Delete icon
    final secondary = const Color(0xFFCE7E5A); // TextField border
    final cardColor = const Color(0xFFF39F9F); // Task card
    final backgroundColor = const Color(0xFFBADFDB); // Main screen background
    final buttonColor = const Color(0xFFFF8F8F); // Add button
    final darkText = const Color(0xFF1E1B4B); // Text color

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text(
          "My Tasks",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<ItemCubit, ItemState>(
        builder: (context, state) {
          final items = state.items;

          return Column(
            children: [
              // Input field and Add button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Enter new task",
                          labelStyle: TextStyle(color: darkText),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: secondary.withOpacity(0.8),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          context.read<ItemCubit>().addItem(controller.text);
                          controller.clear();
                        }
                      },
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ),

              // Task list
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: primary.withOpacity(0.8),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.inbox,
                                size: 50,
                                color: Colors.black54,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "No items yet...",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          ItemModel item = items[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 4,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border(
                                left: BorderSide(color: primary, width: 5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: item.isDone,
                                  activeColor: primary,
                                  onChanged: (_) {
                                    context.read<ItemCubit>().toggleItem(
                                      item.id,
                                    );
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: darkText,
                                      decoration: item.isDone
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: primary.withOpacity(0.8),
                                  ),
                                  onPressed: () => _confirmDelete(item.id),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
