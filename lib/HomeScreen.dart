import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/Login.dart';
import 'UserService.dart'; // Adjust import path as per your project structure

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isGrid = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    Provider.of<UserService>(context, listen: false).fetchUsers();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      Provider.of<UserService>(context, listen: false).fetchUsers(loadMore: true);
    }
  }

  Future<void> _logout(BuildContext context) async {
    await Provider.of<UserService>(context, listen: false).logout();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
    // Navigate to login screen or show a message
    // Replace the below line with your navigation to the login screen
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final userName = userService.users.isNotEmpty ? userService.users[0].firstName : 'User';

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, $userName'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await userService.fetchUsers();
        },
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(_isGrid ? Icons.list : Icons.grid_on),
                  onPressed: () {
                    setState(() {
                      _isGrid = !_isGrid;
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: userService.isLoading && userService.users.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : _isGrid
                  ? GridView.builder(
                controller: _scrollController,
                itemCount: userService.users.length + (userService.isLoading ? 1 : 0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  if (index == userService.users.length) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final user = userService.users[index];
                  return Card(
                    child: Center(
                      child: Text('${user.firstName} ${user.lastName}\n${user.email}\n${user.phoneNo}'),
                    ),
                  );
                },
              )
                  : ListView.builder(
                controller: _scrollController,
                itemCount: userService.users.length + (userService.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == userService.users.length) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final user = userService.users[index];
                  return ListTile(
                    title: Text('${user.firstName} ${user.lastName}'),
                    subtitle: Text('${user.email}\n${user.phoneNo}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
