import "dart:async";

import "package:bookwarm/modelli/libro.dart";
import "package:bookwarm/schermate/fine_sessione.dart";
import "package:flutter/material.dart";

class GestioneSessione extends StatefulWidget {
  final Libro libro;

  const GestioneSessione({super.key, required this.libro});

  @override
  State<GestioneSessione> createState() => _GestioneSessioneState();
}

class _GestioneSessioneState extends State<GestioneSessione> {
  late Stopwatch stopwatch;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
    stopwatch.start();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void handleStartStop() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
    } else {
      stopwatch.start();
    }
  }

  String returnFormattedText() {
    final milli = stopwatch.elapsed.inMilliseconds;

    var secondi = milli ~/ 1000;

    final ore = secondi ~/ 3600;

    secondi -= ore * 3600;

    final minuti = secondi ~/ 60;

    secondi -= minuti * 60;

    final stringaSecondi = secondi.toString().padLeft(2, "0");
    final stringaMinuti = minuti.toString().padLeft(2, "0");
    final stringOre = ore.toString().padLeft(2, "0");

    return "$stringOre:$stringaMinuti:$stringaSecondi";

    // String _ = (milli % 1000)
    //     .toString()
    //     .padLeft(3, "0"); // this one for the miliseconds
    // String seconds = ((milli ~/ 1000) % 60)
    //     .toString()
    //     .padLeft(2, "0"); // this is for the second
    // String minutes = ((milli ~/ 1000) ~/ 60)
    //     .toString()
    //     .padLeft(2, "0"); // this is for the minute

    // String hours = ((milli ~/ 1000) ~/ 60)
    //     .toString()
    //     .padLeft(2, "0"); // this is for the hour
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sessione"),
      ),
      body: Column(
        children: [
          Text(returnFormattedText()),
          ElevatedButton(
            onPressed: () {
              handleStartStop();
            },
            child: Text(stopwatch.isRunning ? "Pausa" : "Riprendi"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FineSessione(
                    libro: widget.libro,
                    durata: stopwatch.elapsed,
                  ),
                ),
              );
            },
            child: const Text("Finito"),
          ),
        ],
      ),
    );
  }
}
