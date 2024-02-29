import "dart:convert" as convert;

import "package:bookwarm/modelli/libro.dart";
import "package:bookwarm/modelli/risultato_api.dart";
import "package:bookwarm/modelli/sessione.dart";
import "package:bookwarm/schermate/aggiungi_libro_manuale.dart";
import "package:bookwarm/schermate/home.dart";
import "package:bookwarm/schermate/libreria.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_barcode_scanner/flutter_barcode_scanner.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:http/http.dart" as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(StatoAdapter());
  Hive.registerAdapter(SessioneAdapter());
  Hive.registerAdapter(LibroAdapter());

  await Hive.openBox<Libro>("libri");
  await Hive.openBox<Sessione>("sessioni");

  runApp(
    MaterialApp(
      home: const App(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.blue[200],
        ),
      ),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    Home(),
    Libreria(),
  ];

  Future<void> scansioneCodice() async {
    String codiceLetto;

    try {
      codiceLetto = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      codiceLetto = "Failed to get a platform version";
    }

    final url = Uri.https(
        "www.googleapis.com", "/books/v1/volumes", {"q": "isbn:$codiceLetto"});
    final risposta = await http.get(url);

    if (risposta.statusCode == 200) {
      final jsonRisposta =
          convert.jsonDecode(risposta.body) as Map<String, dynamic>;

      final risultati = RisultatoAPI.fromJson(jsonRisposta);

      if (risultati.items != null && risultati.items!.isNotEmpty) {
        final primo = risultati.items!.first;
        final libro = primo.volumeInfo!;
        final libri = Hive.box<Libro>("libri");
        libri.add(libro);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BookWarm",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w600,
            fontFamily: "Bitter",
          ),
        ),
        actions: [
          IconButton(
            onPressed: scansioneCodice,
            icon: const Icon(
              Icons.search,
              size: 32,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AggiungiLibroManuale(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              size: 32,
            ),
          ),
        ],
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Libreria",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
