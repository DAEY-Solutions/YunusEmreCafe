import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var kunde="Kunde";
  var produkte=[];
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
  void updateKunde(k){
    kunde = k;
    notifyListeners();
  }
  void updateProdukte(p){
    produkte.add(p);
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HomePage();
        break;
      case 1:
        page = HomePage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var newValue = appState.kunde;
    var products = appState.produkte;
    var products_n = [];
    var products_i = [];
    for (var i in products){
      if (!products_i.contains(i)){
        var k = 0;
        for (var j in products){
          if (j == i){
            k = k+1;
          }
        }
        products_i.add(i);
        products_n.add(k);
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: products_i.isEmpty ? [SizedBox(height: 116)]:products_i.map((e) => productpicture_withnumber(path: e, number: products_n[products_i.indexOf(e)].toString(),)).toList(),
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10,),
            DropdownButton<String>(
              hint: Text(newValue),
              //value: newValue,
              style: TextStyle(
                color: Colors.black, // Setzen Sie die gewünschte Textfarbe
                fontSize: 16, // Setzen Sie die gewünschte Schriftgröße
                // Weitere Textstilattribute...
              ),
              onChanged: (change){
                appState.updateKunde(change);

              },
              items: <String>[
                'Kerem Özbudak',
                'Kerem Közdudak',
                'Kerem Tozbardak',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: [
                productpicture_withbutton(path: "cocacola.png"),
                productpicture_withbutton(path: "cocacolazero.png"),
                productpicture_withbutton(path: "fanta.png"),
                productpicture_withbutton(path: "toast.png"),
                productpicture_withbutton(path: "cay.png"),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class productpicture_withbutton extends StatelessWidget {
  const productpicture_withbutton({
    super.key,
    required this.path,
  });


  final String path;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: SizedBox(
              width: 100, // Setzen Sie hier die gewünschte Breite des Bildes
              height: 100, // Setzen Sie hier die gewünschte Höhe des Bildes
              child: Image.asset(
                path,
                fit: BoxFit.cover, // Wählen Sie den gewünschten BoxFit-Wert
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                appState.updateProdukte(path);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class productpicture_withnumber extends StatelessWidget {
  const productpicture_withnumber({
    super.key,
    required this.path,
    required this.number
  });


  final String path;
  final String number;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: SizedBox(
              width: 100, // Setzen Sie hier die gewünschte Breite des Bildes
              height: 100, // Setzen Sie hier die gewünschte Höhe des Bildes
              child: Image.asset(
                path,
                fit: BoxFit.cover, // Wählen Sie den gewünschten BoxFit-Wert
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(number.toString()),
          ),
        ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
