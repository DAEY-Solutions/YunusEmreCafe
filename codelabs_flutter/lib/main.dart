import 'dart:io';
import 'package:codelabs_flutter/data_warehouse.dart';
import 'package:codelabs_flutter/kunde.dart';
import 'package:codelabs_flutter/product.dart';
import 'package:codelabs_flutter/schulden_objekt.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'kasse.dart';

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {

  void testdaten() {
    DataWarehouse.kunden.add(Kunde(vorname: "Emre", nachname: "Yumurtaci", budget: 0));
    DataWarehouse.kunden.add(Kunde(vorname: "Muhammed", nachname: "Kilinc", budget: 0));
    DataWarehouse.kunden.add(Kunde(vorname: "Kerem", nachname: "Özbudak", budget: 0));
    DataWarehouse.kunden.add(Kunde(vorname: "Sezgin", nachname: "Karaca", budget: 0));

    DataWarehouse.sortiment.add(Product(
        name: "Coca Cola",
        pathToImage: "cocacola.png",
        preis: 1.3,
        menge: 100, id: null));
    DataWarehouse.sortiment.add(Product(
        name: "Coca Cola Zero",
        pathToImage: "cocacolazero.png",
        preis: 1.3,
        menge: 100, id: null));
    DataWarehouse.sortiment.add(Product(
        name: "Fanta", pathToImage: "fanta.png", preis: 1.3, menge: 100, id: null));
    DataWarehouse.sortiment.add(
        Product(name: "Cay", pathToImage: "cay.png", preis: 0.5, menge: 100, id: null));
    DataWarehouse.sortiment.add(
        Product(name: "Toast", pathToImage: "toast.png", preis: 2, menge: 100, id: null));

    notifyListeners();
  }

  void dw_perform(){
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var appState = context.read<MyAppState>();
      DataWarehouse.refresh();
      appState.dw_perform();
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HomePage();
        break;
      case 1:
        page = ProductPage();
        break;
      case 2:
        page = CustomerPage();
        break;
      case 3:
        page = AbkassierenPage();
        break;
      case 4:
        page = KassenPage();
        break;
      case 5:
        page = EmployeesPage();
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
                    icon: Icon(Icons.food_bank),
                    label: Text('Produkte'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person),
                    label: Text('Kunden'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.monetization_on),
                    label: Text('Abkassieren'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.account_balance),
                    label: Text('Kasse'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.work),
                    label: Text('Mitarbeiterbereich'),
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

class HomePage extends StatelessWidget {
  void addSchuldenToCustomer(Kunde kunde, products_n, products_i) {
    var list = List.generate(products_i.length(), (i) => i);
    for (var i in list) {
      var list1 = List.generate(products_n[i], (j) => j);
      for (var k in list1) {
        kunde.addSchuldenObjekt(products_i[i]);
        //sleep(Duration(seconds: 2));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var newValue =
        DataWarehouse.kunde != null ? DataWarehouse.kunde?.getFullname() : "Kunde";
    var selected_products = DataWarehouse.current_produkte;
    var sortiment = DataWarehouse.sortiment;

    var products_n = [];
    var products_i = [];
    for (var i in selected_products) {
      if (!products_i.contains(i)) {
        var k = 0;
        for (var j in selected_products) {
          if (j == i) {
            k = k + 1;
          }
        }
        products_i.add(i);
        products_n.add(k);
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: products_i.isEmpty
              ? [SizedBox(height: 116)]
              : products_i
                  .map((e) => productpicture_withnumber(
                        product: e,
                        number: products_n[products_i.indexOf(e)].toString(),
                      ))
                  .toList(),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            DropdownButton<Kunde>(
              hint: Text(newValue ?? "Kunde"),
              //value: newValue,
              style: TextStyle(
                color: Colors.black, // Setzen Sie die gewünschte Textfarbe
                fontSize: 16, // Setzen Sie die gewünschte Schriftgröße
                // Weitere Textstilattribute...
              ),
              onChanged: (change) {
                DataWarehouse.updateKunde(change);
                appState.dw_perform();
              },
              items: DataWarehouse.kunden.map((e) {
                return DropdownMenuItem<Kunde>(
                  value: e,
                  child: Text("${e.vorname} ${e.nachname}"),
                );
              }).toList(),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                DataWarehouse.clearCurrentProdukte();
                appState.dw_perform();
              },
              child: Text('Lösche'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                DataWarehouse.addCosts(products_i, products_n);
                appState.dw_perform();
                DataWarehouse.clear_kunde();
                appState.dw_perform();
                DataWarehouse.clearCurrentProdukte();
                appState.dw_perform();
              },
              child: Text('Fertig'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                DataWarehouse.addCosts(products_i, products_n);
                appState.dw_perform();
                DataWarehouse.bezahleAlleSchuldenDirekt();
                appState.dw_perform();
                DataWarehouse.clear_kunde();
                appState.dw_perform();
                DataWarehouse.clearCurrentProdukte();
                appState.dw_perform();
              },
              child: Text('Sofort Bezahlen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                appState.testdaten();
              },
              child: Text('Test'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                DataWarehouse.kunden.forEach((Kunde element) {element.schulden_objekte!.forEach((SchuldenObjekt element1) { print("Name: ${element.vorname} ${element.vorname} ${element.nachname}, Produkt: ${element1.product.name}, ID: ${element1.id}");}); });
              },
              child: Text('Test2'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wrap(
              children: sortiment
                  .map((e) => productpicture_withbutton(
                        product: e,
                      ))
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }
}

class ProductPage extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String? path;
  final ImagePicker _picker = ImagePicker();

  void _openAddDialog(BuildContext context) {
    var appState = context.read<MyAppState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Produkt hinzufügen'),
          content: Column(
            children: [
              // Hier können Sie die gewünschten Eingabefelder hinzufügen
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                // Verwenden Sie den Controller, um den eingegebenen Wert abzurufen
                // und im Zustand der App zu aktualisieren
                controller: nameController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Preis'),
                controller: priceController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Menge'),
                controller: amountController,
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: Text('Bild auswählen'),
                onPressed: () async {
                  XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    path = image.path;
                  }
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Hinzufügen'),
              onPressed: () {
                DataWarehouse.addProductToSortiment(
                    nameController.text.toString(),
                    double.parse(priceController.text.toString()),
                    path,
                    int.parse(amountController.text.toString()));
                appState.dw_perform();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showProductDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Produktdetails'),
          content: Column(
            children: [
              Text('Name: ${product.name}'),
              Text('Preis: ${product.getPrice()}'),
              Text('Menge: ${product.menge}'),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text('Schließen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Column(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  _openAddDialog(context);
                },
                icon: Icon(Icons.add))
          ],
        ),
        DataTable(
          columns: [
            DataColumn(label: Text("Name")),
            DataColumn(label: Text("Preis")),
            DataColumn(label: Text("Menge"))
          ],
          rows: DataWarehouse.sortiment
              .map((e) => DataRow(
                      cells: [
                        DataCell(Text(e.name.toString())),
                        DataCell(Text(e.getPriceString())),
                        DataCell(Text(e.menge.toString()), onTap: () {
                          _showProductDetails(context, e);
                        }),
                      ],
                      onLongPress: () {
                        _showProductDetails(context, e);
                      }))
              .toList(),
        ),
      ],
    );
  }
}

class CustomerPage extends StatefulWidget {
  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  TextEditingController vornameController = TextEditingController();

  TextEditingController nachnameController = TextEditingController();

  TextEditingController saldoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var appState = context.read<MyAppState>();
      DataWarehouse.refresh();
      appState.dw_perform();
    });
  }

  void _openAddDialog(BuildContext context) {
    var appState = context.read<MyAppState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kunde hinzufügen'),
          content: Column(
            children: [
              // Hier können Sie die gewünschten Eingabefelder hinzufügen
              TextField(
                decoration: InputDecoration(labelText: 'Vorname'),
                // Verwenden Sie den Controller, um den eingegebenen Wert abzurufen
                // und im Zustand der App zu aktualisieren
                controller: vornameController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Nachname'),
                controller: nachnameController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Initialer Saldo'),
                controller: saldoController,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Hinzufügen'),
              onPressed: () {
                DataWarehouse.addKunde(
                    vornameController.text,
                    nachnameController.text,
                    double.parse(saldoController.text));
                appState.dw_perform();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Column(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  _openAddDialog(context);
                },
                icon: Icon(Icons.add)),
            IconButton(
                onPressed: () {
                  DataWarehouse.refresh();
                  appState.dw_perform();
                },
                icon: Icon(Icons.abc))

          ],
        ),
        DataTable(
            columns: [
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Saldo")),
            ],
            rows: DataWarehouse.kunden
                .map((e) => DataRow(cells: [
                      DataCell(Text("${e.vorname} ${e.nachname}")),
                      DataCell(Text("${e.getSaldo().toStringAsFixed(2)}€")),
                    ]))
                .toList()),
      ],
    );
  }
}

class AbkassierenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var kunde = DataWarehouse.kassen_kunde;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            DropdownButton<Kunde>(
              hint: Text(kunde?.getFullname() ?? "Kunde"),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              onChanged: (change) {
                DataWarehouse.updateKassenKunde(change);
                appState.dw_perform();
              },
              items: DataWarehouse.kunden.map((e) {
                return DropdownMenuItem<Kunde>(
                  value: e,
                  child: Text("${e.vorname} ${e.nachname}"),
                );
              }).toList(),
            ),
            SizedBox(
              width: 100,
            ),
          ],
        ),
        DataTable(
          columns: [
            DataColumn(label: Text("Produkt")),
            DataColumn(label: Text("Wann")),
            DataColumn(label: Text("Wie viel")),
            DataColumn(label: Text("")),
          ],
          rows: kunde != null
              ? kunde.schulden_objekte
                  !.where((SchuldenObjekt e) => !e.bezahlt!)
                  .map((e) => DataRow(
                        cells: [
                          DataCell(Text(e.product.name)),
                          DataCell(Text(e.getWhen())),
                          DataCell(Text("${e.product.getPriceString()}€")),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.money, color: Colors.green),
                                onPressed: () {
                                  DataWarehouse.schuldenObjektBezahlt(e);
                                  appState.dw_perform();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red,),
                                onPressed: (){
                                  DataWarehouse.entferneSchuldenObjekt(e);
                                  appState.dw_perform();
                                },
                              )
                            ],
                          )),
                        ],
                      ))
                  .toList()
                  .cast<DataRow>()
              : [],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bezahle alles:"),
            IconButton(
                onPressed: () {
                  DataWarehouse.bezahleAlleSchulden();
                  appState.dw_perform();
                  DataWarehouse.clear_kassen_kunde();
                  appState.dw_perform();
                },
                icon: Icon(Icons.payment)),
            
            kunde != null ? Text("Insgesamt: ${(0 - DataWarehouse.kassen_kunde!.getSaldo()).toStringAsFixed(2)}€"):Text(""),
          ],
        )
      ],
    );
  }
}

class KassenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Column(
      children: [
        Text("Ihr Saldo beträgt momentan:"),
        BigCard(txt: "${Kasse.saldo.toStringAsFixed(2)}€")
      ],
    );
  }
}

class EmployeesPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    void _openChooseProductDialog(BuildContext context) {
      var appState = context.read<MyAppState>();
      var sortiment = DataWarehouse.sortiment;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Produkt auswählen'),
            content: Column(
              children: [
                // Hier können Sie die gewünschten Eingabefelder hinzufügen
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      children: sortiment
                          .map((e) => productpicture_withbutton_for_employees(
                        product: e,
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                child: Text('Fertig'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

            ],
          );
        },
      );
    }
    void _openAuszahlen(BuildContext context) {
      var appState = context.read<MyAppState>();
      TextEditingController auszahlungsController = TextEditingController();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Produkt auswählen'),
            content: Column(
              children: [
                // Hier können Sie die gewünschten Eingabefelder hinzufügen
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child:
                    TextField(
                      decoration: InputDecoration(labelText: 'Auszahlung'),
                      // Verwenden Sie den Controller, um den eingegebenen Wert abzurufen
                      // und im Zustand der App zu aktualisieren
                      controller: auszahlungsController,
                    ),)
                  ],
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                child: Text('Fertig'),
                onPressed: () {
                  Kasse.saldo -= double.parse(auszahlungsController.text);
                  Navigator.of(context).pop();
                },
              ),

            ],
          );
        },
      );
    }
    void _openEinzahlen(BuildContext context) {
      var appState = context.read<MyAppState>();
      TextEditingController einzahlungsController = TextEditingController();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Produkt auswählen'),
            content: Column(
              children: [
                // Hier können Sie die gewünschten Eingabefelder hinzufügen
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child:
                    TextField(
                      decoration: InputDecoration(labelText: 'Einzahlung'),
                      // Verwenden Sie den Controller, um den eingegebenen Wert abzurufen
                      // und im Zustand der App zu aktualisieren
                      controller: einzahlungsController,
                    ),)
                  ],
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                child: Text('Fertig'),
                onPressed: () {
                  Kasse.saldo += double.parse(einzahlungsController.text);
                  Navigator.of(context).pop();
                },
              ),

            ],
          );
        },
      );
    }

    return Column(
      children: [
        SizedBox(height: 10,),
        ElevatedButton(onPressed: (){_openChooseProductDialog(context);}, child: Text("Privater Konsum")),
        SizedBox(height: 10,),
        ElevatedButton(onPressed: (){_openAuszahlen(context);}, child: Text("Auszahlung")),
        SizedBox(height: 10,),
        ElevatedButton(onPressed: (){_openEinzahlen(context);}, child: Text("Einzahlung")),

      ],
    );
  }
}

