import 'package:flutter/material.dart';
import '../services/ApiService.dart';
import '../Custom-widgets/player_card.dart';
import '../Screens/player_stats_screen.dart';

class TeamPlayersScreen extends StatefulWidget {
  final Map<String, dynamic> teamData;
  final String? teamId;

  const TeamPlayersScreen({
    Key? key,
    required this.teamData,
    this.teamId,
  }) : super(key: key);

  @override
  _TeamPlayersScreenState createState() => _TeamPlayersScreenState();
}

class _TeamPlayersScreenState extends State<TeamPlayersScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<dynamic> players = [];
  late final String teamId;

  @override
  void initState() {
    super.initState();
    teamId = widget.teamId ??
        widget.teamData['response'][0]['team']['id'].toString();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    try {
      final result = await _apiService.getTeamPlayers(
        widget.teamData['response'][0]['team']['id'].toString(),
      );
      setState(() {
        players = result['response'][0]['players'];
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading players: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Players'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return PlayerCard(
                  name: player['name'],
                  position: player['position'],
                  photoUrl: player['photo'],
                  onTap: () async {
                    try {
                    
                      final cleanName = player['name'];
                  

                      final playerStats = await _apiService.searchPlayer(
                        playerName: cleanName,
                        teamId: teamId,
                      );

                      if (!mounted) return;

                      if (playerStats['response'] == null ||
                          playerStats['response'].isEmpty ||
                          playerStats['results'] == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('No statistics found for this player'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayerStatsScreen(
                            playerData: playerStats,
                            teamId: teamId,
                          ),
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error loading player stats: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
