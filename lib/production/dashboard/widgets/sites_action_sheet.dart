import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:farmdriverzootech/production/dashboard/provider/init_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SitesPicker extends StatefulWidget {
  final Function getSites;
  const SitesPicker({super.key, required this.getSites});

  @override
  State<SitesPicker> createState() => _SitesPickerState();
}

class _SitesPickerState extends State<SitesPicker> {
  bool _isInit = true;
  bool isLoading = false;
  bool failedToFetch = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      fetchSliderData(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void fetchSliderData(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<InitProvider>(context, listen: false).fetchSliderData().then((_) {
        setState(() {
          isLoading = false;
          failedToFetch = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        failedToFetch = true;
        AlertsDialog.doUreallyWant(context, "L'opération a échoué", "vérifiez votre connexion Internet et réessayez", "réessayer", true, fetchSliderData);
      });
    }
  }

  List<int> sitesIds = [];
  @override
  Widget build(BuildContext context) {
    final List<SliderItem> sliderData = Provider.of<InitProvider>(context, listen: false).slidesData;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Sélectionner les sites à télécharger",
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              ),
              const SizedBox(height: 20),
              Column(
                  children: sliderData.map((site) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (sitesIds.contains(site.siteId)) {
                          setState(() {
                            sitesIds.remove(site.siteId);
                          });
                        } else {
                          setState(() {
                            sitesIds.add(site.siteId);
                          });
                        }
                        widget.getSites(sitesIds);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(site.siteName),
                          FittedBox(
                            child: CupertinoCheckbox(
                                tristate: false,
                                value: sitesIds.contains(site.siteId),
                                onChanged: (val) {
                                  if (val ?? false) {
                                    setState(() {
                                      sitesIds.add(site.siteId);
                                    });
                                  } else {
                                    setState(() {
                                      sitesIds.remove(site.siteId);
                                    });
                                  }
                                  widget.getSites(sitesIds);
                                }),
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              }).toList()),
            ],
          ),
        ),
      ),
    );
  }
}
