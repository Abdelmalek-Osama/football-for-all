import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final String name;
  final String position;
  final String? photoUrl;
  final VoidCallback onTap;

  const PlayerCard({
    Key? key,
    required this.name,
    required this.position,
    this.photoUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              if (photoUrl != null)
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(photoUrl!),
                  onBackgroundImageError: (e, s) => Icon(Icons.person),
                ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(position),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
