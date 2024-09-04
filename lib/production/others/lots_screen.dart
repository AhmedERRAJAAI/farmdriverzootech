import 'package:farmdriverzootech/production/dashboard/provider/init_provider.dart';
import 'package:farmdriverzootech/production/others/lots_apps_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LotsListScreen extends StatefulWidget {
  final int siteId;
  final String siteName;
  const LotsListScreen({super.key, required this.siteId, required this.siteName});
  static const routeName = 'zootech/lots-screen';

  @override
  State<LotsListScreen> createState() => _LotsListScreenState();
}

class _LotsListScreenState extends State<LotsListScreen> {
  bool _isInit = true;
  bool isLoading = false;
  bool failedToFetch = false;
  int getAll = 0;
  late int siteId;
  late String siteName;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    siteId = widget.siteId;
    siteName = widget.siteName;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      fetchLotBySiteId();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void fetchLotBySiteId() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<InitProvider>(context, listen: false).getLotList(siteId, getAll).then((_) {
        setState(() {
          isLoading = false;
          failedToFetch = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        failedToFetch = true;
      });
    }
  }

// Lot filter (actifs reformé)
  void _showFilterLotActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Lots filtre'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                getAll = 0;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Durations.long3,
                  backgroundColor: Colors.lightGreen,
                  content: Text("Lots actifs"),
                ),
              );
              fetchLotBySiteId();
            },
            child: const Text('Lots actifs'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                getAll = 1;
              });
              fetchLotBySiteId();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Durations.long3,
                  backgroundColor: Colors.amber,
                  content: Text("Tous lots"),
                ),
              );
            },
            child: const Text('Tous lots'),
          ),
        ],
      ),
    );
  }

// Switch sites
  void _showSiteFilterLotActionSheet(BuildContext context) {
    final List<SliderItem> sites = Provider.of<InitProvider>(context, listen: false).slidesData;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('changer de site'),
        actions: sites.map((site) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                siteId = site.siteId;
                siteName = site.siteName;
              });
              fetchLotBySiteId();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Durations.long3,
                  backgroundColor: Colors.lightGreen,
                  content: Text('Site: ${site.siteName}'),
                ),
              );
            },
            child: Text(site.siteName),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Lot> lots = Provider.of<InitProvider>(context).lots;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          siteName,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => _showSiteFilterLotActionSheet(context), icon: const Icon(Icons.location_on_outlined)),
          IconButton(
            onPressed: () => _showFilterLotActionSheet(context),
            icon: const Icon(Icons.tune_outlined),
          )
        ],
      ),
      body: isLoading
          ? const CupertinoAlertDialog(
              content: CupertinoActivityIndicator(),
            )
          : ListView.builder(
              itemCount: lots.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: ListTile(
                    tileColor: Theme.of(context).primaryColorLight.withAlpha(80),
                    splashColor: Colors.grey.shade300,
                    enabled: true,
                    leading: ClipOval(
                      child: Container(
                        width: 56,
                        height: 58,
                        color: Colors.blue,
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              lots[index].batiment,
                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text(lots[index].code),
                    subtitle: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 14,
                          color: lots[index].status == 1
                              ? Colors.green
                              : lots[index].status == 2
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                        Text(
                          lots[index].status == 1
                              ? 'Active'
                              : lots[index].status == 2
                                  ? 'en cours de réforme'
                                  : 'réformé',
                          style: TextStyle(
                            color: lots[index].status == 1
                                ? Colors.green
                                : lots[index].status == 2
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          curve: Curves.bounceIn,
                          child: LotsAppsScreen(
                            lotCode: lots[index].code,
                            lotId: lots[index].lotId,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}


// ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('You tapped on ${lots[index].code}'),
//                           ),
//                         );