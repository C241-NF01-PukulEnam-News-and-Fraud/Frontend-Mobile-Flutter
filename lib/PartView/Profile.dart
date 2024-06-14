import 'package:flutter/material.dart';


class ProfileSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/sayang.jpg'), // Add your asset image here
                ),
                TextButton(
                  onPressed: () {
                    // Add action for editing photo profile
                  },
                  child: Text(
                    'Edit Photo Profile',
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Name', style: TextStyle(color: Colors.black)),
            subtitle: Text('Amura', style: TextStyle(color: Colors.grey)),
            trailing: Icon(Icons.edit, color: Colors.black),
            onTap: () {
              // Add action for editing name
            },
          ),
          ListTile(
            title: Text('Email for receipt', style: TextStyle(color: Colors.black)),
            subtitle: Text('edogawaconax@gmail.com', style: TextStyle(color: Colors.grey)),
            trailing: Icon(Icons.edit, color: Colors.black),
            onTap: () {
              // Add action for editing email
            },
          ),
          ListTile(
            title: Text('Default payment', style: TextStyle(color: Colors.black)),
            subtitle: Text('DANA 08995', style: TextStyle(color: Colors.grey)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
            onTap: () {
              // Add action for editing payment method
            },
          ),
          ListTile(
            title: Text('Subscribe reports', style: TextStyle(color: Colors.black)),
            subtitle: Text('Monthly', style: TextStyle(color: Colors.grey)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
            onTap: () {
              // Add action for viewing trip reports
            },
          ),
          ListTile(
            title: Text('Log Out', style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              // Add action for account deletion
            },
          ),
          ListTile(
            title: Text('Switch Account', style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              // Add action for account deletion
            },
          ),
        ],
      ),
    );
  }
}
