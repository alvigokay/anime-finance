import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'sans-serif',
        scaffoldBackgroundColor: Color(0xFFFDF6F0),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bg.jpg', fit: BoxFit.cover),
          Center(
            child: Text(
              'Hallo oni-chan~',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 10, color: Colors.black45, offset: Offset(2, 2))],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> transactions = [];
  double totalIncome = 0;
  double totalExpense = 0;
  final controller = TextEditingController();

  void addTransaction(String text) {
    final lower = text.toLowerCase();
    double amount = 0;
    bool isIncome = false;

    if (lower.contains("masukin") || lower.contains("dapat")) {
      isIncome = true;
    }

    final regex = RegExp(r"(\d+([,.]\d+)?)");
    final match = regex.firstMatch(text);
    if (match != null) {
      amount = double.tryParse(match.group(0)!.replaceAll(",", ".")) ?? 0;
    }

    if (amount == 0) return;

    setState(() {
      transactions.add({
        "text": text,
        "amount": isIncome ? amount : -amount,
        "time": DateFormat.Hm().format(DateTime.now())
      });
      if (isIncome) {
        totalIncome += amount;
      } else {
        totalExpense += amount;
      }
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Finance Tracker"),
        backgroundColor: Colors.purple[300],
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple[100]!, Colors.pink[50]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text("Pemasukan", style: TextStyle(color: Colors.green[700])),
                    Text("Rp ${totalIncome.toStringAsFixed(0)}", style: TextStyle(color: Colors.black, fontSize: 16)),
                  ],
                ),
                Column(
                  children: [
                    Text("Pengeluaran", style: TextStyle(color: Colors.red[700])),
                    Text("Rp ${totalExpense.toStringAsFixed(0)}", style: TextStyle(color: Colors.black, fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: controller,
              onSubmitted: addTransaction,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Contoh: masukin uang 50000",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    title: Text(tx["text"]),
                    subtitle: Text(tx["time"]),
                    trailing: Text(
                      "Rp ${tx["amount"].toStringAsFixed(0)}",
                      style: TextStyle(
                        color: tx["amount"] > 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Image.asset('assets/images/icon.png', width: 80),
          ),
        ],
      ),
    );
  }
}