import 'package:flutter/material.dart';

class Contants {
  static const List eggColors = [
    70,
    80,
    90,
    100,
    110
  ];
}

class TableTitles {
  static List<Color> colors = [
    Colors.blueGrey.shade100,
    Colors.blue.shade100,
    Colors.cyan.shade100,
    Colors.green.shade100,
    Colors.brown.shade100,
    Colors.teal.shade100,
    Colors.indigo.shade100,
  ];
  static List<Color> supColors = [
    Colors.blueGrey,
    Colors.blue,
    Colors.cyan,
    Colors.green,
    Colors.brown,
    Colors.teal,
    Colors.indigo,
  ];

  static const List<Map> tableTitles = [
    {
      "name": "age",
      "title": "Age",
      "color": 0,
      "order": 1,
    },
    {
      "name": "semCvl",
      "title": "Sem. civile",
      "color": 0,
      "order": 2,
      'fullName': "Semaine civile"
    },
    {
      "name": "date",
      "title": "Date",
      "color": 0,
      "order": 3,
    },

    // Ambiance
    {
      "name": "lum",
      "title": "Lumiére",
      "color": 1,
      "order": 4,
    },
    {
      "name": "flsh",
      "title": "Flash",
      "color": 1,
      "order": 5,
    },
    {
      "name": "intens",
      "title": "intensité",
      "color": 1,
      "order": 6,
    },
    {
      "name": "temp",
      "title": "Temp °C",
      "color": 1,
      "order": 7,
    },
    {
      "name": "humidity",
      "title": "Humidité",
      "color": 1,
      "order": 7,
    },
    // // Viabilité
    {
      "name": "efp",
      "title": "Effectif présent",
      "color": 2,
      "order": 8,
    },
    {
      "name": "homog",
      "title": "Homogénéité (%",
      "color": 2,
      "order": 8,
    },
    {
      "name": "pv",
      "title": "P.corporel (g)",
      "color": 2,
      "order": 9,
    },
    {
      "name": "vblty",
      "title": "Viabilité(%)",
      "color": 2,
      "order": 10,
    },
    {
      "name": "mortSem",
      "title": "Mort (%)",
      "color": 2,
      "order": 11,
    },
    {
      "name": "mortCuml",
      "title": "∑ mort (%)",
      "color": 2,
      "order": 12,
    },
    // // Consommation
    // Start ====
    {
      "name": "altLiv",
      "title": "Alt reçu (t)",
      "color": 3,
      "order": 13,
    },
    {
      "name": "refAlt",
      "title": "Réf.Alt",
      "color": 3,
      "order": 13,
    },
    {
      "name": "altPrice",
      "title": "Montant (ttc/MAD)",
      "color": 3,
      "order": 13,
    },
    {
      "name": "apsAltLiv",
      "title": "∑ APS/ Alt reçu",
      "color": 3,
      "order": 13,
    },
    // end aliment livree ===
    {
      "name": "eau",
      "title": "Eau (m³)",
      "color": 3,
      "order": 13,
    },
    {
      "name": "alt",
      "title": "Aliment (t)",
      "color": 3,
      "order": 14,
    },
    {
      "name": "eps",
      "title": "EPS(ml)",
      "color": 3,
      "order": 15,
    },
    {
      "name": "aps",
      "title": "APS(g)",
      "color": 3,
      "order": 16,
    },
    {
      "name": "apsCuml",
      "title": "∑ APS(kg)",
      "color": 3,
      "order": 17,
    },
    {
      "name": "rtio",
      "title": "Ratio E/A",
      "color": 3,
      "order": 18,
    },

    // // Production
    {
      "name": "prod",
      "title": "Ponte",
      "color": 4,
      "order": 20,
    },
    {
      "name": "ponte",
      "title": "Ponte (%)",
      "color": 4,
      "order": 21,
    },
    {
      "name": "pmo",
      "title": "PMO (g)",
      "color": 4,
      "order": 22,
    },
    {
      "name": "noppp",
      "title": "NOPPP",
      "color": 4,
      "order": 23,
    },
    {
      "name": "noppp_cml",
      "title": "∑ NOPPP",
      "color": 4,
      "order": 24,
    },
    {
      "name": "noppd",
      "title": "NOPPD",
      "color": 4,
      "order": 25,
    },
    {
      "name": "noppd_cml",
      "title": "∑ NOPPD",
      "color": 4,
      "order": 26,
    },
    {
      "name": "declass",
      "title": "Déclasse",
      "color": 4,
      "order": 27,
    },
    // // Mass oeuf
    {
      "name": "massSemPP",
      "title": "MOPPP/sem (g)",
      "color": 5,
      "order": 28,
    },
    {
      "name": "massCumlPP",
      "title": "∑ MOPPP (kg)",
      "color": 5,
      "order": 29,
    },
    {
      "name": "massSemPD",
      "title": "MOPPD/sem (g)",
      "color": 5,
      "order": 30,
    },
    {
      "name": "massCumlPD",
      "title": "∑ MOPPD (kg)",
      "color": 5,
      "order": 31,
    },
    // // Indices de conversion
    {
      "name": "apo",
      "title": "APO (g)",
      "color": 6,
      "order": 32,
    },
    {
      "name": "apoCuml",
      "title": "∑ APO (g)",
      "color": 6,
      "order": 33,
    },
    {
      "name": "ic",
      "title": "Indice Conv",
      "color": 6,
      "order": 34,
    },
  ];

// PRODUCTION STATUS ------------------------------------------
  static const List<Map> prodStatusTb = [
    {
      "title": "Site",
      "name": "site",
      "color": 0
    },
    {
      "title": "Bâtiment",
      "name": "bat",
      "color": 0
    },
    {
      "title": "Age",
      "name": "age",
      "color": 1
    },
    {
      "title": "Lumiére",
      "name": "light",
      "color": 2
    },
    {
      "title": "Flash",
      "name": "flash",
      "color": 2
    },
    {
      "title": "Intens",
      "name": "intens",
      "color": 2
    },
    {
      "title": "Temp. Min",
      "name": "temp_min",
      "color": 2
    },
    {
      "title": "Temp. Max",
      "name": "temp_max",
      "color": 2
    },
    {
      "title": "Effectif",
      "name": "effectif",
      "color": 3
    },
    {
      "title": "P. corp",
      "name": "pv",
      "color": 3
    },
    {
      "title": "Homog",
      "name": "homog",
      "color": 3
    },
    {
      "title": "Mort",
      "name": "mort",
      "color": 3
    },
    {
      "title": "Eau (L)",
      "name": "eau",
      "color": 4
    },
    {
      "title": "Alt (kg)",
      "name": "alt",
      "color": 4
    },
    {
      "title": "APS",
      "name": "aps",
      "color": 4
    },
    {
      "title": "Ratio",
      "name": "ratio",
      "color": 4
    },
    {
      "title": "Ponte",
      "name": "ponte",
      "color": 5
    },
    {
      "title": "% Ponte",
      "name": "ponte_cent",
      "color": 5
    },
    {
      "title": "PMO",
      "name": "pmo",
      "color": 5
    },
    // MASSE
    {
      "title": "Jour(g)",
      "name": "mass_jour",
      "color": 6
    },
    {
      "title": "Cuml(kg)",
      "name": "mass_cuml",
      "color": 6
    },
    // APO
    {
      "title": "Jour(g)",
      "name": "apo_jour",
      "color": 7
    },
    {
      "title": "Cuml(kg)",
      "name": "apo_cuml",
      "color": 7
    },
    // IC
    {
      "title": "Jour(g)",
      "name": "ic_jour",
      "color": 8
    },
    {
      "title": "Cuml(kg)",
      "name": "ic_cuml",
      "color": 8
    },
  ];
}

const List<String> syntheseParams = [
  "Paramètre/Site",
  "Bâtiment",
  "Lot",
  "Date",
  "Âge (sem)",
  "Souche",
  "Effectif pésent",
  "Performances",
  "Mortalité Sem(%)",
  "Mortalité cuml. (%)",
  "Ponte (%)",
  "Cons. Alt. (g/j)",
  "Nbr. Oeufs/PD",
  "Poids vif (g)",
  "Homogénéité",
  "PMO (g)",
  "Alt/PD cuml",
  "Alt/Oeuf cuml",
  "Masse d'Oeufs heb",
  "Masse d'Oeufs/PD",
  "Indice de conversion",
  "Eau (ml) | Ratio(E/A)",
  "Lumiére | Flash",
  "Référence d'aliment",
  "Qualité de coquille",
  "Coloration d'oeuf",
  "Observation",
];
