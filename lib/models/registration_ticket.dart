import 'event_item.dart';

class RegistrationTicket {
  final String id;
  final EventItem event;
  final String name;
  final String nim;
  final String email;
  final String whatsapp;
  final String participantType;
  final DateTime date;
  final bool hasSeminarKit;
  final double donation;

  RegistrationTicket({
    required this.id,
    required this.event,
    required this.name,
    required this.nim,
    required this.email,
    required this.whatsapp,
    required this.participantType,
    required this.date,
    required this.hasSeminarKit,
    required this.donation,
  });
}