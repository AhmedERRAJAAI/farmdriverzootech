import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:farmdriverzootech/core/provider/theme_provider.dart';
import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:farmdriverzootech/production/dashboard/provider/init_provider.dart';
import 'package:farmdriverzootech/production/dashboard/widgets/sub-wigets/site_slider_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
// import '../providers/init_provider.dart';
// import '../../providers/theme_provider.dart';
// import 'package:provider/provider.dart';
// import '../reusables/alert_dialog.dart';

class SitesDashSlider extends StatefulWidget {
  const SitesDashSlider({super.key});

  @override
  State<SitesDashSlider> createState() => SitesDashSliderState();
}

class SitesDashSliderState extends State<SitesDashSlider> {
  bool _isInit = true;
  bool isLoading = false;
  bool failedToFetch = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  void refreshSlider() async {
    fetchSliderData(context);
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
      final themeInst = Provider.of<ThemeProvider>(context, listen: false);
      themeInst.tryGetTheme();
      await Provider.of<InitProvider>(context, listen: false).fetchSliderData().then((_) {
        setState(() {
          isLoading = false;
          failedToFetch = false;
        });
      });
    } catch (e) {
      int? statusCode = int.tryParse(e.toString().replaceAll('Exception:', '').trim());
      if (statusCode == 401) {
        try {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.tryAutoLogin().then((_) {
            fetchSliderData(context);
          });
        } catch (e) {
          Navigator.of(context).pushNamed("auth-screen/");
        }
      }
      setState(() {
        isLoading = false;
        failedToFetch = true;
        AlertsDialog.doUreallyWant(context, "L'opération a échoué", "vérifiez votre connexion Internet et réessayez", "réessayer", true, fetchSliderData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<SliderItem> sliderData = Provider.of<InitProvider>(context, listen: false).slidesData;
    return isLoading
        ? const SizedBox(
            height: 136,
            child: SizedBox(
              height: 60,
              width: 60,
              child: CupertinoActivityIndicator(),
            ),
          )
        : CarouselSlider(
            options: CarouselOptions(
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              viewportFraction: 0.93,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              height: 136,
            ),
            items: sliderData.map((slide) {
              return Builder(
                builder: (BuildContext context) {
                  return SiteItemSlider(
                    refresh: fetchSliderData,
                    slide: slide,
                  );
                },
              );
            }).toList(),
          );
  }
}
