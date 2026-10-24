import 'package:flutter/material.dart';

/// Comprehensive cricket match data model for Kreeda.
class MatchDetailModel {
  final String id;
  final String seriesName;
  final String matchNumber;
  final String venue;
  final String team1Code;
  final String team1Name;
  final Color team1Color;
  final String team1Score;
  final String team1Overs;
  final String team2Code;
  final String team2Name;
  final Color team2Color;
  final String team2Score;
  final String team2Overs;
  final String matchStatus;
  final String equation;
  final bool isLive;
  final List<BatsmanScoreModel> activeBatsmen;
  final BowlerScoreModel currentBowler;
  final List<BallEventModel> thisOverBalls;
  final List<InningsScorecardModel> innings;
  final List<CommentaryItemModel> commentary;
  final List<WagonWheelShotModel> wagonWheelShots;

  const MatchDetailModel({
    required this.id,
    required this.seriesName,
    required this.matchNumber,
    required this.venue,
    required this.team1Code,
    required this.team1Name,
    required this.team1Color,
    required this.team1Score,
    required this.team1Overs,
    required this.team2Code,
    required this.team2Name,
    required this.team2Color,
    required this.team2Score,
    required this.team2Overs,
    required this.matchStatus,
    required this.equation,
    required this.isLive,
    required this.activeBatsmen,
    required this.currentBowler,
    required this.thisOverBalls,
    required this.innings,
    required this.commentary,
    required this.wagonWheelShots,
  });
}

class BatsmanScoreModel {
  final String name;
  final bool isStriker;
  final int runs;
  final int balls;
  final int fours;
  final int sixes;
  final double strikeRate;
  final String dismissal;

  const BatsmanScoreModel({
    required this.name,
    required this.isStriker,
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.strikeRate,
    this.dismissal = 'not out',
  });
}

class BowlerScoreModel {
  final String name;
  final double overs;
  final int maidens;
  final int runs;
  final int wickets;
  final double economy;

  const BowlerScoreModel({
    required this.name,
    required this.overs,
    required this.maidens,
    required this.runs,
    required this.wickets,
    required this.economy,
  });
}

class BallEventModel {
  final String ballLabel;
  final int runs;
  final bool isWicket;
  final bool isBoundaryFour;
  final bool isBoundarySix;
  final bool isExtra;
  final String extraType;

  const BallEventModel({
    required this.ballLabel,
    this.runs = 0,
    this.isWicket = false,
    this.isBoundaryFour = false,
    this.isBoundarySix = false,
    this.isExtra = false,
    this.extraType = '',
  });
}

class InningsScorecardModel {
  final String teamName;
  final String score;
  final String overs;
  final List<BatsmanScoreModel> batsmen;
  final List<BowlerScoreModel> bowlers;
  final String extras;
  final String fallOfWickets;

  const InningsScorecardModel({
    required this.teamName,
    required this.score,
    required this.overs,
    required this.batsmen,
    required this.bowlers,
    required this.extras,
    required this.fallOfWickets,
  });
}

class CommentaryItemModel {
  final String over;
  final String ballResult;
  final String title;
  final String description;
  final bool isWicket;
  final bool isBoundary;

  const CommentaryItemModel({
    required this.over,
    required this.ballResult,
    required this.title,
    required this.description,
    this.isWicket = false,
    this.isBoundary = false,
  });
}

class WagonWheelShotModel {
  final double angleDegrees; // 0 to 360 degrees
  final double distanceRatio; // 0.0 to 1.0 from center
  final int runs;

  const WagonWheelShotModel({
    required this.angleDegrees,
    required this.distanceRatio,
    required this.runs,
  });
}
