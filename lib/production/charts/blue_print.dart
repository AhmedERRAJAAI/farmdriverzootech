// START PRODUCTION CHARTS ===========
class ProdChartData {
  final int age;
  final double? ponte;
  final double? pmo;
  final double? noppd;
  final double? blancs;
  final double? declassed;

  ProdChartData({
    required this.age,
    required this.ponte,
    required this.pmo,
    required this.noppd,
    required this.blancs,
    required this.declassed,
  });
}

class GprodChartData {
  final int age;
  final double gPonte;
  final double gPmo;
  final double gNoppd;

  GprodChartData({
    required this.age,
    required this.gPonte,
    required this.gPmo,
    required this.gNoppd,
  });
}
//
//
//
//
// START CONSOMMATION CHARTS ===========
//
//
//

class ConsoChartData {
  final int age;
  final double? aps;
  final double? eps;
  final double? apsCuml;
  final double? ratio;

  ConsoChartData({
    required this.age,
    required this.aps,
    required this.eps,
    required this.apsCuml,
    required this.ratio,
  });
}

class GconsoChartData {
  final int age;
  final double gAps;
  final double gApsCuml;
  GconsoChartData({
    required this.age,
    required this.gApsCuml,
    required this.gAps,
  });
}

//
//
//
// START CONSOMMATION CHARTS ===========
//
//
//
class MortChartData {
  final int age;
  final double? mortSem;
  final double? mortCuml;

  MortChartData({
    required this.age,
    required this.mortSem,
    required this.mortCuml,
  });
}

class GmortChartData {
  final int age;
  final double gMortSem;
  final double gMortCuml;
  final double bar1;
  final double bar2;
  final double bar3;
  GmortChartData({required this.age, required this.gMortSem, required this.gMortCuml, required this.bar1, required this.bar2, required this.bar3});
}

//
//
//
// START PV CHARTS ===========
//
//
//
class PvChartData {
  final int age;
  final double? poids;
  final double? homog;

  PvChartData({
    required this.age,
    required this.poids,
    required this.homog,
  });
}

class GpvChartData {
  final int age;
  final int? pv;

  GpvChartData({
    required this.age,
    required this.pv,
  });
}

//
//
//
// START MASSE OEUF CHARTS ===========
//
//
//
class MasseChartData {
  final int age;
  final double? massSem;
  final double? massCuml;

  MasseChartData({
    required this.age,
    required this.massSem,
    required this.massCuml,
  });
}

class GmasseChartData {
  final int age;
  final double gMassSem;
  final double gMassCuml;

  GmasseChartData({
    required this.age,
    required this.gMassSem,
    required this.gMassCuml,
  });
}
//
//
//
// START MASSE OEUF CHARTS ===========
//
//
//
class IcChartData {
  final int age;
  final double? icCuml;

  IcChartData({
    required this.age,
    required this.icCuml,
  });
}

class GicChartData {
  final int age;
  final double gIcCuml;

  GicChartData({
    required this.age,
    required this.gIcCuml,
  });
}
//
//
//
// START MASSE OEUF CHARTS ===========
//
//
//
class LightChartData {
  final int age;
  final double? icCuml;

  LightChartData({
    required this.age,
    required this.icCuml,
  });
}