class productpicture_withbutton extends StatelessWidget {
  const productpicture_withbutton({
    super.key,
    required this.product,
  });

  final Product product;

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
              child: product.pathToImage != null ? product.pathToImage!.startsWith("blob")
                  ? Image.network(
                      product.pathToImage!,
                      fit: BoxFit
                          .cover, // Wählen Sie den gewünschten BoxFit-Wert
                    )
                  : Image.asset(product.pathToImage!, fit: BoxFit.cover) : Image.asset("cay.png", fit: BoxFit.cover),
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
                DataWarehouse.updateProdukte(product);
                appState.dw_perform();
              },
            ),
          ),
        ),
      ],
    );
  }
}

class productpicture_withnumber extends StatelessWidget {
  const productpicture_withnumber(
      {super.key, required this.product, required this.number});

  final Product product;
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
              child: product.pathToImage != null ? product.pathToImage!.startsWith("blob")
                  ? Image.network(
                      product.pathToImage!,
                      fit: BoxFit
                          .cover, // Wählen Sie den gewünschten BoxFit-Wert
                    )
                  : Image.asset(product.pathToImage!, fit: BoxFit.cover) : Image.asset("cay.png", fit: BoxFit.cover),
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

class productpicture_withbutton_for_employees extends StatelessWidget {
  const productpicture_withbutton_for_employees({
    super.key,
    required this.product,
  });

  final Product product;

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
              child: product.pathToImage != null ? product.pathToImage!.startsWith("blob")
                  ? Image.network(
                product.pathToImage!,
                fit: BoxFit
                    .cover, // Wählen Sie den gewünschten BoxFit-Wert
              )
                  : Image.asset(product.pathToImage!, fit: BoxFit.cover) : Image.asset("cay.png", fit: BoxFit.cover),
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
                DataWarehouse.reduce_menge(product);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.txt,
  });

  final String txt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 20
    );
    return Card(
      color: theme.colorScheme.primary,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          txt,
          style: style,
        ),
      ),
    );
  }
}