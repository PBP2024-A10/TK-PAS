import 'package:ajengan_halal_mobile/manajemen_souvenir/models/souvenir_entry.dart';
import 'package:flutter/material.dart';
import 'package:ajengan_halal_mobile/manajemen_souvenir/screens/souvenir_entryform.dart';
// import 'package:ajengan_halal_mobile/manajemen_souvenir/screens/souvenir.dart';

import 'package:flutter/material.dart';
import 'package:ajengan_halal_mobile/manajemen_souvenir/models/souvenir_entry.dart';

class CardSouvenir extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(
          souvenir.fields.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image);
          },
        ),
        title: Text(souvenir.fields.name),
        subtitle: Text(souvenir.fields.description),
        trailing: isAdmin
            ? Wrap(
                spacing: 8.0,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDelete,
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
