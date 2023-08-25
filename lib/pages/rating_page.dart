import 'package:ecampus_ncfu/cubit/api_cubit.dart';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/ecampus_master/responses.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/models/rating_model.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:ecampus_ncfu/utils/gui_utils.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  eCampus? ecampus;
  List<RatingModel>? models;
  double elevation = 0;

  @override
  void initState() {
    super.initState();
    ecampus = context.read<ApiCubit>().state.api;
    update();
  }

  void update() async {
    if (await isOnline()) {
      if (await ecampus!.isActualToken()) {
        setState(() {
          models = null;
        });
        RatingResponse response = await ecampus!.getRating();
        if (response.isSuccess) {
          setState(() {
            models = response.items;
          });
        } else {
          showAlertDialog(context, "Ошибка", response.error);
        }
      } else {
        showCapchaDialog(context, await ecampus!.getCaptcha(), ecampus!, () {
          update();
        });
      }
    } else {
      showOfflineDialog(context);
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
        actions: [
          CupertinoButton(
            onPressed: update,
            child: const Icon(EcampusIcons.icons8_restart),
          )
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: elevation,
        title: Text(
          "Рейтинг",
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
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    update();
                  },
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Column(
                    children: <Widget>[
                      models != null
                          ? Column(
                              children: models!
                                  .map(
                                    (element) => CrossListElement(
                                      onPressed: () {},
                                      child: element.getView(context),
                                    ),
                                  )
                                  .toList(),
                            )
                          : Column(
                              children: [
                                getNotificationSkeleton(context),
                                getNotificationSkeleton(context),
                                getNotificationSkeleton(context),
                                getNotificationSkeleton(context),
                                getNotificationSkeleton(context),
                              ],
                            )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  )
                ]))
              ],
            )),
      ),
    );
  }
}
