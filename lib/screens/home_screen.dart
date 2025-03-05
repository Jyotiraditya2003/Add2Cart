import 'package:flutter/material.dart';
import 'create_list_screen.dart'; // Import the Create List Screen
import 'list_items_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> lists = []; // Stores lists dynamically

  void _addList(String name, List<String> sharedUsers) {
    setState(() {
      lists.add({
        'name': name,
        'sharedUsers': sharedUsers,
      });
    });
  }

  void _signOut(BuildContext context) {
    // TODO: Implement sign-out logic (Firebase or local)
    Navigator.pop(context); // Closes the drawer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Signed Out Successfully")),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("About Add2Cart"),
          content: Text("Add2Cart helps you manage shopping lists efficiently."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF1EE), // Background color as per design
      appBar: AppBar(
        backgroundColor: Color(0xFFFFF1EE),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Align(
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
              ),
              children: [
                TextSpan(text: 'Add', style: TextStyle(color: Colors.orange)),
                TextSpan(text: '2', style: TextStyle(color: Colors.blue)),
                TextSpan(text: 'Cart', style: TextStyle(color: Colors.orange)),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/cart_logo.png',
                    height: 90,
                  ),
                  SizedBox(height: 10),
                  // Removed the black "Add2Cart" text
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: Colors.black54),
              title: Text("About App"),
              onTap: () => _showAboutDialog(context),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Sign Out"),
              onTap: () => _signOut(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
              child: Text(
                'Lists',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: lists.isEmpty
                  ? Center(child: Text('No lists yet. Click + to create one.'))
                  : ListView.builder(
                itemCount: lists.length,
                itemBuilder: (context, index) {
                  return _buildListCard(index);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          // Navigate to CreateListScreen and wait for result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateListScreen(),
            ),
          );

          // If a new list is created, add it
          if (result != null && result is Map<String, dynamic>) {
            _addList(result['name'], result['sharedUsers']);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to create list. Please try again.")),
            );
          }
        },
        child: Icon(Icons.add, color: Colors.orange), // Orange + icon
      ),
    );
  }

  Widget _buildListCard(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/items',
            arguments: {
              'listName': lists[index]['name'],
              'items': lists[index]['items'] ?? [],
            },
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      lists[index]['name'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'Delete') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Delete List"),
                                content: Text("Are you sure you want to delete this list?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        lists.removeAt(index);
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("Delete", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (value == 'Edit') {
                          final updatedList = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateListScreen(
                                initialListName: lists[index]['name'],
                                initialSharedUsers: lists[index]['sharedUsers'],
                              ),
                            ),
                          );

                          if (updatedList != null && updatedList is Map<String, dynamic>) {
                            setState(() {
                              lists[index] = updatedList;
                            });
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'Edit', child: Text('Edit')),
                        PopupMenuItem(value: 'Delete', child: Text('Delete')),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                if (lists[index]['sharedUsers'] != null && lists[index]['sharedUsers'].isNotEmpty)
                  Row(
                    children: lists[index]['sharedUsers'].map<Widget>((email) {
                      return Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: CircleAvatar(
                          backgroundColor: Colors.primaries[email.hashCode % Colors.primaries.length],
                          child: Text(
                            email[0].toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}