import 'package:flutter/material.dart';

class SelectSeatScreen extends StatefulWidget {
  final String operator;
  final String busType;
  final int price;
  final List<List<int>> seatGrid;

  const SelectSeatScreen({
    super.key,
    required this.operator,
    required this.busType,
    required this.price,
    required this.seatGrid,
  });

  @override
  State<SelectSeatScreen> createState() => _SelectSeatScreenState();
}

class _SelectSeatScreenState extends State<SelectSeatScreen> {
  late List<List<int>> seatGrid;
  final List<String> selectedSeats = [];

  @override
  void initState() {
    super.initState();
    seatGrid = widget.seatGrid.map((row) => List<int>.from(row)).toList();
  }

  void _toggleSeat(int rowIndex, int colIndex, String seatLabel) {
    if (seatGrid[rowIndex][colIndex] == 1) return;

    setState(() {
      if (seatGrid[rowIndex][colIndex] == 0) {
        seatGrid[rowIndex][colIndex] = 2;
        selectedSeats.add(seatLabel);
      } else if (seatGrid[rowIndex][colIndex] == 2) {
        seatGrid[rowIndex][colIndex] = 0;
        selectedSeats.remove(seatLabel);
      }
    });
  }

  String _getSeatLabel(int rowIndex, int colIndex) {
    final row = rowIndex + 1;
    if (colIndex == 0) return '${row}L';
    if (colIndex == 1) return '';
    if (colIndex == 2) return '${row}R';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.operator)),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: List.generate(seatGrid.length, (rowIndex) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(seatGrid[rowIndex].length, (colIndex) {
                    final state = seatGrid[rowIndex][colIndex];
                    final label = _getSeatLabel(rowIndex, colIndex);
                    if (label == '') return const SizedBox(width: 20);
                    return GestureDetector(
                      onTap: () => _toggleSeat(rowIndex, colIndex, label),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        width: 50,
                        height: 40,
                        color: state == 0
                            ? Colors.grey
                            : state == 1
                                ? Colors.red
                                : Colors.green,
                        alignment: Alignment.center,
                        child: Text(label, style: const TextStyle(color: Colors.white)),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
          Text('Selected Seats: ${selectedSeats.join(', ')}'),
        ],
      ),
    );
  }
}
