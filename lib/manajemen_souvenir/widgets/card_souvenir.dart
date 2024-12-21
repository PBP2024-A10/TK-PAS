import 'package:flutter/material.dart';
import 'package:ajengan_halal_mobile/manajemen_souvenir/models/souvenir_entry.dart';

class CardSouvenir extends StatefulWidget {
  final SouvenirEntry souvenir;
  final bool isAdmin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CardSouvenir({
    Key? key,
    required this.souvenir,
    this.isAdmin = false,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  _CardSouvenirState createState() => _CardSouvenirState();
}

class _CardSouvenirState extends State<CardSouvenir> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Color(0xFF462009)),
      ),
      elevation: 4.0,
      shadowColor: Colors.black.withOpacity(0.25),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                widget.souvenir.fields.image,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.white,
                    child: const Icon(Icons.image, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(height: 8.0),

            // Nama
            Text(
              widget.souvenir.fields.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF462009),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8.0),

            // Deskripsi
            Text(
              widget.souvenir.fields.description,
              textAlign: TextAlign.center,
              maxLines: isExpanded ? null : 3, // Jika isExpanded, tampilkan semua
              overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Color(0xFF462009),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16.0),

            // Tombol Read More/Less + Edit + Delete
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded; // Toggle antara Read More dan Read Less
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF462009),
                  ),
                  child: Text(
                    isExpanded ? "Read Less" : "Read More",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      color: Color(0xFF462009),
                    ),
                  ),
                ),
                if (widget.isAdmin)
                  Row(
                    children: [
                      // Tombol Edit
                      OutlinedButton(
                        onPressed: widget.onEdit,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF462009)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Color(0xFF462009),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),

                      // Tombol Delete
                      OutlinedButton(
                        onPressed: widget.onDelete,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFD10F0F)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Color(0xFFD10F0F),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
