import 'package:redux/redux.dart';

import '../misc/shop_item.dart';
import '../misc/shop_user.dart';

// State
class ShopState {
  final List<ShopItem> items;
  final List<ShopItem> cart;
  final ShopUser? user;

  ShopState({required this.items, this.cart = const [], this.user});
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

class SetUserAction {
  final ShopUser user;

  SetUserAction(this.user);
}

class ClearUserAction {}

// Reducer
ShopState reducer(ShopState state, dynamic action) {
  if (action is ItemsLoadedAction) {
    return ShopState(items: action.items, cart: state.cart, user: state.user);
  }

  if (action is AddToCartAction) {
    return ShopState(items: state.items, cart: [...state.cart, action.item], user: state.user);
  }

  if (action is RemoveFromCartAction) {
    return ShopState(items: state.items, cart: state.cart.where((item) => item.id != action.item.id).toList(), user: state.user);
  }

  if (action is ClearCartAction) {
    return ShopState(items: state.items, cart: [], user: state.user);
  }

  if (action is SetUserAction) {
    return ShopState(items: state.items, cart: state.cart, user: action.user);
  }

  if (action is ClearUserAction) {
    return ShopState(items: state.items, cart: state.cart);
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