import 'package:redux/redux.dart';

import '../misc/shop_item.dart';

// State
class ShopItemState {
  final List<ShopItem> items;

  ShopItemState({required this.items});
}

// Actions
class FetchItemsAction {}

class ItemsLoadedAction {
  final List<ShopItem> items;

  ItemsLoadedAction(this.items);
}

// Reducer
ShopItemState shopItemReducer(ShopItemState state, dynamic action) {
  if (action is ItemsLoadedAction) {
    return ShopItemState(items: action.items);
  }

  return state;
}

// Middleware
List<Middleware<ShopItemState>> shopItemMiddleware() {
  return [
    TypedMiddleware<ShopItemState, FetchItemsAction>(_fetchItems),
  ];
}

void _fetchItems(Store<ShopItemState> store, FetchItemsAction action, NextDispatcher next) async {
  next(action);

  final items = await ShopItem.getItems();
  store.dispatch(ItemsLoadedAction(items));
}