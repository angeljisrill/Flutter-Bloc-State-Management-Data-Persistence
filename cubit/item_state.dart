part of 'item_cubit.dart';

class ItemState extends Equatable {
  final List<ItemModel> items;
  const ItemState(this.items);

  @override
  List<Object> get props => [items];

  map(Function(dynamic item) param0) {}
}

class ItemInitial extends ItemState {
  ItemInitial() : super(const []);
}

class ItemLoaded extends ItemState {
  const ItemLoaded(super.items);
}
