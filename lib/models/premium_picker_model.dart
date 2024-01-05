import 'package:ecampus_ncfu/cubit/api_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PremiumPlan extends StatefulWidget {
  const PremiumPlan({
    Key? key,
    this.padding,
    this.textPadding,
    required this.value,
    required this.onValueChanged,
  }) : super(key: key);

  final int value;
  final EdgeInsets? padding;
  final EdgeInsets? textPadding;
  final Function(int) onValueChanged;

  @override
  State<PremiumPlan> createState() => _PremiumPlanState();
}

class _PremiumPlanState extends State<PremiumPlan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      height: 110,
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              // To send the click data to the server
              context.read<ApiCubit>().state.api.sendStat(
                    "Clicked_yearly_btn",
                    extra: "Premium page",
                  );

              if (widget.value != 1) {
                setState(() {
                  widget.onValueChanged(1);
                });
              }
            },
            child: Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 40,
                  child: Checkbox(
                    shape: const CircleBorder(),
                    activeColor: Theme.of(context).primaryColor,
                    value: widget.value == 1,
                    onChanged: (bool? value) {
                      if (value != null && value != (widget.value == 1)) {
                        setState(() {
                          widget.onValueChanged(value ? 1 : 0);
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                            Text(
                              "Ежегодно",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 18,
                              width: 43,
                              padding: const EdgeInsets.only(left: 3, right: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text(
                                "-40%",
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "60,00\$",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                            TextSpan(
                              text: "  35,99 \$ год",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Text(
                    "3,00 \$ в месяц",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).dividerColor,
            thickness: 0.5,
            indent: 40,
          ),
          InkWell(
            onTap: () {
              // To send the click data to the server
              context.read<ApiCubit>().state.api.sendStat(
                    "Clicked_monthly_btn",
                    extra: "Premium page",
                  );

              if (widget.value != 2) {
                setState(() {
                  widget.onValueChanged(2);
                });
              }
            },
            child: Row(
              children: [
                SizedBox(
                  height: 30,
                  width: 40,
                  child: Checkbox(
                    shape: const CircleBorder(),
                    activeColor: Theme.of(context).primaryColor,
                    value: widget.value == 2,
                    onChanged: (bool? value) {
                      if (value != null && value != (widget.value == 2)) {
                        setState(() {
                          widget.onValueChanged(value ? 2 : 0);
                        });
                      }
                    },
                  ),
                ),
                Text(
                  "Ежемесячно",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    "5,00 \$ в месяц",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
