import 'package:redux/redux.dart';

import '../misc/shop_item.dart';

// State
class ShopState {
  final List<ShopItem> items;
  final List<ShopItem> cart;

  ShopState({required this.items, this.cart = const []});
}

// Actions
class FetchItemsAction {}

class ItemsLoadedAction {
  final List<ShopItem> items;

  ItemsLoadedAction(this.items);
}

class AddToCartAction {
  final ShopItem item;

  AddToCartAction(this.item);
}

class RemoveFromCartAction {
  final ShopItem item;

  RemoveFromCartAction(this.item);
}

class ClearCartAction {}

// Reducer
ShopState reducer(ShopState state, dynamic action) {
  if (action is ItemsLoadedAction) {
    return ShopState(items: action.items, cart: state.cart);
  }

  if (action is AddToCartAction) {
    return ShopState(items: state.items, cart: [...state.cart, action.item]);
  }

  if (action is RemoveFromCartAction) {
    return ShopState(items: state.items, cart: state.cart.where((item) => item.id != action.item.id).toList());
  }

  if (action is ClearCartAction) {
    return ShopState(items: state.items, cart: []);
  }

  return state;
}

// Middleware
List<Middleware<ShopState>> shopItemMiddleware() {
  return [
    TypedMiddleware<ShopState, FetchItemsAction>(_fetchItems),
  ];
}

void _fetchItems(Store<ShopState> store, FetchItemsAction action, NextDispatcher next) async {
  next(action);

  final items = await ShopItem.getItems();
  store.dispatch(ItemsLoadedAction(items));
}