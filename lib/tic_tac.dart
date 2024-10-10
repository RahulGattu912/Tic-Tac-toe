import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List tiles = List.filled(9, 0);
  bool playerTurn = Random().nextBool();
  @override
  void initState() {
    super.initState();
    playerTurn = Random().nextBool();
    if (!playerTurn) {
      check();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.width / 1.02,
              width: MediaQuery.of(context).size.width / 1.02,
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemCount: tiles.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: InkWell(
                          hoverColor: Colors.grey,
                          onTap: () {
                            if (tiles[index] == 0 && playerTurn) {
                              setState(() {
                                tiles[index] = 1;
                                playerTurn = !playerTurn;
                              });
                              check();
                            }
                          },
                          child: GridTile(
                              child: Center(
                                  child: Text(
                            tiles[index] == 0
                                ? ''
                                : tiles[index] == 1
                                    ? 'X'
                                    : 'O',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: tiles[index] == 1
                                    ? Colors.black
                                    : tiles[index] == 2
                                        ? Colors.red
                                        : null),
                          ))),
                        ),
                      );
                    }),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ...[
            isWinning(1, tiles)
                ? const AlertDialog(
                    elevation: 5,
                    title: Text('You Won!'),
                  )
                : isWinning(2, tiles)
                    ? const AlertDialog(elevation: 5, title: Text('You Lost!'))
                    : playerTurn
                        ? const Text('Your Move')
                        : const Text('Computer Move'),
          ],
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              setState(() {
                tiles = List.filled(9, 0);
                playerTurn = Random().nextBool();
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: Colors.black),
              child: const Text(
                'Reset',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  void check() async {
    // Future.delayed(const Duration(seconds: 1), () {
    //   check();
    // });

    await Future.delayed(const Duration(seconds: 2), () {
      check();
    });
    int? winning;
    int? blocking;
    int? normal;

    for (int i = 0; i < 9; i++) {
      if (tiles[i] > 0) {
        continue;
      }

      var future = [...tiles]..[i] = 2;

      if (isWinning(2, future)) {
        winning = i;
      }

      future[i] = 1;

      if (isWinning(1, future)) {
        blocking = i;
      }

      normal = i;
    }
    var move = winning ?? blocking ?? normal;

    if (move != null) {
      setState(() {
        tiles[move] = 2;
      });
    }
  }

  bool isWinning(int i, List tiles) {
    return (tiles[0] == i && tiles[1] == i && tiles[2] == i) ||
        (tiles[3] == i && tiles[4] == i && tiles[5] == i) ||
        (tiles[6] == i && tiles[7] == i && tiles[8] == i) ||
        (tiles[2] == i && tiles[5] == i && tiles[8] == i) ||
        (tiles[1] == i && tiles[4] == i && tiles[7] == i) ||
        (tiles[0] == i && tiles[3] == i && tiles[6] == i) ||
        (tiles[0] == i && tiles[4] == i && tiles[8] == i) ||
        (tiles[2] == i && tiles[4] == i && tiles[6] == i);
  }
}


// 0   1   2
// 3   4   5
// 6   7   8