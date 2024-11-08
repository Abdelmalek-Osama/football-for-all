import 'package:flutter/material.dart';
import '../services/ApiService.dart';
import '../Screens/team_stats_screen.dart';
import '../Screens/team_players_screen.dart';

class TeamSearchScreen extends StatefulWidget {
  @override
  _TeamSearchScreenState createState() => _TeamSearchScreenState();
}

class _TeamSearchScreenState extends State<TeamSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _teamController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  Map<String, dynamic>? teamData;
  String? selectedTeamId;

  Future<void> _searchTeam() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final result = await _apiService.searchTeam(_teamController.text);
      setState(() {
        teamData = result;
        selectedTeamId = result['response'][0]['team']['id'].toString();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching for team: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Search'),
        backgroundColor: Colors.black.withOpacity(0.6),
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/footbackground.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.darken,
            ),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _teamController,
                  decoration: InputDecoration(
                    labelText: 'Enter team name',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.5),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a team name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: Size(200, 50),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _searchTeam,
                        child: Text(
                          'Search Team',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                if (teamData != null) ...[
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: Size(150, 50),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamStatsScreen(
                              teamData: teamData!,
                              teamId: selectedTeamId,
                            ),
                          ),
                        ),
                        child: Text(
                          'View Team Stats',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: Size(150, 50),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamPlayersScreen(
                              teamData: teamData!,
                              teamId: selectedTeamId,
                            ),
                          ),
                        ),
                        child: Text(
                          'View Players',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _teamController.dispose();
    super.dispose();
  }
}
