/// Cricket Player Profile & Resume domain model.
class PlayerProfileModel {
  final String id;
  final String name;
  final String teamName;
  final String jerseyNumber;
  final String role;
  final String battingStyle;
  final String bowlingStyle;
  final int matches;
  final int totalRuns;
  final double battingAverage;
  final double strikeRate;
  final int hundreds;
  final int fifties;
  final int highestScore;
  final int wickets;
  final double bowlingAverage;
  final double economy;
  final String bestBowling;
  final List<String> recentInnings; // e.g. ["82*", "45", "112", "0", "67"]
  final List<String> awards;

  const PlayerProfileModel({
    required this.id,
    required this.name,
    required this.teamName,
    required this.jerseyNumber,
    required this.role,
    required this.battingStyle,
    required this.bowlingStyle,
    required this.matches,
    required this.totalRuns,
    required this.battingAverage,
    required this.strikeRate,
    required this.hundreds,
    required this.fifties,
    required this.highestScore,
    required this.wickets,
    required this.bowlingAverage,
    required this.economy,
    required this.bestBowling,
    required this.recentInnings,
    required this.awards,
  });
}
