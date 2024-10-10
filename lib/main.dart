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
      title: 'Tic-Tac-Toe Game',
      home: MyHomePage(title: 'Tic-Tac-Toe Game'),
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
  // ignore: constant_identifier_names
  static const int PLAYER_X = 1;
  // ignore: constant_identifier_names
  static const int PLAYER_O = 2;

  List<int> tiles = List.filled(9, 0);
  bool playerTurn = Random().nextBool();

  @override
  void initState() {
    super.initState();
    if (!playerTurn) {
      Future.delayed(const Duration(seconds: 1), () {
        check();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            playerTurn ? 'Your Move' : 'Computer Move',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.width / 1.02,
              width: MediaQuery.of(context).size.width / 1.02,
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: tiles.length,
                  itemBuilder: (context, index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: tiles[index] == PLAYER_X
                            ? Colors.green[100]
                            : tiles[index] == PLAYER_O
                                ? Colors.red[100]
                                : Colors.white,
                      ),
                      child: InkWell(
                        onTap: () {
                          if (tiles[index] == 0 && playerTurn) {
                            setState(() {
                              tiles[index] = PLAYER_X;
                              playerTurn = false;
                            });
                            check();
                          }
                        },
                        child: Center(
                          child: Text(
                            tiles[index] == 0
                                ? ''
                                : tiles[index] == PLAYER_X
                                    ? 'X'
                                    : 'O',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: tiles[index] == PLAYER_X
                                  ? Colors.black
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              setState(() {
                tiles = List.filled(9, 0);
                playerTurn = Random().nextBool();
                if (!playerTurn) {
                  check();
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black,
              ),
              child: const Text(
                'Reset',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void check() async {
    await Future.delayed(const Duration(seconds: 2));
    int? winningMove;
    int? blockingMove;
    int? normalMove;

    for (int i = 0; i < 9; i++) {
      if (tiles[i] > 0) continue;

      var futureBoard = [...tiles]..[i] = PLAYER_O;

      if (isWinning(PLAYER_O, futureBoard)) {
        winningMove = i;
      }

      futureBoard[i] = PLAYER_X;

      if (isWinning(PLAYER_X, futureBoard)) {
        blockingMove = i;
      }

      normalMove = i; // Default move if no blocking or winning move found
    }

    var move = winningMove ?? blockingMove ?? normalMove;

    if (move != null) {
      setState(() {
        tiles[move] = PLAYER_O;
        playerTurn = true;
      });
      checkWinner();
    }
  }

  void checkWinner() {
    if (isWinning(PLAYER_X, tiles)) {
      showEndDialog('You Won!');
    } else if (isWinning(PLAYER_O, tiles)) {
      showEndDialog('You Lost!');
    } else if (!tiles.contains(0)) {
      showEndDialog('It\'s a Draw!');
    }
  }

  void showEndDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      tiles = List.filled(9, 0);
      playerTurn = Random().nextBool();
      if (!playerTurn) {
        check();
      }
    });
  }

  bool isWinning(int player, List<int> board) {
    return (board[0] == player && board[1] == player && board[2] == player) ||
        (board[3] == player && board[4] == player && board[5] == player) ||
        (board[6] == player && board[7] == player && board[8] == player) ||
        (board[0] == player && board[3] == player && board[6] == player) ||
        (board[1] == player && board[4] == player && board[7] == player) ||
        (board[2] == player && board[5] == player && board[8] == player) ||
        (board[0] == player && board[4] == player && board[8] == player) ||
        (board[2] == player && board[4] == player && board[6] == player);
  }
}
