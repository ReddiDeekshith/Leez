import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:leez/screens/user_screens/AccountSettings.dart';
import 'package:leez/screens/user_screens/account.dart';
import 'package:leez/screens/user_screens/getHelp.dart';
import 'package:leez/screens/user_screens/viewProfile.dart';
import 'package:leez/screens/vendor_screens/MainDashboard.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userData = {};
  String _id = "6858ed546ab8ecdbc9264c2e";
  bool isLoading = true;
  String imageUrl = 'https://www.w3schools.com/w3images/avatar2.png';

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    Uri uri = Uri.parse(
      "https://leez-app.onrender.com/api/customer/get-customer-details/$_id",
    );
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userData = data['Customer-details'] ?? {};
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: height * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 3,
                      color: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: height * 0.03,
                          horizontal: width * 0.05,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: width * 0.4,
                              height: width * 0.4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                image: DecorationImage(
                                  image: NetworkImage(
                                    "https://res.cloudinary.com/dyigkc2zy/image/upload/v1750151597/" +
                                            userData['photo'] ??
                                        imageUrl,
                                  ),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            Text(
                              userData['name']?.toString() ??
                                  'Name not available',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: width * 0.05,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Guest',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.025),
                    // ElevatedButton.icon(
                    //   onPressed: () {
                    //     Navigator.push(context, MaterialPageRoute(builder: (context)=>MenuScreen()));
                    //   },
                    //   icon: Icon(Icons.home_outlined),
                    //   label: Text(
                    //     'Become a host',
                    //     style: TextStyle(fontWeight: FontWeight.bold),
                    //   ),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.black,
                    //     foregroundColor: Colors.white,
                    //     padding: EdgeInsets.symmetric(vertical: 14),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: height * 0.02),
                    _buildSectionDivider("Account"),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.settings,
                      title: 'Account settings',
                      destination: AccountSettingsPage(),
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.help_outline,
                      title: 'Get help',
                      destination: Gethelp(),
                    ),
                    _buildViewProfileItem(context),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy',
                      destination: AccountSettingsPage(),
                    ),
                    _buildSectionDivider("Community"),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.group_outlined,
                      title: 'Refer a host',
                      destination: AccountSettingsPage(),
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.group_add_outlined,
                      title: 'Find a co-host',
                      destination: AccountSettingsPage(),
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.description_outlined,
                      title: 'Legal',
                      destination: AccountSettingsPage(),
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.logout,
                      title: 'Log out',
                      destination: AccountSettingsPage(),
                    ),
                    SizedBox(height: height * 0.04),
                  ],
                ),
              ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainDashboard()),
            );
          },
          icon: Icon(Icons.sync_alt),
          label: Text(
            "Switch to hosting",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionDivider(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Divider(thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(thickness: 1)),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget destination,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24, color: Colors.black87),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }

  Widget _buildViewProfileItem(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person_outline, size: 24, color: Colors.black87),
      title: Text(
        "View/Edit profile",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => Viewprofile(
                  email: userData['email'],
                  password: userData['password'],
                  userName: userData['name'],
                  imageUrl:
                      "https://res.cloudinary.com/dyigkc2zy/image/upload/v1750151597/" +
                      userData['photo'],
                  phoneNumber: userData['phoneNo'],
                  customerId: userData['_id'],
                ),
          ),
        );
        if (result == true) {
          loadProfile();
        }
      },
    );
  }
}
