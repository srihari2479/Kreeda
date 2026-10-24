import 'package:flutter/material.dart';

/// Tournament Points Table & Series Fixtures domain models.
class PointsTableEntryModel {
  final int rank;
  final String teamCode;
  final String teamName;
  final Color teamColor;
  final int played;
  final int won;
  final int lost;
  final int noResult;
  final double netRunRate;
  final int points;
  final bool isQualified;

  const PointsTableEntryModel({
    required this.rank,
    required this.teamCode,
    required this.teamName,
    required this.teamColor,
    required this.played,
    required this.won,
    required this.lost,
    required this.noResult,
    required this.netRunRate,
    required this.points,
    this.isQualified = false,
  });
}

class SeriesFixtureModel {
  final String id;
  final String date;
  final String time;
  final String venue;
  final String matchRound;
  final String team1Code;
  final Color team1Color;
  final String team2Code;
  final Color team2Color;
  final String statusText;
  final bool isLive;
  final bool isFinished;

  const SeriesFixtureModel({
    required this.id,
    required this.date,
    required this.time,
    required this.venue,
    required this.matchRound,
    required this.team1Code,
    required this.team1Color,
    required this.team2Code,
    required this.team2Color,
    required this.statusText,
    this.isLive = false,
    this.isFinished = false,
  });
}

class SeriesTopPerformerModel {
  final String playerName;
  final String teamCode;
  final String statLabel;
  final String statValue;
  final String awardTitle; // e.g. "ORANGE CAP", "PURPLE CAP"
  final Color badgeColor;

  const SeriesTopPerformerModel({
    required this.playerName,
    required this.teamCode,
    required this.statLabel,
    required this.statValue,
    required this.awardTitle,
    required this.badgeColor,
  });
}

/// ATBPL T10 specific domain models
class AtbplTeamModel {
  final String id;
  final String name;
  final String shortCode;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;
  final String city;
  final String captain;
  final int squadCount;
  final String starPlayer;
  final String owner;

  const AtbplTeamModel({
    required this.id,
    required this.name,
    required this.shortCode,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
    required this.city,
    required this.captain,
    required this.squadCount,
    required this.starPlayer,
    required this.owner,
  });
}

class AtbplUpcomingMatchModel {
  final String id;
  final String date;
  final String time;
  final AtbplTeamModel team1;
  final AtbplTeamModel team2;
  final String stage;
  final String venue;

  const AtbplUpcomingMatchModel({
    required this.id,
    required this.date,
    required this.time,
    required this.team1,
    required this.team2,
    required this.stage,
    required this.venue,
  });
}

class AtbplHighlightModel {
  final String id;
  final String title;
  final String duration;
  final String timeAgo;
  final String matchDescription;

  const AtbplHighlightModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.timeAgo,
    required this.matchDescription,
  });
}

class AtbplTournamentModel {
  final String id;
  final String name;
  final String stage;
  final String timeline;
  final String status;
  final Color badgeColor;
  final bool isLive;
  final int teamsCount;
  final String prizePool;
  final String venue;

  const AtbplTournamentModel({
    required this.id,
    required this.name,
    required this.stage,
    required this.timeline,
    required this.status,
    required this.badgeColor,
    this.isLive = false,
    this.teamsCount = 8,
    this.prizePool = '₹5,00,000',
    this.venue = 'Dr. Y.S. Rajasekhara Reddy ACA Stadium, Visakhapatnam',
  });
}

class AtbplLeaderboardEntry {
  final int rank;
  final String playerName;
  final String teamCode;
  final String primaryStat;
  final String secondaryStat;
  final String capType;
  final Color capColor;

  const AtbplLeaderboardEntry({
    required this.rank,
    required this.playerName,
    required this.teamCode,
    required this.primaryStat,
    required this.secondaryStat,
    required this.capType,
    required this.capColor,
  });
}
