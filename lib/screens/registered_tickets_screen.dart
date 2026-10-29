import 'package:flutter/material.dart';
import '../models/registration_ticket.dart';

class RegisteredTicketsScreen extends StatefulWidget {
  final List<RegistrationTicket> tickets;
  final Function(RegistrationTicket) onRemove;

  const RegisteredTicketsScreen({super.key, required this.tickets, required this.onRemove});

  @override
  State<RegisteredTicketsScreen> createState() => _RegisteredTicketsScreenState();
}

class _RegisteredTicketsScreenState extends State<RegisteredTicketsScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.tickets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.85, end: 1),
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) =>
                Transform.scale(scale: scale, child: child),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 94,
                  width: 94,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEAFF),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.confirmation_number_outlined,
                    color: Color(0xFF5746E8),
                    size: 44,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Tiketmu menanti',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF25233B),
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Daftar event pilihan dan tiketmu akan muncul di sini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF89879A), height: 1.4),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: widget.tickets.length,
      itemBuilder: (context, index) {
        final ticket = widget.tickets[index];
        return Dismissible(
          key: Key(ticket.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Batalkan Tiket'),
                content: const Text('Apakah Anda yakin ingin membatalkan tiket ini?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Batal'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Ya, Hapus'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            widget.onRemove(ticket);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tiket berhasil dibatalkan')),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF25233B).withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              leading: Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEAFF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.confirmation_number_outlined,
                  color: Color(0xFF5746E8),
                ),
              ),
              title: Text(
                ticket.event.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF25233B),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  '${ticket.name} · ${ticket.participantType}\n'
                  'Tanggal: ${ticket.date.toLocal().toString().split(' ')[0]}',
                ),
              ),
              isThreeLine: true,
            ),
          ),
        );
      },
    );
  }
}