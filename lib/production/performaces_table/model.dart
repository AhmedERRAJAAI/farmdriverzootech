// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TableTitle {
  final String name;
  final String title;
  bool isActive;
  final Color color;
  final int colorIndex;
  final String fullName;
  int order;
  TableTitle({
    required this.name,
    required this.title,
    required this.isActive,
    required this.color,
    required this.colorIndex,
    required this.order,
    required this.fullName,
  });

  void toggleActiveStatus() {
    isActive = !isActive;
  }
}

class TblRow {
  final bool deletable;
  final bool? isFinal;
  final int id;
  // calendar
  final String semCivil;
  final String date;
  final int age;
// ----------------------
  // Ambiance
  final Light light;
  final Light flash;
  final dynamic intensite;
  final String? intensUnit;
  final Temperature temp;
  final dynamic humidity;
// ----------------------
  // Viabilite
  final String effectif;
  final dynamic viability;
  final Ordinary homog;
  final Ordinary pv;
  final Ordinary mortSem;
  final Ordinary mortCuml;
// ----------------------
  // Consommation
  final Ordinary altCuml;
  final Ordinary aps;
  final ReelColor ratio;
  final dynamic eauDist;
  final String? refAlt;
  final dynamic eps;
  final TwoValues altDist;
  final TwoValues deliveredAlt;
  final TwoValues deliveredAltPerHen;
  final TwoValues deliveredAltPrice;
// ----------------------
  // Production
  final WithVariation ponteNbr;
  final Ordinary ponteCent;
  final Ordinary pmo;
  final Ordinary noppp;
  final Ordinary nopppSem;
  final Ordinary noppd;
  final Ordinary noppdSem;
  final TwoValues declasse;
// ----------------------
  // Masse d'oeuf
  final Ordinary massOeufSemPP;
  final Ordinary massOeufPP;
  final Ordinary massOeufSemPD;
  final Ordinary massOeufPD;
// ----------------------
  // Indices de conversion
  final Ordinary altOeuf;
  final Ordinary altOeufCuml;
  final Ordinary icCuml;

  TblRow({
    this.humidity,
    required this.deletable,
    required this.isFinal,
    required this.id,
    required this.semCivil,
    required this.date,
    required this.age,
    required this.light,
    required this.flash,
    this.intensite,
    this.intensUnit,
    required this.temp,
    required this.effectif,
    required this.viability,
    required this.homog,
    required this.pv,
    required this.mortSem,
    required this.mortCuml,
    required this.altCuml,
    required this.aps,
    required this.ratio,
    this.eauDist,
    this.refAlt,
    this.eps,
    required this.altDist,
    required this.deliveredAlt,
    required this.deliveredAltPerHen,
    required this.deliveredAltPrice,
    required this.ponteNbr,
    required this.ponteCent,
    required this.pmo,
    required this.noppp,
    required this.nopppSem,
    required this.noppd,
    required this.noppdSem,
    required this.declasse,
    required this.massOeufSemPP,
    required this.massOeufPP,
    required this.massOeufSemPD,
    required this.massOeufPD,
    required this.altOeuf,
    required this.altOeufCuml,
    required this.icCuml,
  });
}

class Temperature {
  final dynamic min;
  final dynamic max;
  Temperature({
    required this.min,
    required this.max,
  });
}

class Light {
  final dynamic on;
  final dynamic off;
  final dynamic durration;
  final bool isFlash;

  Light({
    this.on,
    this.off,
    this.durration,
    required this.isFlash,
  });
}

class Ordinary {
  final String? reel;
  final String? guide;
  final String? ecart;
  final String? color;

  Ordinary({
    this.reel,
    this.guide,
    this.ecart,
    this.color,
  });

  // Named constructor for automatic parsing
  factory Ordinary.fromDynamic({
    dynamic reel,
    dynamic guide,
    dynamic ecart,
    dynamic color,
  }) {
    return Ordinary(
      reel: _parseToString(reel),
      guide: _parseToString(guide),
      ecart: _parseToString(ecart),
      color: _parseToString(color),
    );
  }

  // Helper function to handle parsing
  static String? _parseToString(dynamic data) {
    try {
      return data?.toString();
    } catch (e) {
      return null;
    }
  }
}

class ReelColor {
  final dynamic reel;
  final dynamic color;

  ReelColor({
    this.reel,
    this.color,
  });
}

class WithVariation {
  final dynamic reel;
  final dynamic variat;
  final dynamic color;

  WithVariation({
    this.reel,
    this.variat,
    this.color,
  });
}

class TwoValues {
  final dynamic reel;
  final dynamic variat;
  final bool? hasColor;
  TwoValues({
    this.hasColor,
    this.reel,
    this.variat,
  });
}
