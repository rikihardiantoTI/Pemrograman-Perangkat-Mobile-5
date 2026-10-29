import 'package:flutter/material.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';

class EventRegistrationScreen extends StatefulWidget {
  final EventItem event;
  
  const EventRegistrationScreen({super.key, required this.event});

  @override
  State<EventRegistrationScreen> createState() => _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _waController = TextEditingController();
  
  String _participantType = 'Mahasiswa';
  DateTime? _selectedDate;
  bool _needsKit = false;
  bool _agreesToRules = false;
  double _donation = 0;
  bool _isLoading = false;

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan pilih tanggal kehadiran')),
        );
        return;
      }
      if (!_agreesToRules) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anda harus menyetujui tata tertib')),
        );
        return;
      }

      setState(() => _isLoading = true);
      
      // Simulasi loading
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      
      final ticket = RegistrationTicket(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        event: widget.event,
        name: _nameController.text,
        nim: _nimController.text,
        email: _emailController.text,
        whatsapp: _waController.text,
        participantType: _participantType,
        date: _selectedDate!,
        hasSeminarKit: _needsKit,
        donation: _donation,
      );

      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pendaftaran Berhasil!')),
      );
      Navigator.pop(context, ticket);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _waController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pendaftaran')),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _isLoading
            ? const Center(
                key: ValueKey('loading'),
                child: CircularProgressIndicator(),
              )
            : Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SizedBox(
                    height: 190,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: 'event-${widget.event.id}',
                          child: Image.network(
                            widget.event.posterUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const ColoredBox(
                              color: Color(0xFFECEAF8),
                              child: Icon(Icons.image_not_supported_outlined),
                            ),
                          ),
                        ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Color(0xD9000000)],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 18,
                          right: 18,
                          bottom: 18,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.event.category.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.event.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Lengkapi data diri',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF25233B),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Isi informasi berikut untuk mengamankan tempatmu.',
                  style: TextStyle(color: Color(0xFF89879A)),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 13),
                TextFormField(
                  controller: _nimController,
                  decoration: const InputDecoration(
                    labelText: 'NIM',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'NIM tidak boleh kosong' : null,
                ),
                const SizedBox(height: 13),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      !value!.contains('@') ? 'Email tidak valid' : null,
                ),
                const SizedBox(height: 13),
                TextFormField(
                  controller: _waController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor WhatsApp',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? 'Nomor WA tidak boleh kosong' : null,
                ),
                const SizedBox(height: 13),
                DropdownButtonFormField<String>(
                  value: _participantType,
                  decoration: const InputDecoration(
                    labelText: 'Tipe Peserta',
                    prefixIcon: Icon(Icons.people_outline),
                  ),
                  items: ['Mahasiswa', 'Umum', 'Dosen'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) =>
                      setState(() => _participantType = val!),
                ),
                const SizedBox(height: 13),
                ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xFFE9E8F1)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    _selectedDate == null
                        ? 'Pilih Tanggal Kehadiran'
                        : 'Tanggal: ${_selectedDate!.toLocal()}'.split(' ')[0],
                  ),
                  trailing: const Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xFF5746E8),
                  ),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: const Text('Paket Seminar Kit (+Rp 50.000)'),
                  value: _needsKit,
                  onChanged: (val) => setState(() => _needsKit = val),
                ),
                const SizedBox(height: 8),
                Text(
                  'Donasi Sukarela: Rp ${_donation.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Slider(
                  value: _donation,
                  min: 0,
                  max: 100000,
                  divisions: 10,
                  label: _donation.round().toString(),
                  onChanged: (val) => setState(() => _donation = val),
                ),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: const Text('Saya menyetujui tata tertib acara'),
                  value: _agreesToRules,
                  onChanged: (val) =>
                      setState(() => _agreesToRules = val!),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: _submitForm,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Daftar Sekarang'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF5746E8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}