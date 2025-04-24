class Ticket {
  final String id;
  final String title; // Event name
  final String eventLocation; // Location of the event
  final DateTime eventDate; // Date of the event
  final double price; // Ticket price

  Ticket({
    required this.id,
    required this.title,
    required this.eventLocation,
    required this.eventDate,
    required this.price,
  });

  // Factory method to create a Ticket from JSON data
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      title: json['title'],
      eventLocation: json['eventLocation'],
      eventDate: DateTime.parse(json['eventDate']),
      price: json['price'].toDouble(),
    );
  }
}