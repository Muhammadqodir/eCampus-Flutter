import 'dart:developer';

import 'package:ecampus_ncfu/cubit/api_cubit.dart';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/models/map_marker_model.dart';
import 'package:ecampus_ncfu/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_launcher/map_launcher.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<MapMarkerModel> models = [
    MapMarkerModel(
        "Корпус №1",
        "Улица Пушкина, 1, лит. А1",
        Coords(45.043543, 41.962127),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №2",
        "Улица Пушкина, 1, лит. А",
        Coords(45.042707, 41.962336),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №3",
        "Улица Пушкина, 1, лит. Р-Р1",
        Coords(45.042323, 41.959326),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №4",
        "Улица Пушкина, 1, лит. У",
        Coords(45.042444, 41.959751),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №5",
        "Улица Дзержинского, 153",
        Coords(45.0443802, 41.9624116),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №6",
        "Площадь Ленина, 3А",
        Coords(45.042846, 41.964540),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №7",
        "Улица Маршала Жукова, 9",
        Coords(45.040540, 41.969590),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №8",
        "Улица Ленина, 133Б",
        Coords(45.041555, 41.9834067),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №9",
        "Проспект Кулакова, 2, лит. А, Б, В",
        Coords(45.041124, 41.909453),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №10",
        "Проспект Кулакова, 2, лит. Ж",
        Coords(45.040695, 41.909354),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №11",
        "Проспект Кулакова, 2, лит. Д",
        Coords(45.043263, 41.910513),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №12",
        "Проспект Кулакова, 2, лит. Е, З",
        Coords(45.041602, 41.905981),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №14",
        "Улица Индустриальная, 27",
        Coords(45.046150, 41.900652),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №15",
        "Улица Октябрьская, 184",
        Coords(45.0718755, 41.9403695),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №16",
        "Проспект Кулакова, 16/1",
        Coords(45.058646, 41.917226),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №17",
        "Проспект Кулакова, 2, лит. Х",
        Coords(45.040569, 41.910107),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №20",
        "Улица Пушкина, 1, лит. Е",
        Coords(45.043089, 41.960754),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №21",
        "Улица Пушкина, 1, лит. Е-1",
        Coords(45.043089, 41.960754),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №22",
        "Проспект Кулакова, 2",
        Coords(45.041479, 41.910600),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Корпус №23",
        "Проспект Кулакова, 2",
        Coords(45.041850, 41.910114),
        EcampusIcons.icons8_university,
        CustomColors.colorPalette[0]),
    MapMarkerModel(
        "Общежитие №1",
        "Улица Пушкина, 1, лит. Г",
        Coords(45.041707, 41.962366),
        EcampusIcons.icons8_hostel,
        CustomColors.colorPalette[1]),
    MapMarkerModel(
        "Общежитие №2",
        "Улица Михаила Морозова, 18",
        Coords(45.011685, 41.928013),
        EcampusIcons.icons8_hostel,
        CustomColors.colorPalette[1]),
    MapMarkerModel(
        "Общежитие №3",
        "Улица Доваторцев, 47",
        Coords(45.011685, 41.928013),
        EcampusIcons.icons8_hostel,
        CustomColors.colorPalette[1]),
    MapMarkerModel(
        "Общежитие №4",
        "Улица Доваторцев, 47",
        Coords(45.011685, 41.928013),
        EcampusIcons.icons8_hostel,
        CustomColors.colorPalette[1]),
    MapMarkerModel(
        "Общежитие №5",
        "Проспект Кулакова, 2/1",
        Coords(45.041427, 41.906427),
        EcampusIcons.icons8_hostel,
        CustomColors.colorPalette[1]),
    MapMarkerModel(
        "Общежитие №6",
        "Проспект Кулакова, 2/2",
        Coords(45.041965, 41.905923),
        EcampusIcons.icons8_hostel,
        CustomColors.colorPalette[1]),
    MapMarkerModel(
        "Общежитие №7",
        "Проспект Кулакова, 2/3",
        Coords(45.041380, 41.905511),
        EcampusIcons.icons8_hostel,
        CustomColors.colorPalette[1]),
    MapMarkerModel(
        "Общежитие №8",
        "Проспект Кулакова, 2/4",
        Coords(45.041258, 41.908183),
        EcampusIcons.icons8_hostel,
        CustomColors.colorPalette[1]),
    MapMarkerModel(
        "Медицинский центр СКФУ",
        "Проспект Кулакова, 2/2",
        Coords(45.041806, 41.905948),
        EcampusIcons.icons8_hospital,
        CustomColors.colorPalette[2]),
    MapMarkerModel(
        "Научная библиотека СКФУ",
        "Улица Пушкина, 1",
        Coords(45.043459, 41.960656),
        EcampusIcons.icons8_book_shelf,
        CustomColors.colorPalette[3]),
    MapMarkerModel(
        "Спорт зал СКФУ",
        "Улица Пушкина, 1, лит. В",
        Coords(45.043178, 41.960968),
        EcampusIcons.icons8_gym,
        CustomColors.colorPalette[4]),
    MapMarkerModel(
      "Спорт зал СКФУ (ЛФК)",
      "Улица Пушкина, 1, лит. С",
      Coords(45.043235, 41.961620),
      EcampusIcons.icons8_gym,
      CustomColors.colorPalette[4],
    ),
    MapMarkerModel(
      "Бассейн",
      "Улица Пушкина, 1",
      Coords(45.042068, 41.961482),
      EcampusIcons.ncfu_new,
      CustomColors.colorPalette[0],
    ),
    MapMarkerModel(
      "Технопарк",
      "Кулакова 2, Корпус № 10",
      Coords(45.040757, 41.909388),
      EcampusIcons.ncfu_new,
      CustomColors.colorPalette[0],
    ),
  ];
  double elevation = 0;

  @override
  void initState() {
    super.initState();
  }

  openMapsSheet(context, MapMarkerModel model) async {
    try {
      final coords = model.coords;
      final title = model.title;
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Открыть с помощью:",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Wrap(
                    children: <Widget>[
                      for (var map in availableMaps)
                        CrossListElement(
                          onPressed: () {
                            map.showMarker(
                              coords: coords,
                              title: title,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  map.icon,
                                  height: 30.0,
                                  width: 30.0,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  map.mapName,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
          child: const Icon(EcampusIcons.icons8_back),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: elevation,
        title: Text(
          "Карта корпусов",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels > 0 && elevation == 0) {
              setState(() {
                elevation = 0.5;
              });
            }
            if (notification.metrics.pixels <= 0 && elevation != 0) {
              setState(() {
                elevation = 0;
              });
            }
            return true;
          },
          child: ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: models
                .map(
                  (MapMarkerModel e) => CrossListElement(
                    onPressed: () {
                      context.read<ApiCubit>().state.api.sendStat(
                            "map_btn",
                            extra: e.title,
                          );
                      openMapsSheet(context, e);
                    },
                    child: e.getView(context),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
