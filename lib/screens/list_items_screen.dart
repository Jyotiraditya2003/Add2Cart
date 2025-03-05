import 'package:flutter/material.dart';

class ListItemsScreen extends StatefulWidget {
  final String listName;
  final List<Map<String, dynamic>> items;

  ListItemsScreen({required this.listName, required this.items});

  @override
  _ListItemsScreenState createState() => _ListItemsScreenState();
}

class _ListItemsScreenState extends State<ListItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF1EE), // Background color as per design
      appBar: AppBar(
        backgroundColor: Color(0xFFFFF1EE),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(text: 'Add', style: TextStyle(color: Colors.orange)),
              TextSpan(text: '2', style: TextStyle(color: Colors.blue)),
              TextSpan(text: 'Cart', style: TextStyle(color: Colors.orange)),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                widget.listName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: widget.items[index]['image'] != null
                                ? DecorationImage(
                              image: NetworkImage(widget.items[index]['image']),
                              fit: BoxFit.cover,
                            )
                                : null,
                            color: widget.items[index]['image'] == null
                                ? Colors.black54
                                : Colors.transparent,
                          ),
                          child: widget.items[index]['image'] == null
                              ? Icon(Icons.image, color: Colors.white)
                              : null,
                        ),
                        title: Text(
                          widget.items[index]['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Checkbox(
                          value: widget.items[index]['checked'],
                          onChanged: (bool? value) {
                            setState(() {
                              widget.items[index]['checked'] = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Item Screen (Replace 'AddItemScreen' with actual screen name)
          Navigator.pushNamed(context, '/add_item');
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.orange),
      ),
    );
  }
}
