import 'dart:async';
import '../models/ticket.dart';

class TicketService {
  Stream<List<Ticket>> getTickets() async* {
    // Simulating a network delay.
    await Future.delayed(Duration(seconds: 2));

    List<Ticket> tickets = [
      Ticket(
        id: '1',
        title: 'Concert',
        eventLocation: 'Stadium A',
        eventDate: DateTime.parse('2023-11-15 20:00:00'),
        price: 30.0,
      ),
      Ticket(
        id: '2',
        title: 'Soccer Match',
        eventLocation: 'Stadium B',
        eventDate: DateTime.parse('2023-11-20 18:30:00'),
        price: 50.0,
      ),
      Ticket(
        id: '3',
        title: 'Theater Play',
        eventLocation: 'Stadium C',
        eventDate: DateTime.parse('2023-12-01 19:00:00'),
        price: 40.0,
      ),
    ];

    yield tickets; // You can yield an empty list to simulate no tickets.
  }

  Future<void> purchaseTicket(String email, String ticketId, int quantity) async {
    await Future.delayed(Duration(seconds: 1));
    // Simulating a purchase process
    print('Purchased $quantity ticket(s) for $email with ID: $ticketId');
  }
}