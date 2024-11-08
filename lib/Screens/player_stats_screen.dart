import 'package:flutter/material.dart';

class PlayerStatsScreen extends StatelessWidget {
  final Map<String, dynamic> playerData;
  final String? teamId;

  const PlayerStatsScreen({Key? key, required this.playerData, this.teamId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (playerData['response'] == null || 
        playerData['response'].isEmpty ||
        playerData['results'] == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Player Statistics'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red,
              ),
              SizedBox(height: 16),
              Text(
                'No player data available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please try searching again',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final player = playerData['response'][0]['player'];
    final statistics = playerData['response'][0]['statistics'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Player Statistics'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player Profile Header
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(player['photo']),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player['name'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Age: ${player['age']}'),
                        Text('Nationality: ${player['nationality']}'),
                        Text('Height: ${player['height']}'),
                        Text('Weight: ${player['weight']}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Statistics Tabs
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Current Season'),
                      Tab(text: 'Career Stats'),
                    ],
                  ),
                  SizedBox(
                    height: 500, // Adjust height as needed
                    child: TabBarView(
                      children: [
                        // Current Season Stats
                        _buildSeasonStats(statistics[0]),
                        
                        // Career Stats
                        _buildCareerStats(statistics),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonStats(Map<String, dynamic> stats) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatSection('Team Information', [
            StatItem('Team', stats['team']['name']),
            StatItem('League', stats['league']['name']),
            StatItem('Season', stats['league']['season'].toString()),
              StatItem('position', stats['games']['position'].toString()),
          ]),
          
          _buildStatSection('Appearances', [
            StatItem('Games Played', stats['games']['appearences'].toString()),
            StatItem('Minutes Played', stats['games']['minutes'].toString()),
            StatItem('Lineups', stats['games']['lineups'].toString()),
            
          ]),

          _buildStatSection('Goals & Assists', [
            StatItem('Goals', stats['goals']['total'].toString()),
            StatItem('Assists', stats['goals']['assists'].toString()),
            StatItem('Penalties Scored', stats['penalty']['scored'].toString()),
          ]),

          _buildStatSection('Shots', [
            StatItem('Total Shots', stats['shots']['total'].toString()),
            StatItem('Shots on Target', stats['shots']['on'].toString()),
          ]),

          _buildStatSection('Passes', [
            StatItem('Total Passes', stats['passes']['total'].toString()),
            StatItem('Key Passes', stats['passes']['key'].toString()),
          ]),
        ],
      ),
    );
  }

  Widget _buildCareerStats(List<dynamic> allStats) {
    int totalGoals = 0;
    int totalAssists = 0;
    int totalAppearances = 0;

    for (var stats in allStats) {
      totalGoals += (stats['goals']['total'] ?? 0) as int;
      totalAssists += (stats['goals']['assists'] ?? 0) as int;
      totalAppearances += (stats['games']['appearences'] ?? 0) as int;
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatSection('Career Overview', [
            StatItem('Total Goals', totalGoals.toString()),
            StatItem('Total Assists', totalAssists.toString()),
            StatItem('Total Appearances', totalAppearances.toString()),
          ]),
          
          // Add more career statistics as needed
        ],
      ),
    );
  }

  Widget _buildStatSection(String title, List<StatItem> items) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ...items.map((item) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.label),
                  Text(
                    item.value,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class StatItem {
  final String label;
  final String value;

  StatItem(this.label, this.value);
}
