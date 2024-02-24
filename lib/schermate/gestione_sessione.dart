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
    var milli = stopwatch.elapsed.inMilliseconds;

    String _ = (milli % 1000)
        .toString()
        .padLeft(3, "0"); // this one for the miliseconds
    String seconds = ((milli ~/ 1000) % 60)
        .toString()
        .padLeft(2, "0"); // this is for the second
    String minutes = ((milli ~/ 1000) ~/ 60)
        .toString()
        .padLeft(2, "0"); // this is for the minute

    String hours = ((milli ~/ 1000) ~/ 60)
        .toString()
        .padLeft(2, "0"); // this is for the hour

    return "$hours:$minutes:$seconds";
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
