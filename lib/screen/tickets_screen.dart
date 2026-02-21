import 'package:booking_app/models/Ttcket_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  // Reusing your primary red color
  static const Color _primaryRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100], // Subtle grey background
        appBar: AppBar(
          title: const Text(
            'My Bookings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: _primaryRed,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
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
}

class _TicketList extends StatelessWidget {
  final String statusFilter;
  const _TicketList({required this.statusFilter});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text('Please log in to view tickets.'));
    }

    final ticketsStream = FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: statusFilter)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: ticketsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFE53935)));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.confirmation_number_outlined, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No $statusFilter tickets found.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        final tickets = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            final ticketDoc = tickets[index];
            final ticketData = ticketDoc.data() as Map<String, dynamic>;
            final ticket = TicketModel.fromMap(ticketData, ticketDoc.id);

            final dateTime = (ticketData['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now();
            final seats = (ticketData['seats'] as List<dynamic>?)?.join(', ') ?? 'N/A';
            final totalPrice = ticketData['totalPrice'] ?? 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                clipBehavior: Clip.antiAlias, // Ensures child containers don't leak over corners
                child: Column(
                  children: [
                    // --- Status Header ---
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      color: _getStatusColor(statusFilter),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('PNR: ${ticketData['pnr'] ?? 'N/A'}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              statusFilter.toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- Ticket Body ---
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.directions_bus, color: Color(0xFFE53935), size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  ticket.route,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          _ticketInfoRow(Icons.calendar_month, "Date", 
                              "${dateTime.day}/${dateTime.month}/${dateTime.year}"),
                          _ticketInfoRow(Icons.access_time, "Time", 
                              "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}"),
                          _ticketInfoRow(Icons.event_seat, "Seats", seats),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Paid", style: TextStyle(color: Colors.grey)),
                              Text('\$${totalPrice.toString()}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 18, 
                                      color: Color(0xFFE53935))),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // --- Action Buttons ---
                    if (statusFilter == 'Upcoming')
                      _TicketActionButton(ticketId: ticketDoc.id),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Upcoming': return Colors.green[600]!;
      case 'Cancelled': return Colors.red[700]!;
      default: return Colors.blueGrey[600]!;
    }
  }

  Widget _ticketInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text("$label: ", style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _TicketActionButton extends StatelessWidget {
  final String ticketId;
  const _TicketActionButton({required this.ticketId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: () { /* TODO: Download PDF Logic */ },
              icon: const Icon(Icons.download, size: 20, color: Colors.blue),
              label: const Text('Ticket', style: TextStyle(color: Colors.blue)),
            ),
          ),
          Container(width: 1, height: 30, color: Colors.grey[300]),
          Expanded(
            child: TextButton.icon(
              onPressed: () => _handleCancel(context),
              icon: const Icon(Icons.cancel_outlined, size: 20, color: Colors.red),
              label: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCancel(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Cancel Booking?'),
        content: const Text('This action cannot be undone. Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Back')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('bookings').doc(ticketId).update({'status': 'Cancelled'});
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ticket successfully cancelled.')));
      }
    }
  }
}