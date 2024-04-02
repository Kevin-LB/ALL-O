import 'package:allo/UI/bottomNavBar.dart';
import 'package:allo/UI/button.dart';
import 'package:allo/UI/pageAdd.dart';
import 'package:allo/UI/pageMenu.dart';
import 'package:allo/UI/pageSearch.dart';
import 'package:allo/UI/pagepret.dart';
import 'package:allo/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  Session? _session;

  @override
  void initState() {
    super.initState();
    _getSession();
  }

  Future<void> _getSession() async {
    try {
      await Future.delayed(Duration.zero);
      if (supabase.auth.currentSession != null) {
        print('User is authenticated');
      } else {
        print('User is not authenticated');
      }
      if (!mounted) {
        return;
      }
      setState(() {});
    } catch (e) {
      print('Failed to get session: $e');
    }
  }

  _selectIndexSwitch(int index) {
    switch (index) {
      case 1:
        return const SearchPage();
      case 2:
        return PageAdd();
      case 3:
        return const PageMenu();
      default:
        return const HomeScreen();
    }
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectIndexSwitch(_selectedIndex),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void navigateToPage2(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyLoansPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    String getStatus(int index) {
      return index % 2 == 0 ? 'Ouverte' : 'Pourvue';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C3838),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: RichText(
            text: const TextSpan(
              text: "A",
              style: TextStyle(
                color: Color(0xff57A85A),
                fontSize: 45.0,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "'llo",
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 30.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFF3C3838),
        padding: const EdgeInsets.only(top: 40.0, left: 10.0, bottom: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ButtonSelect(
              text: "Mes Prêts",
              onPressed: () => navigateToPage2(context),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'Annonces',
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                  fontSize: 25.0,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (BuildContext context, int index) {
                  String status = getStatus(index);
                  return Row(
                    children: [
                      Expanded(
                        child: _buildContainer(status),
                      ),
                      Expanded(
                        child: _buildContainer(status),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(String status) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 5.0,
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/img/clou.png",
                width: 70,
                height: 60,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10.0),
              const Flexible(
                child: Text(
                  'clous',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 15.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Container(
            height: 35.0,
            width: 80,
            decoration: BoxDecoration(
              color: status == 'Ouverte'
                  ? const Color(0xFF92D668)
                  : const Color(0xFFE78138),
              borderRadius: BorderRadius.circular(8.0),
            ),
            alignment: Alignment.center,
            child: Text(
              status,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 10.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
