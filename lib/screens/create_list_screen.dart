import 'package:flutter/material.dart';

class CreateListScreen extends StatefulWidget {
  final String? initialListName; // For editing
  final List<String>? initialSharedUsers; // For editing

  CreateListScreen({this.initialListName, this.initialSharedUsers});

  @override
  _CreateListScreenState createState() => _CreateListScreenState();
}

class _CreateListScreenState extends State<CreateListScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  List<String> sharedEmails = [];

  @override
  void initState() {
    super.initState();
    // Set initial values if provided (for editing)
    if (widget.initialListName != null) {
      _nameController.text = widget.initialListName!;
    }
    if (widget.initialSharedUsers != null) {
      sharedEmails = List.from(widget.initialSharedUsers!);
    }
  }

  // Add email to the list
  void _addEmail() {
    String email = _emailController.text.trim();
    if (email.isNotEmpty && !sharedEmails.contains(email)) {
      setState(() {
        sharedEmails.add(email);
        _emailController.clear();
      });
    }
  }

  // Remove email from the list
  void _removeEmail(String email) {
    setState(() {
      sharedEmails.remove(email);
    });
  }

  // Save the list and pass data back
  void _saveList() {
    String listName = _nameController.text.trim();
    if (listName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a list name")),
      );
      return;
    }

    Navigator.pop(context, {
      'name': listName,
      'sharedUsers': sharedEmails,
    });
  }

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
        title: Align(
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Arial'),
              children: [
                TextSpan(text: 'Add', style: TextStyle(color: Colors.orange)),
                TextSpan(text: '2', style: TextStyle(color: Colors.blueAccent)),
                TextSpan(text: 'Cart', style: TextStyle(color: Colors.orange)),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              widget.initialListName == null ? 'Create New List' : 'Edit List',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            SizedBox(height: 30),

            // List Name Input
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.list, color: Colors.black54),
                  hintText: 'Enter list name',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Email Input Field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.alternate_email, color: Colors.black54),
                          hintText: 'Enter email',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle, color: Colors.orange),
                      onPressed: _addEmail,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            // Display Added Emails
            Wrap(
              spacing: 8.0,
              children: sharedEmails
                  .map((email) => Chip(
                label: Text(email),
                deleteIcon: Icon(Icons.close),
                onDeleted: () => _removeEmail(email),
              ))
                  .toList(),
            ),

            SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel Button
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  ),
                  child: Text('Cancel', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),

                // Save Button
                ElevatedButton(
                  onPressed: _saveList,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  ),
                  child: Text(
                    widget.initialListName == null ? 'Create' : 'Save',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
