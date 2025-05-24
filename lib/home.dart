import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String input = "";
  String result = "";
  String opr = '';
  double numOne = 0;
  double numTwo = 0;

  final List<String> buttons = [
    'C', 'DEL', '%', '/',
    '7', '8', '9', 'X',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '+/-', '0', '.', '='
  ];

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        input = '';
        result = '';
        numOne = 0;
        numTwo = 0;
        opr = '';
      } else if (buttonText == 'DEL') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (RegExp(r'^[0-9]$').hasMatch(buttonText)) {
        input += buttonText;
      } else if (buttonText == '.') {
        final lastNumber = input.split(RegExp(r'[+\-X/%]')).last;
        if (!lastNumber.contains('.')) {
          input += '.';
        }
      } else if (buttonText == '+' || buttonText == '-' || buttonText == 'X' || buttonText == '/' || buttonText == '%') {
        if (input.isNotEmpty && !RegExp(r'[+\-X/%/]$').hasMatch(input)) {
          opr = buttonText;
          numOne = double.tryParse(input) ?? 0;
          input += buttonText;
        }
      } else if (buttonText == '=') {
        try {
          final parts = input.split(RegExp(r'[+\-X/%/]'));
          if (parts.length == 2) {
            numTwo = double.tryParse(parts[1]) ?? 0;
            double res = 0;

            switch (opr) {
              case '+':
                res = numOne + numTwo;
                break;
              case '-':
                res = numOne - numTwo;
                break;
              case 'X':
                res = numOne * numTwo;
                break;
              case '/':
                res = numTwo != 0 ? numOne / numTwo : double.nan;
                break;
              case '%':
                res = numOne % numTwo;
                break;
            }

            result = res.toString();
            if (result.endsWith('.0')) {
              result = result.substring(0, result.length - 2);
            }

            input = result;
          }
        } catch (e) {
          input = 'Error';
        }
      }else if (buttonText == '+/-') {
        //If there is an operator, change the last number sign
        if (input.contains(RegExp(r'[+X/%]'))) {
          final match = RegExp(r'(.*?)([+X/%])(-?\d*\.?\d*)$').firstMatch(input);

          if (match != null) {
            String before = match.group(1) ?? '';
            String operator = match.group(2) ?? '';
            String number = match.group(3) ?? '';

            //If our number is 0 or -0, change the sign
            if (number == '0' || number == '-0' || number == '') {
              return;
            }

            // change sign
            if (number.startsWith('-')) {
              number = number.substring(1);
            } else {
              number = '-' + number;
            }

            input = before + operator + number;
          }
        }
        // If there is no operator (only numbers)
        else if (RegExp(r'^-?\d*\.?\d*$').hasMatch(input)) {
          // if input is 0, -0, empty do not change
          if (input == '0' || input == '-0' || input == '') return;

          input = input.startsWith('-') ? input.substring(1) : '-' + input;
        }
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Calculator"),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              color: Colors.grey[300],
              child: Text(
                input.isEmpty ? '0' : input,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: _buildButtonRows(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildButtonRows() {
    List<Widget> rows = [];
    for (int i = 0; i < buttons.length; i += 4) {
      rows.add(
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(4, (j) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: ElevatedButton(
                    onPressed: () {
                      _onButtonPressed(buttons[i + j]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(),
                    ),
                    child: Text(
                      buttons[i + j],
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      );
    }
    return rows;
  }
}
