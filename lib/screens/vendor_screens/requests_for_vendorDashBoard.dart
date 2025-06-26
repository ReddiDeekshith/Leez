import 'package:flutter/material.dart';

class RentalRequestsScreen extends StatefulWidget {
  @override
  _RentalRequestsScreenState createState() => _RentalRequestsScreenState();
}

class _RentalRequestsScreenState extends State<RentalRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<RentalRequest> pendingRequests = [];
  List<RentalRequest> acceptedRequests = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Initialize with sample data
    pendingRequests = [
      RentalRequest(
        id: 'REQ001',
        userName: 'John Doe',
        itemName: 'Camera Equipment',
        imageUrl: 'https://via.placeholder.com/150',
        dateTime: DateTime.now().subtract(Duration(hours: 2)),
        rentalDuration: '3 days',
        estimatedCost: 150.0,
      ),
      RentalRequest(
        id: 'REQ002',
        userName: 'Jane Smith',
        itemName: 'Laptop',
        imageUrl: 'https://via.placeholder.com/150',
        dateTime: DateTime.now().subtract(Duration(hours: 5)),
        rentalDuration: '1 week',
        estimatedCost: 200.0,
      ),
    ];

    acceptedRequests = [
      RentalRequest(
        id: 'REQ003',
        userName: 'Mike Johnson',
        itemName: 'Projector',
        imageUrl: 'https://via.placeholder.com/150',
        dateTime: DateTime.now().subtract(Duration(days: 1)),
        rentalDuration: '2 days',
        estimatedCost: 80.0,
      ),
    ];
  }

  void _acceptRequest(RentalRequest request) {
    setState(() {
      pendingRequests.remove(request);
      acceptedRequests.add(request);
    });

    // Switch to accepted tab
    _tabController.animateTo(1);

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${request.itemName} has been moved to accepted requests!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.white,
          onPressed: () {
            _tabController.animateTo(1);
          },
        ),
      ),
    );
  }

  void _cancelRequest(RentalRequest request) {
    setState(() {
      pendingRequests.remove(request);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${request.itemName} request has been cancelled!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rental Requests'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Pending'),
            Tab(text: 'Accepted'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PendingRequestsTab(
            pendingRequests: pendingRequests,
            onAcceptRequest: _acceptRequest,
            onCancelRequest: _cancelRequest,
          ),
          AcceptedRequestsTab(acceptedRequests: acceptedRequests),
        ],
      ),
    );
  }
}

class PendingRequestsTab extends StatelessWidget {
  final List<RentalRequest> pendingRequests;
  final Function(RentalRequest) onAcceptRequest;
  final Function(RentalRequest) onCancelRequest;

  const PendingRequestsTab({
    Key? key,
    required this.pendingRequests,
    required this.onAcceptRequest,
    required this.onCancelRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: pendingRequests.length,
      itemBuilder: (context, index) {
        return ExpandableRequestCard(
          request: pendingRequests[index],
          isPending: true,
          onAcceptRequest: onAcceptRequest,
          onCancelRequest: onCancelRequest,
        );
      },
    );
  }
}

class AcceptedRequestsTab extends StatelessWidget {
  final List<RentalRequest> acceptedRequests;

  const AcceptedRequestsTab({
    Key? key,
    required this.acceptedRequests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: acceptedRequests.length,
      itemBuilder: (context, index) {
        return ExpandableRequestCard(
          request: acceptedRequests[index],
          isPending: false,
        );
      },
    );
  }
}

class ExpandableRequestCard extends StatefulWidget {
  final RentalRequest request;
  final bool isPending;
  final Function(RentalRequest)? onAcceptRequest;
  final Function(RentalRequest)? onCancelRequest;

  const ExpandableRequestCard({
    Key? key,
    required this.request,
    required this.isPending,
    this.onAcceptRequest,
    this.onCancelRequest,
  }) : super(key: key);

  @override
  _ExpandableRequestCardState createState() => _ExpandableRequestCardState();
}

class _ExpandableRequestCardState extends State<ExpandableRequestCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        child: Column(
          children: [
            // Compressed view
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.request.imageUrl),
              ),
              title: Text(widget.request.itemName),
              subtitle: Text(widget.request.userName),
              trailing: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),

            // Expanded view
            if (isExpanded) ...[
              Divider(),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Request details
                    _buildDetailRow('Request ID:', widget.request.id),
                    SizedBox(height: 8),
                    _buildDetailRow('Date & Time:',
                        '${widget.request.dateTime.day}/${widget.request.dateTime.month}/${widget.request.dateTime.year} at ${widget.request.dateTime.hour}:${widget.request.dateTime.minute.toString().padLeft(2, '0')}'),
                    SizedBox(height: 8),
                    _buildDetailRow('Rental Duration:', widget.request.rentalDuration),
                    SizedBox(height: 8),
                    _buildDetailRow('Item Name:', widget.request.itemName),
                    SizedBox(height: 8),
                    _buildDetailRow('Total Estimated Cost:', '\$${widget.request.estimatedCost.toStringAsFixed(2)}'),
                    SizedBox(height: 8),
                    _buildDetailRow('User Name:', widget.request.userName),
                    SizedBox(height: 16),

                    // Item image
                    Center(
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(widget.request.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Action buttons (only for pending requests)
                    if (widget.isPending) ...[
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _showConfirmDialog(
                                  context,
                                  'Cancel Request',
                                  'Are you sure you want to cancel this request?',
                                      () => widget.onCancelRequest?.call(widget.request),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: Text('Cancel Request'),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _showConfirmDialog(
                                  context,
                                  'Accept Request',
                                  'Are you sure you want to accept this request?',
                                      () => widget.onAcceptRequest?.call(widget.request),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: Text('Accept Request'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _showDialog(context, 'Contact & Support',
                                'Contacting support for request ${widget.request.id}');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Contact & Support'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  void _showConfirmDialog(BuildContext context, String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: TextButton.styleFrom(
                foregroundColor: title.contains('Accept') ? Colors.green : Colors.red,
              ),
              child: Text(title.contains('Accept') ? 'Accept' : 'Cancel Request'),
            ),
          ],
        );
      },
    );
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class RentalRequest {
  final String id;
  final String userName;
  final String itemName;
  final String imageUrl;
  final DateTime dateTime;
  final String rentalDuration;
  final double estimatedCost;

  RentalRequest({
    required this.id,
    required this.userName,
    required this.itemName,
    required this.imageUrl,
    required this.dateTime,
    required this.rentalDuration,
    required this.estimatedCost,
  });
}