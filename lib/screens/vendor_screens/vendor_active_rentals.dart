
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leez/screens/vendor_screens/view_details_in_my_rentals.dart'; // Import for Google Maps

class vendor_active_rentals extends StatefulWidget {
  const vendor_active_rentals({super.key});

  @override
  State<vendor_active_rentals> createState() => _homeState();
}

class _homeState extends State<vendor_active_rentals> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> activeRentals = [
    {
      'image': 'https://i.imgur.com/BJd7jzB.png',
      'title': 'Professional DSLR Camera',
      'date': 'Jun 5 - Jun 12, 2025',
      'status': 'Active'
    },
    {
      'image': 'https://i.imgur.com/uxu8YCV.png',
      'title': 'Portable Projector',
      'date': 'Jun 7 - Jun 9, 2025',
      'status': 'Active'
    },
  ];

  final List<Map<String, dynamic>> completedRentals = [
    {
      'image': 'https://i.imgur.com/jA0Tx4F.png',
      'title': 'Camping Tent (4-Person)',
      'date': 'May 28 - Jun 2, 2025',
      'status': 'Completed'
    },
    {
      'image': 'https://i.imgur.com/lmlfTAv.png',
      'title': 'Electric Scooter',
      'date': 'Jun 1 - Jun 8, 2025',
      'status': 'Completed'
    },
  ];

  final List<Map<String, dynamic>> upcomingRentals = [
    {
      'image': 'https://i.imgur.com/TcOVf0U.jpg',
      'title': 'DJI Mavic Air 2',
      'date': 'Aug 15 - Aug 22',
      'status': 'Upcoming'
    },
    {
      'image': 'https://i.imgur.com/KxqUbGy.jpg',
      'title': 'Canon EOS 5D Mark IV',
      'date': 'Aug 10 - Aug 20',
      'status': 'Upcoming'
    },
    {
      'image': 'https://i.imgur.com/5V43LNH.jpg',
      'title': 'Sony Alpha 7 III',
      'date': 'Aug 5 - Aug 15',
      'status': 'Upcoming'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Widget buildRentalCard(Map<String, dynamic> rental) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  rental['image'],
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rental['title'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(rental['date'], style: TextStyle(color: Colors.grey[700])),
                  SizedBox(height: 6),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: rental['status'] == 'Active'
                          ? Colors.green
                          : rental['status'] == 'Upcoming'
                          ? Colors.blue
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      rental['status'],
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 2,
                    height: 20,
                    indent: 0,
                    endIndent: 91,
                  ),
                  SizedBox(height: 1),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReturnConfirmationScreen(
                              title: rental['title'],
                              imageUrl: rental['image'],
                              rentedBy: 'Ethan Harper', // Replace with actual data if available
                              returnDueDate: rental['date'].split(' - ')[1], // Assuming format "start - end"
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          'View Details',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRentalList(List<Map<String, dynamic>> rentals) {
    return ListView.builder(
      itemCount: rentals.length,
      itemBuilder: (context, index) {
        return buildRentalCard(rentals[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Rentals", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: "Active"),
            Tab(text: "Completed"),
            Tab(text: "Upcoming"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildRentalList(activeRentals),
          buildRentalList(completedRentals),
          buildRentalList(upcomingRentals),
        ],
      ),
    );
  }
}