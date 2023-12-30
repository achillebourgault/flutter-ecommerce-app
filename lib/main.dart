import 'package:ecommerce_app/pages/home.dart';
import 'package:ecommerce_app/redux/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Assure-toi que ce fichier est correctement importé

void main() async {
  final store = Store<ShopState>(
    reducer,
    initialState: ShopState(items: [], cart: []),
    middleware: shopItemMiddleware(),
  );

  WidgetsFlutterBinding.ensureInitialized(); // S'assurer que les bindings sont initialisés
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(store: store));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.store}) : super(key: key);

  final Store<ShopState> store;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    widget.store.dispatch(FetchItemsAction());
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: widget.store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomePage(),
      ),
    );
  }
}