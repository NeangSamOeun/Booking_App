import 'package:booking_app/models/Ttcket_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: const TabBarView(
          children: [
            _TicketList(statusFilter: 'Upcoming'),
            _TicketList(statusFilter: 'Completed'),
            _TicketList(statusFilter: 'Cancelled'),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'My Bookings',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.red[400],
      bottom: const TabBar(
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: [
          Tab(text: 'Upcoming'),
          Tab(text: 'Completed'),
          Tab(text: 'Cancelled'),
        ],
      ),
    );
  }
}

class _TicketList extends StatelessWidget {
  final String statusFilter;
  const _TicketList({required this.statusFilter});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text('User not logged in.'));
    }

    final ticketsStream = FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: statusFilter)
        //.orderBy('dateTime', descending: true) // Comment out if no index
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: ticketsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No $statusFilter tickets found.',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          );
        }

        final tickets = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            final ticketData = tickets[index].data() as Map<String, dynamic>;
            final pnr = ticketData['pnr'] ?? '';
            // final route = ticketData['busRoute'] ?? '';
            final ticket = TicketModel.fromMap(ticketData, tickets[index].id);

            final dateTime = (ticketData['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now();
            final seats = (ticketData['seats'] as List<dynamic>?)?.join(', ') ?? '';
            final totalPrice = ticketData['totalPrice'] ?? 0;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8), // only vertical spacing
              child: Container(
                width: double.infinity, // FULL WIDTH
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusFilter == 'Upcoming'
                            ? Colors.green
                            : statusFilter == 'Cancelled'
                                ? Colors.red
                                : Colors.blueGrey,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('PNR: $pnr',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(ticketData['status'] ?? '',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),

                    // Ticket details container
                    Container(
                      width: double.infinity, // FULL WIDTH
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(route, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(ticket.route, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('Date: ${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2,'0')}'),
                            const SizedBox(height: 4),
                            Text('Seats: $seats'),
                            const SizedBox(height: 4),
                            Text('Total: \$${totalPrice.toString()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),

                    if (statusFilter == 'Upcoming')
                      _TicketActionButton(ticketId: tickets[index].id),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _TicketActionButton extends StatelessWidget {
  final String ticketId;

  const _TicketActionButton({required this.ticketId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Download button
            TextButton.icon(
              onPressed: () {
                // TODO: Add download ticket functionality
              },
              icon: Icon(Icons.download, color: Colors.blue[700]),
              label: Text('Download', style: TextStyle(color: Colors.blue[700])),
            ),

            VerticalDivider(color: Colors.grey[300]),

            // Cancel button
            TextButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Cancel Ticket'),
                    content: const Text('Are you sure you want to cancel this ticket?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('No'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Yes, Cancel'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await FirebaseFirestore.instance
                      .collection('bookings')
                      .doc(ticketId)
                      .update({'status': 'Cancelled'});

                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ticket Cancelled')));
                }
              },
              icon: Icon(Icons.cancel, color: Colors.red[700]),
              label: Text('Cancel', style: TextStyle(color: Colors.red[700])),
            ),
          ],
        ),
      ),
    );
  }
}
