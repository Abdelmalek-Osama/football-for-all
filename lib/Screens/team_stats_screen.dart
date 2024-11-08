import 'package:flutter/material.dart';

class TeamStatsScreen extends StatelessWidget {
  final Map<String, dynamic> teamData;
  final String? teamId;

  const TeamStatsScreen({
    Key? key,
    required this.teamData,
    this.teamId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final team = teamData['response'][0]['team'];
    final venue = teamData['response'][0]['venue'];
  print('Team Data: $teamData');
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Statistics'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Team Header
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Image.network(
                      team['logo'],
                      height: 80,
                      width: 80,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            team['name'],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Founded: ${team['founded']}'),
                          Text('Country: ${team['country']}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // Venue Information
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stadium Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Name: ${venue['name']}'),
                    Text('City: ${venue['city']}'),
                    Text('address: ${venue['address']}'),
                    Text('Capacity: ${venue['capacity']}'),
                    if (venue['surface'] != null)
                      Text('Surface: ${venue['surface']}'),
                        
                    
                  ],
                ),
              ),
            ),
            if (venue['image'] != null)
     Image.network(
    venue['image'],
    height: 500,
    width: double.infinity,
    fit: BoxFit.cover,
  ),
          ],
        ),
      ),
    );
  }
}
