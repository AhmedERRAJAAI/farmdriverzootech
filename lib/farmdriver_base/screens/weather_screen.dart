import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:farmdriverzootech/production/dashboard/provider/init_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class WeatherScreen extends StatefulWidget {
  static const routeName = 'weather-screen/';
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _isInit = true;
  bool isLoading = false;
  bool failedToFetch = false;
  Color bgColor = Colors.blue;
  bool? isNowDay;

  void colorSetter(bool isDay) {
    setState(() {
      bgColor = isDay ? Colors.blue.shade400 : Colors.blue.shade800;
      isNowDay = isDay;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      fetchWeather();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void fetchWeather() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<InitProvider>(context, listen: false).getWeather().then((_) {
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

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    List weatherData = Provider.of<InitProvider>(context).weather;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: bgColor,
        actions: [
          isLoading
              ? const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CupertinoActivityIndicator(
                    color: Colors.white,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    isNowDay ?? true ? Icons.light_mode : Icons.dark_mode,
                    size: 28,
                    color: Colors.white,
                  ),
                )
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            viewportFraction: 1,
            enableInfiniteScroll: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            height: deviceSize.height,
          ),
          items: [
            for (int i = 0; i < weatherData.length; i++)
              Builder(
                builder: (BuildContext context) {
                  return SiteWeather(
                    weather: weatherData[i],
                    bgColor: bgColor,
                    colorSetter: colorSetter,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

// LIST ITEM
class SiteWeather extends StatefulWidget {
  final Map weather;
  final Color bgColor;
  final Function colorSetter;
  const SiteWeather({
    super.key,
    required this.weather,
    required this.bgColor,
    required this.colorSetter,
  });

  @override
  State<SiteWeather> createState() => _SiteWeatherState();
}

class _SiteWeatherState extends State<SiteWeather> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      widget.colorSetter(widget.weather["isDay"]);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      color: widget.bgColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.weather["site"].toString(),
              style: const TextStyle(fontSize: 35, color: Colors.white),
            ),
            Text(
              "${widget.weather["currentWeather"]["dateTime"]["date"]} - ${widget.weather["currentWeather"]["dateTime"]["time"]}",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300, color: Colors.white),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.weather["currentWeather"]["currentTemp"]}°",
                  style: const TextStyle(fontSize: 37, color: Colors.white),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.thermostat,
                      color: Colors.white,
                    ),
                    Text(
                      "${widget.weather["currentWeather"]["tempMin"]}°/${widget.weather["currentWeather"]["tempMax"]}°",
                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.white),
                    )
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      MdiIcons.weatherWindy,
                      color: Colors.white,
                    ),
                    Text(
                      "${widget.weather["currentWeather"]["windSpeed"]} km/h",
                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.white),
                    )
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      MdiIcons.waterPercent,
                      color: Colors.white,
                    ),
                    Text(
                      "${widget.weather["currentWeather"]["humidity"]}%",
                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            for (int j = 0; j < widget.weather["forcast"].length; j++)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.weather["forcast"][j]["date"]["day"]}",
                            style: const TextStyle(fontSize: 17, color: Colors.white),
                          ),
                          Text(
                            "${widget.weather["forcast"][j]["date"]["date"]}",
                            style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12, color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "${widget.weather["forcast"][j]["tempMin"]}°",
                            style: const TextStyle(fontSize: 13, color: Colors.white),
                          ),
                          Text(
                            "/ ${widget.weather["forcast"][j]["tempMax"]}°",
                            style: const TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        "${widget.weather["forcast"][j]["windSpeed"]}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        "${widget.weather["forcast"][j]["humidity"]["day"]} / ${widget.weather["forcast"][j]["humidity"]["night"]}%",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.white,
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
