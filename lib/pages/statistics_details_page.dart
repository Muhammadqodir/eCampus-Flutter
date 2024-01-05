import 'package:ecampus_ncfu/cubit/api_cubit.dart';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/ecampus_master/responses.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/models/subject_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsDetailsPage extends StatefulWidget {
  const StatisticsDetailsPage({
    Key? key,
    required this.context,
    required this.title,
    required this.tabs,
  }) : super(key: key);

  final BuildContext context;
  final String title;
  final List<StatisticsDetailsTab> tabs;

  @override
  State<StatisticsDetailsPage> createState() => _StatisticsDetailsPageState();
}

class _StatisticsDetailsPageState extends State<StatisticsDetailsPage> {
  _StatisticsDetailsPageState();
  double elevation = 0;
  bool loading = true;
  late eCampus ecampus;
  List<LessonItemsResponse> models = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabs.length,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0.5,
            leading: CupertinoButton(
              onPressed: (() {
                // To send the click data to the server
                context.read<ApiCubit>().state.api.sendStat(
                      "Pushed_back_btn",
                      extra: "Statistics details page",
                    );
                Navigator.pop(context);
              }),
              child: const Icon(EcampusIcons.icons8_back),
            ),
            title: Text(
              widget.title,
              overflow: TextOverflow.fade,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            bottom: TabBar(
              onTap: (v) {
                // To send the click data to the server
                context.read<ApiCubit>().state.api.sendStat(
                      "Pushed_tab",
                      extra: "Statistic details page",
                    );
              },
              tabs: widget.tabs
                  .map(
                    (e) => Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            e.title,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: e.badgeColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              e.count.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                  .toList(),
            )),
        body: TabBarView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: widget.tabs
              .map(
                (e) => e.models.isNotEmpty
                    ? ListView(
                        children: e.models
                            .map(
                              (e) => CrossListElement(
                                onPressed: () {
                                  // To send the click data to the server
                                  context.read<ApiCubit>().state.api.sendStat(
                                        "Pushed_cross_list_elemenit",
                                        extra: "Statistics details page",
                                      );
                                },
                                child: e.getView(context),
                              ),
                            )
                            .toList(),
                      )
                    : Center(
                        child: Text(
                          "Пусто...",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class StatisticsDetailsTab {
  String title = "";
  int count = 0;
  Color badgeColor = Colors.black;
  List<LessonItemModel> models = [];

  StatisticsDetailsTab(this.title, this.count, this.badgeColor, this.models);
}
