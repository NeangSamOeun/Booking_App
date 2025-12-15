// screens/tickets_screen.dart

import 'package:flutter/material.dart';
// Assuming the UpcomingJourneyCard is imported for visual consistency
import '../widgets/upcoming_journey_card.dart'; 

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Upcoming, Completed, Cancelled
      child: Scaffold(
        appBar: _buildAppBar(),
        body: const TabBarView(
          children: [
            // 1. Upcoming Tickets Tab
            _TicketList(type: 'Upcoming'), 
            // 2. Completed Tickets Tab
            _TicketList(type: 'Completed'),
            // 3. Cancelled Tickets Tab
            _TicketList(type: 'Cancelled'),
          ],
        ),
      ),
    );
  }

  // --- App Bar with Tabs ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'My Bookings',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.red[400],
      elevation: 0,
      centerTitle: false,
      bottom: const TabBar(
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: [
          Tab(text: 'Upcoming (2)'),
          Tab(text: 'Completed (8)'),
          Tab(text: 'Cancelled (1)'),
        ],
      ),
    );
  }
}

// --- Helper Widget for displaying the list of tickets ---
class _TicketList extends StatelessWidget {
  final String type;

  const _TicketList({required this.type});

  // Dummy data generation based on tab type
  List<Map<String, dynamic>> _getTickets() {
    if (type == 'Upcoming') {
      return [
        {'id': 1, 'pnr': 'A1B2C3', 'route': 'Pune to Bhusawal', 'date': 'Today, 8:05 PM', 'status': 'Confirmed'},
        {'id': 2, 'pnr': 'D4E5F6', 'route': 'Mumbai to Goa', 'date': 'Sat, 21 Dec', 'status': 'Confirmed'},
      ];
    } else if (type == 'Completed') {
      return [
        {'id': 3, 'pnr': 'G7H8I9', 'route': 'Delhi to Jaipur', 'date': 'Last Week', 'status': 'Completed'},
      ];
    } else if (type == 'Cancelled') {
      return [
        {'id': 4, 'pnr': 'J0K1L2', 'route': 'Bangalore to Chennai', 'date': '2 months ago', 'status': 'Cancelled'},
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final tickets = _getTickets();

    if (tickets.isEmpty) {
      return Center(
        child: Text('No $type tickets found.', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];

        // For this screen, we'll simplify the ticket card or use a modified UpcomingJourneyCard.
        // Since we already built a detailed card, let's create a simpler wrapper
        // to show the ticket number and status clearly on top of it.
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Ticket Status/Header ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: type == 'Upcoming' ? Colors.green : (type == 'Cancelled' ? Colors.red : Colors.blueGrey),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PNR: ${ticket['pnr']}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      ticket['status'],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
              
              // --- Ticket Details (Using the existing card structure for consistency) ---
              // Note: This relies on you having the UpcomingJourneyCard in your widgets folder.
              const UpcomingJourneyCard(isEmbedded: false),

              // --- Action Button (Relevant only for Upcoming tickets) ---
              if (type == 'Upcoming')
                _TicketActionButton(ticketId: ticket['id']!, status: ticket['status']!),
            ],
          ),
        );
      },
    );
  }
}

// --- Helper Widget for Ticket Actions ---
class _TicketActionButton extends StatelessWidget {
  final int ticketId;
  final String status;

  const _TicketActionButton({required this.ticketId, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.download, color: Colors.blue[700]),
              label: Text('Download', style: TextStyle(color: Colors.blue[700])),
            ),
            VerticalDivider(color: Colors.grey[300]),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.cancel, color: Colors.red[700]),
              label: Text('Cancel', style: TextStyle(color: Colors.red[700])),
            ),
          ],
        ),
      ),
    );
  }
}