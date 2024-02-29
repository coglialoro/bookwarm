import "dart:convert" as convert;

import "package:bookwarm/modelli/libro.dart";
import "package:bookwarm/modelli/risultato_api.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_barcode_scanner/flutter_barcode_scanner.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:http/http.dart" as http;

class Scansione extends StatelessWidget {
  const Scansione({super.key});

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
          "Scanner",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: scansioneCodice,
          child: const Text("Scan"),
        ),
      ),
    );
  }
}
