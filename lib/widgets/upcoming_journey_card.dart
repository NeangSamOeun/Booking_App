// widgets/upcoming_journey_card.dart (FIXED)

import 'package:flutter/material.dart';

class UpcomingJourneyCard extends StatelessWidget {
  final bool isEmbedded; 
  const UpcomingJourneyCard({super.key, this.isEmbedded = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, 
      elevation: 0, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('PNR/Ticket No: 13392789', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const Divider(height: 16),
            
            // --- JOURNEY DETAILS ROW (Source of the original error) ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Icons and Vertical Line (Fixed small width)
                Column(
                  children: [
                    Icon(Icons.directions_bus, color: Colors.red[400], size: 20),
                    Container(width: 2, height: 50, color: Colors.grey.shade300),
                    const Icon(Icons.location_on, color: Colors.black, size: 20),
                  ],
                ),
                const SizedBox(width: 10),
                
                // 2. Location and Time Details (Uses Expanded to fill available space)
                // We use Expanded here to tell the Column to take up remaining space.
                const Expanded( 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DetailRow(
                        type: 'Boarding Point',
                        time: '8:05 PM', 
                        location: 'New Sangavi - Pick up near Sangavi Phata...',
                      ),
                      SizedBox(height: 15),
                      _DetailRow(
                        type: 'Drop Point',
                        time: '6:30 AM', 
                        location: 'DeepNagar DeepNagar',
                      ),
                    ],
                  ),
                ),
                
                // 3. City and Date (Right Section - Fixed small width)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _CityDate(city: 'PUNE', time: '8:05 PM', date: 'Sun, 13 Jan'),
                    const SizedBox(height: 15),
                    const Text('TO', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    _CityDate(city: 'BHUSAWAL', time: '6:30 AM', date: 'Mon, 14 Jan', isDrop: true),
                  ],
                ),
              ],
            ),
            
            const Divider(height: 20),
            
            // --- BUS TYPE FOOTER (Potential secondary error source) ---
            Row(
              children: [
                Icon(Icons.directions_bus_filled, color: Colors.grey.shade500, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Sangitam Travels',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800], fontSize: 14),
                ),
                const SizedBox(width: 8),
                
                // FIX: Wrap the long configuration text in Expanded
                Expanded(
                  child: Text(
                    '2X1 (30) A/C SLEEPER',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                    overflow: TextOverflow.ellipsis, // Add ellipsis just in case
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

// --- HELPER WIDGETS ---

class _DetailRow extends StatelessWidget {
  final String type;
  final String time;
  final String location;

  const _DetailRow({required this.type, required this.time, required this.location});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        // This is the ROW that was causing the overflow. It is now fixed.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time text takes up its natural width
            Text('$time, ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), 
            
            // FIX: The location Text is wrapped in Expanded to take the remaining space.
            Expanded( 
              child: Text(
                location,
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.grey),
                overflow: TextOverflow.ellipsis, 
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CityDate extends StatelessWidget {
  final String city;
  final String time;
  final String date;
  final bool isDrop;

  const _CityDate({required this.city, required this.time, required this.date, this.isDrop = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(city, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(time, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDrop ? Colors.black : Colors.red[400])),
        Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}