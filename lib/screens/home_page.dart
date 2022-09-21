import 'package:flutter/material.dart';
import '../helper/covid_data_api_helper.dart';
import '../modals/modals.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var appColor = const Color(0xff35A4A4);
  var appColor2 = const Color(0xff3F3D56);
  dynamic selectedCountry;
  List country = [];
  dynamic i;
  dynamic titleStyle;
  dynamic containerDecoration;
  var boxTextStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.w500);

  @override
  void initState() {
    super.initState();
    titleStyle = TextStyle(
      color: appColor2,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    );
    containerDecoration = BoxDecoration(
      color: appColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: appColor2.withOpacity(0.2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.search),
          )
        ],
        centerTitle: true,
        title: const Text("Covid Cases Trekker"),
      ),
      body: FutureBuilder(
        future: CovidApi.covidAPI.fetchCovidDataAPI(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error : ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<CovidData> data = snapshot.data as List<CovidData>;
            country = data.map((e) => e.name).toList();

            return Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Image.asset(
                        "assets/images/corona_details.png",
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(width: 10),
                        Icon(Icons.location_on, size: 40, color: appColor),
                        const Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.70,
                          child: DropdownButtonFormField(
                            hint: const Text("Please Select Country."),
                            style: TextStyle(
                              color: appColor2,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            value: selectedCountry,
                            onChanged: (val) {
                              setState(() {
                                selectedCountry = val;
                                i = country.indexOf(val);
                              });
                            },
                            items: country.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.50,
                                  child: Text(e),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    (i != null)
                        ? Column(
                            children: [
                              const SizedBox(height: 20),
                              Text("Today", style: titleStyle),
                              const SizedBox(height: 10),
                              Container(
                                decoration: containerDecoration,
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Text(
                                      "Confirmed : ${data[i].todayConfirmed}",
                                      style: boxTextStyle,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Deaths : ${data[i].todayDeaths}",
                                      style: boxTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text("Over All Cases", style: titleStyle),
                              const SizedBox(height: 10),
                              Container(
                                decoration: containerDecoration,
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Text(
                                      "Confirmed : ${data[i].totalConfirmed}",
                                      style: boxTextStyle,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Deaths : ${data[i].totalDeaths}",
                                      style: boxTextStyle,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Recovered : ${data[i].totalRecovered}",
                                      style: boxTextStyle,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Critical : ${data[i].totalCritical}",
                                      style: boxTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              (data[i].recoveryRate != null)
                                  ? Container(
                                      decoration: containerDecoration,
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Recovery Rate : ${data[i].recoveryRate}",
                                            style: boxTextStyle,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(height: 40),
                            ],
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 160),
                              Icon(
                                Icons.coronavirus_outlined,
                                size: 60,
                                color: appColor.withOpacity(0.3),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
