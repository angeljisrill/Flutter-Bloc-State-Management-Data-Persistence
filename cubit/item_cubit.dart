import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item_model.dart';

part 'item_state.dart';

class ItemCubit extends Cubit<ItemState> {
  ItemCubit() : super(ItemInitial()) {
    loadItems();
  }

  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('items');

    if (data != null) {
      emit(ItemLoaded(ItemModel.decode(data)));
    } else {
      emit(const ItemLoaded([]));
    }
  }

  Future<void> saveItems(List<ItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('items', ItemModel.encode(items));
  }

  void addItem(String title) {
    final current = state.items;
    final newItem = ItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );
    final updated = [...current, newItem];

    emit(ItemLoaded(updated));
    saveItems(updated);
  }

  void toggleItem(String id) {
    final current = state.items;
    final updated = current.map((item) {
      if (item.id == id) {
        return item.copyWith(isDone: !item.isDone);
      }
      return item;
    }).toList();

    emit(ItemLoaded(updated));
    saveItems(updated);
  }

  void deleteItem(String id) {
    final current = state.items;
    final updated = current.where((item) => item.id != id).toList();

    emit(ItemLoaded(updated));
    saveItems(updated);
  }

  void editItem(String id, String newTitle) {
    final current = state.items;
    final updated = current.map((item) {
      if (item.id == id) {
        return item.copyWith(title: newTitle); 
      }
      return item;
    }).toList();

    emit(ItemLoaded(updated));
    saveItems(updated);
  }
}
