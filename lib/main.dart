import "package:bookwarm/modelli/libro.dart";
import "package:bookwarm/modelli/sessione.dart";
import "package:bookwarm/schermate/aggiungi_libro_manuale.dart";
import "package:bookwarm/schermate/home.dart";
import "package:bookwarm/schermate/libreria.dart";
import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(StatoAdapter());
  Hive.registerAdapter(SessioneAdapter());
  Hive.registerAdapter(LibroAdapter());

  await Hive.openBox<Libro>("libri");

  runApp(
    const MaterialApp(
      home: App(),
      debugShowCheckedModeBanner: false,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BookWarm"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
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
            icon: const Icon(Icons.add),
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
