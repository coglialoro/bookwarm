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
  // Inizializzazione necessaria per `Hive`
  //WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Registriamo gli `Adapter` per le classi di `Hive`
  Hive.registerAdapter(StatoAdapter());
  Hive.registerAdapter(SessioneAdapter());
  Hive.registerAdapter(LibroAdapter());

  // Apriamo le `Box` di `Hive`
  // Ogni `Box` e' piu' o meno equivalente ad una tabella sql
  // L'ordine e' importante, se si apre prima libri da errore
  await Hive.openBox<Sessione>("sessioni");
  await Hive.openBox<Libro>("libri");

  runApp(
    MaterialApp(
      home: const App(),
      // Nascondiamo il banner di debug
      debugShowCheckedModeBanner: false,
      // Definiamo il tema per l'app
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
  // Indice della pagina selezionata, per passare da `Libreria` ad `Home`
  int _selectedIndex = 0;

  // Lista delle pagine
  static const List<Widget> _pages = [
    Home(),
    Libreria(),
  ];

  Future<void> scansioneCodice() async {
    String codiceLetto;

    // Proviamo a leggere un codice con la fotocamera
    try {
      codiceLetto = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      codiceLetto = "Failed to get a platform version";
    }

    // Url dell'API di Google Books
    final url = Uri.https(
        "www.googleapis.com", "/books/v1/volumes", {"q": "isbn:$codiceLetto"});

    // Chiamiamo l'API
    final risposta = await http.get(url);

    // Controlliamo la risposta
    if (risposta.statusCode == 200) {
      // Decodifichiamo la risposta
      final jsonRisposta =
          convert.jsonDecode(risposta.body) as Map<String, dynamic>;

      final risultati = RisultatoAPI.fromJson(jsonRisposta);

      // Creiamo il `Libro`
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
        // Icone in alto a destra
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
      // Icone in basso
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
