import 'package:flutter/material.dart';
import 'package:leez/constants/colors.dart';
import 'package:leez/screens/vendor_screens/requests_for_vendorDashBoard.dart';
import 'package:leez/screens/vendor_screens/saleschart.dart';
import 'package:leez/screens/vendor_screens/vendor_active_rentals.dart';

import 'kyc_IdentityVerificationScreen1.dart';

// not calling this from main dash board calling the dashboardscreen down ok
class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hoe'), centerTitle: true),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen()),
            );
          },
          child: Text('Go to Dashboard'),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final List<DashboardCardData> cards = [
    DashboardCardData(
      icon: Icons.view_list,
      count: '24',
      label: 'My Rentals',
      color: AppColors.primary,
      hoverColor: Colors.lightBlue.shade200,
    ),
    DashboardCardData(
      icon: Icons.calendar_today,
      count: '8',
      label: 'Requests',
      color: AppColors.primary,
      hoverColor: Colors.green.shade200,
    ),
    DashboardCardData(
      icon: Icons.calendar_today_sharp,
      count: '₹45,680',
      label: 'Monthly Revenue',
      color: AppColors.primary,
      hoverColor: Colors.purple.shade200,
    ),
  ];

  // Simulate backend response (this will be dynamic later)
  final String bookingStatus = "ongoing"; // or "completed"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ScrollConfiguration(
          behavior: ScrollBehavior().copyWith(
            scrollbars: false, // Disable the scrollbar
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Row(
                  children: [
                    // SizedBox(height: 22),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back,",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Balaraju",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 6,
                            bottom: 9,
                            child: Center(
                              child: Icon(
                                Icons.notifications_none,
                                color: Colors.black,
                                size: 29,
                              ),
                            ),
                          ),
                          // Notification dot
                          Positioned(
                            top: 5,
                            right: 12,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children:
                      cards.asMap().entries.where((entry) => entry.key != 3).map((
                        entry,
                      ) {
                        int index = entry.key;
                        DashboardCardData card = entry.value;

                        double cardWidth =
                            (card.label == "Monthly Revenue") ? 340 : 160;

                        return GestureDetector(
                          onTap: () {
                            switch (index) {
                              case 0:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => vendor_active_rentals(),
                                  ),
                                );
                                break;
                              case 1:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RentalRequestsScreen(),
                                  ),
                                );
                                break;
                              // case 2:
                              //   Navigator.push(context, MaterialPageRoute(builder: (_) => vendor_active_rentals()));
                              //   break;
                            }
                          },
                          child: DashboardCard(card, customWidth: cardWidth),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 40),
                //BookingStatusWidget(bookingStatus: bookingStatus),
                SalesChart(),

                const SizedBox(height: 30),

                KYCStatusCard(kycVerified: false),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KYCStatusCard extends StatelessWidget {
  final bool kycVerified;

  const KYCStatusCard({required this.kycVerified});

  @override
  Widget build(BuildContext context) {
    // Only show the card if KYC is NOT verified
    if (kycVerified) return SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(58, 0, 0, 0),
            blurRadius: 8,
            offset: Offset(2, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text(
                "KYC Verification Pending",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Complete your verification to unlock premium features and higher earning potential.",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IdentityVerificationScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Complete KYC Now",
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCardData {
  final IconData icon;
  final String count;
  final String label;
  final Color color;
  final Color hoverColor;

  DashboardCardData({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
    required this.hoverColor,
  });
}

class DashboardCard extends StatefulWidget {
  final DashboardCardData data;
  final double? customWidth;

  DashboardCard(this.data, {this.customWidth});

  @override
  _DashboardCardState createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          width: widget.customWidth ?? 160,
          height: 150,
          decoration: BoxDecoration(
            color: isHovered ? widget.data.hoverColor : widget.data.color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(58, 0, 0, 0),
                blurRadius: 8,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(widget.data.icon, size: 28),
              const SizedBox(height: 20),
              Text(
                widget.data.count,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(widget.data.label),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingStatusWidget extends StatelessWidget {
  final String bookingStatus;

  BookingStatusWidget({required this.bookingStatus});

  final List<String> steps = [
    "Requested",
    "Approved",
    "Picked Up",
    "Returned",
    "Completed",
  ];

  @override
  Widget build(BuildContext context) {
    int activeSteps = bookingStatus == "completed" ? 5 : 3;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF7FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                "Current Booking",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.circle, color: Colors.green, size: 10),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(steps.length, (index) {
            bool isActive = index < activeSteps;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  isActive
                      ? CircleAvatar(
                        backgroundColor: Colors.purpleAccent,
                        radius: 12,
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      )
                      : CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        radius: 12,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  const SizedBox(width: 12),
                  Text(
                    steps[index],
                    style: TextStyle(
                      fontSize: 16,
                      color: isActive ? Colors.black : Colors.grey,
                      fontWeight:
                          isActive ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isActive ? Icons.circle : Icons.circle_outlined,
                    color: isActive ? Colors.green : Colors.grey,
                    size: 10,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}











































// // import 'package:flutter/material.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import for Google Maps
// //
// // class home extends StatefulWidget {
// //   const home({super.key});
// //
// //   @override
// //   State<home> createState() => _homeState();
// // }
// //
// // class _homeState extends State<home> {
// //   int selectedIndex = 0; // 0 = Your space, 1 = Arrival guide
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         leading: const Icon(Icons.arrow_back, color: Colors.black),
// //         title: const Text(
// //           "Listing editor",
// //           style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
// //         ),
// //         actions: const [
// //           Padding(
// //             padding: EdgeInsets.only(right: 16.0),
// //             child: Icon(Icons.settings, color: Colors.black),
// //           ),
// //         ],
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //       ),
// //       backgroundColor: const Color(0xFFF5F5F5), // Light grey background as in the image
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 _buildTab("Your space", 0),
// //                 _buildTab("Arrival guide", 1),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             child: selectedIndex == 0 ? _buildYourSpaceContent() : _buildArrivalGuideContent(),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTab(String title, int index) {
// //     bool isSelected = selectedIndex == index;
// //     return Expanded(
// //       child: Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 4.0), // Increased spacing between tabs
// //         child: GestureDetector(
// //           onTap: () => setState(() => selectedIndex = index),
// //           child: Container(
// //             padding: const EdgeInsets.symmetric(vertical: 10),
// //             decoration: BoxDecoration(
// //               color: isSelected ? Colors.white : const Color(0xFFE0E0E0),
// //               borderRadius: BorderRadius.circular(30), // Fully rounded corners for each tab
// //               boxShadow: isSelected
// //                   ? [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.2),
// //                   blurRadius: 6,
// //                   offset: const Offset(0, 2),
// //                 ),
// //               ]
// //                   : [],
// //             ),
// //             alignment: Alignment.center,
// //             child: Text(
// //               title,
// //               style: const TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.black,
// //                 fontSize: 14,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildCard(String title, {String? subtitle, IconData? icon, Widget? customContent, bool showChevron = true}) {
// //     return Card(
// //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       elevation: 2,
// //       child: Padding(
// //         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
// //         child: customContent ??
// //             Row(
// //               children: [
// //                 if (icon != null) ...[
// //                   Icon(icon, color: Colors.black54, size: 24),
// //                   const SizedBox(width: 16),
// //                 ],
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         title,
// //                         style: const TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.black,
// //                         ),
// //                       ),
// //                       if (subtitle != null)
// //                         Padding(
// //                           padding: const EdgeInsets.only(top: 4),
// //                           child: Text(
// //                             subtitle,
// //                             style: TextStyle(
// //                               fontSize: 14,
// //                               color: title == "Complete required steps"
// //                                   ? Colors.black87
// //                                   : Colors.black54,
// //                             ),
// //                           ),
// //                         ),
// //                     ],
// //                   ),
// //                 ),
// //                 if (showChevron)
// //                   const Icon(Icons.chevron_right, color: Colors.black54),
// //               ],
// //             ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildYourSpaceContent() {
// //     return ListView(
// //       children: [
// //         _buildCard(
// //           "Complete required steps",
// //           subtitle: "Finish these final tasks to publish your listing and start getting booked.",
// //           customContent: Row(
// //             children: [
// //               Container(
// //                 width: 8,
// //                 height: 8,
// //                 decoration: const BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   color: Colors.red,
// //                 ),
// //               ),
// //               const SizedBox(width: 16),
// //               const Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       "Complete required steps",
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.black,
// //                       ),
// //                     ),
// //                     SizedBox(height: 4),
// //                     Text(
// //                       "Finish these final tasks to publish your listing and start getting booked.",
// //                       style: TextStyle(
// //                         fontSize: 14,
// //                         color: Colors.black87,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const Icon(Icons.chevron_right, color: Colors.black54),
// //             ],
// //           ),
// //         ),
// //         _buildCard(
// //           "Photo tour",
// //           subtitle: "1 bedroom · 1 bed · 1 bath",
// //           customContent: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text(
// //                 "Photo tour",
// //                 style: TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black,
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
// //               // Network image for Photo tour
// //               Container(
// //                 height: 100,
// //                 width: double.infinity,
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(8),
// //                   image: const DecorationImage(
// //                     image: NetworkImage(
// //                       'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
// //                     ),
// //                     fit: BoxFit.cover,
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
// //               const Text(
// //                 "1 bedroom · 1 bed · 1 bath",
// //                 style: TextStyle(fontSize: 14, color: Colors.black54),
// //               ),
// //             ],
// //           ),
// //           showChevron: false,
// //         ),
// //         _buildCard("Title", subtitle: "fake"),
// //         _buildCard("Property type", subtitle: "Entire place · Rental unit"),
// //         _buildCard(
// //           "Pricing",
// //           subtitle: "₹1,794 per night\n10% weekly discount",
// //         ),
// //         _buildCard(
// //           "Availability",
// //           subtitle: "1–365 night stays\nSame-day advance notice",
// //         ),
// //         _buildCard("Number of guests", subtitle: "4 guests"),
// //         _buildCard(
// //           "Description",
// //           subtitle: "You'll have a great time at this comfortable place to stay.",
// //         ),
// //         _buildCard("Amenities"),
// //         _buildCard("Accessibility features"),
// //         _buildCard(
// //           "Location",
// //           subtitle: "Mandapeta By-pass Rd, Gandhi Nagar, Mandapeta, Andhra Pradesh 533308, India",
// //           customContent: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text(
// //                 "Location",
// //                 style: TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black,
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
// //               // Google Map widget for Location
// //               SizedBox(
// //                 height: 150,
// //                 width: double.infinity,
// //                 child: GoogleMap(
// //                   initialCameraPosition: const CameraPosition(
// //                     target: LatLng(16.8675, 81.9326), // Coordinates for Mandapeta
// //                     zoom: 14,
// //                   ),
// //                   markers: {
// //                     const Marker(
// //                       markerId: MarkerId('location'),
// //                       position: LatLng(16.8675, 81.9326),
// //                       infoWindow: InfoWindow(title: "Mandapeta"),
// //                     ),
// //                   },
// //                   liteModeEnabled: true, // Use lite mode for better performance
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
// //               const Text(
// //                 "Mandapeta By-pass Rd, Gandhi Nagar, Mandapeta, Andhra Pradesh 533308, India",
// //                 style: TextStyle(fontSize: 14, color: Colors.black54),
// //               ),
// //             ],
// //           ),
// //           showChevron: false,
// //         ),
// //         _buildCard(
// //           "About the host",
// //           subtitle: "Suchandra\nStarted hosting in 2025",
// //           customContent: Row(
// //             children: [
// //               // Network image for host profile
// //               Container(
// //                 width: 50,
// //                 height: 50,
// //                 decoration: const BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   image: DecorationImage(
// //                     image: NetworkImage(
// //                       'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
// //                     ),
// //                     fit: BoxFit.cover,
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(width: 16),
// //               const Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       "About the host",
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.black,
// //                       ),
// //                     ),
// //                     SizedBox(height: 4),
// //                     Text(
// //                       "Suchandra\nStarted hosting in 2025",
// //                       style: TextStyle(fontSize: 14, color: Colors.black54),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //           showChevron: false,
// //         ),
// //         _buildCard("Co-hosts"),
// //         _buildCard("Booking settings", subtitle: "Guests can book automatically with Instant Book"),
// //         _buildCard(
// //           "House Rules",
// //           subtitle: "4 guests maximum",
// //           icon: Icons.people,
// //         ),
// //         _buildCard(
// //           "Guest safety",
// //           subtitle: "Carbon monoxide alarm not reported\nSmoke alarm not reported",
// //           customContent: const Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 "Guest safety",
// //                 style: TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black,
// //                 ),
// //               ),
// //               SizedBox(height: 8),
// //               Row(
// //                 children: [
// //                   Icon(Icons.cancel_outlined, color: Colors.black54, size: 20),
// //                   SizedBox(width: 8),
// //                   Text(
// //                     "Carbon monoxide alarm not reported",
// //                     style: TextStyle(fontSize: 14, color: Colors.black54),
// //                   ),
// //                 ],
// //               ),
// //               SizedBox(height: 4),
// //               Row(
// //                 children: [
// //                   Icon(Icons.cancel_outlined, color: Colors.black54, size: 20),
// //                   SizedBox(width: 8),
// //                   Text(
// //                     "Smoke alarm not reported",
// //                     style: TextStyle(fontSize: 14, color: Colors.black54),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //           showChevron: false,
// //         ),
// //         _buildCard("Cancellation policy", subtitle: "Flexible"),
// //         _buildCard("Custom link"),
// //         Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: ElevatedButton.icon(
// //             onPressed: () {},
// //             icon: const Icon(Icons.remove_red_eye, size: 20),
// //             label: const Text("View"),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colors.black,
// //               foregroundColor: Colors.white,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(30),
// //               ),
// //               minimumSize: const Size(double.infinity, 48),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildArrivalGuideContent() {
// //     return ListView(
// //       children: [
// //         _buildCard(
// //           "Complete required steps",
// //           subtitle: "Finish these final tasks to publish your listing",
// //           customContent: Row(
// //             children: [
// //               Container(
// //                 width: 8,
// //                 height: 8,
// //                 decoration: const BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   color: Colors.red,
// //                 ),
// //               ),
// //               const SizedBox(width: 16),
// //               const Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       "Complete required steps",
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.black,
// //                       ),
// //                     ),
// //                     SizedBox(height: 4),
// //                     Text(
// //                       "Finish these final tasks to publish your listing and start getting booked.",
// //                       style: TextStyle(
// //                         fontSize: 14,
// //                         color: Colors.black87,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const Icon(Icons.chevron_right, color: Colors.black54),
// //             ],
// //           ),
// //         ),
// //         _buildCard("Check-in"),
// //         _buildCard("Checkout"),
// //         _buildCard("Directions"),
// //         _buildCard("Check-in method"),
// //         _buildCard("Wi-Fi details"),
// //         _buildCard("House manual"),
// //         _buildCard(
// //           "House Rules",
// //           subtitle: "4 guests maximum",
// //           icon: Icons.people,
// //         ),
// //         _buildCard("Checkout instructions"),
// //         _buildCard("Guidebooks"),
// //         _buildCard("Interaction preferences"),
// //         Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: ElevatedButton.icon(
// //             onPressed: () {},
// //             icon: const Icon(Icons.remove_red_eye, size: 20),
// //             label: const Text("View"),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colors.black,
// //               foregroundColor: Colors.white,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(30),
// //               ),
// //               minimumSize: const Size(double.infinity, 48),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
// //
// //
// //
// //
// //
// // // -----------------------------------------------------------------------------------------------------------
// // //
// // //
// // //
// // //
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import for Google Maps
//
//
// class home extends StatefulWidget {
//   const home({super.key});
//
//   @override
//   State<home> createState() => _homeState();
// }
//
// class _homeState extends State<home> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   final List<Map<String, dynamic>> activeRentals = [
//     {
//       'image': 'https://i.imgur.com/BJd7jzB.png',
//       'title': 'Professional DSLR Camera',
//       'date': 'Jun 5 - Jun 12, 2025',
//       'status': 'Active'
//     },
//     {
//       'image': 'https://i.imgur.com/uxu8YCV.png',
//       'title': 'Portable Projector',
//       'date': 'Jun 7 - Jun 9, 2025',
//       'status': 'Active'
//     },
//   ];
//
//   final List<Map<String, dynamic>> completedRentals = [
//     {
//       'image': 'https://i.imgur.com/jA0Tx4F.png',
//       'title': 'Camping Tent (4-Person)',
//       'date': 'May 28 - Jun 2, 2025',
//       'status': 'Completed'
//     },
//     {
//       'image': 'https://i.imgur.com/lmlfTAv.png',
//       'title': 'Electric Scooter',
//       'date': 'Jun 1 - Jun 8, 2025',
//       'status': 'Completed'
//     },
//   ];
//
//   final List<Map<String, dynamic>> upcomingRentals = [
//     {
//       'image': 'https://i.imgur.com/TcOVf0U.jpg',
//       'title': 'DJI Mavic Air 2',
//       'date': 'Aug 15 - Aug 22',
//       'status': 'Upcoming'
//     },
//     {
//       'image': 'https://i.imgur.com/KxqUbGy.jpg',
//       'title': 'Canon EOS 5D Mark IV',
//       'date': 'Aug 10 - Aug 20',
//       'status': 'Upcoming'
//     },
//     {
//       'image': 'https://i.imgur.com/5V43LNH.jpg',
//       'title': 'Sony Alpha 7 III',
//       'date': 'Aug 5 - Aug 15',
//       'status': 'Upcoming'
//     },
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }
//
//   Widget buildRentalCard(Map<String, dynamic> rental) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(
//                   rental['image'],
//                   width: 70,
//                   height: 70,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     rental['title'],
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   Text(rental['date'], style: TextStyle(color: Colors.grey[700])),
//                   SizedBox(height: 6),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: rental['status'] == 'Active'
//                           ? Colors.green
//                           : rental['status'] == 'Upcoming'
//                           ? Colors.blue
//                           : Colors.grey,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       rental['status'],
//                       style: TextStyle(color: Colors.white, fontSize: 12),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Divider(
//                     color: Colors.grey.shade300,
//                     thickness: 2,        // Height/thickness of the divider line
//                     height: 20,          // Total height including spacing above and below
//                     indent: 0,          // Left margin/spacing
//                     endIndent: 91,       // Right margin/spacing
//                   ),
//                   SizedBox(height: 1),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: InkWell(
//                       onTap: () {
//                         // No action for now, just clickable
//                         print('View Details clicked');
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         child: Text(
//                           'View Details',
//                           style: TextStyle(color: Colors.blue),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Widget buildRentalList(List<Map<String, dynamic>> rentals) {
//     return ListView.builder(
//       itemCount: rentals.length,
//       itemBuilder: (context, index) {
//         return buildRentalCard(rentals[index]);
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Rentals", style: TextStyle(color: Colors.black)),
//         centerTitle: true,
//         leading: Icon(Icons.arrow_back, color: Colors.black),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: Colors.black,
//           indicatorColor: Colors.black,
//           unselectedLabelColor: Colors.grey,
//           tabs: [
//             Tab(text: "Active"),
//             Tab(text: "Completed"),
//             Tab(text: "Upcoming"),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           buildRentalList(activeRentals),
//           buildRentalList(completedRentals),
//           buildRentalList(upcomingRentals),
//         ],
//       ),
//     );
//   }
// }