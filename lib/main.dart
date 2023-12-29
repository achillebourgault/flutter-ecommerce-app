import 'package:ecommerce_app/pages/home.dart';
import 'package:ecommerce_app/redux/shop_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Assure-toi que ce fichier est correctement importé

void main() async {
  final shopItemStore = Store<ShopItemState>(
    shopItemReducer,
    initialState: ShopItemState(items: []),
    middleware: shopItemMiddleware(),
  );

  WidgetsFlutterBinding.ensureInitialized(); // S'assurer que les bindings sont initialisés
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Utiliser les options par défaut pour la plateforme actuelle
  );

  runApp(MyApp(shopItemStore: shopItemStore));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.shopItemStore}) : super(key: key);

  final Store<ShopItemState> shopItemStore;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    widget.shopItemStore.dispatch(FetchItemsAction());
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: widget.shopItemStore,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}