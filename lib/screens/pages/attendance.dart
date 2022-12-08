import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/attendanceviewmodel.dart';
import '../auth.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceViewModel>(
        builder: (_, AttendanceViewModel viewModel, __) {
      return Column(
        children: <Widget>[
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Attendance',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
              ),
            ),
          ),
          // const Expanded(
          //   child: Center(
          //     child: Text(
          //       'There are no events for today.',
          //     ),
          //   ),
          // ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.blue.withOpacity(.12),
                        blurRadius: 8,
                        offset: const Offset(4, 8),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 64,
                        width: double.maxFinite,
                        color: Colors.blue.shade100,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Text(
                              "Valentine's Day",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Feb 24, 2023',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Valentine’s Day, also called St. Valentine’s Day, holiday (February 14) when lovers express their affection with greetings and gifts. Given their similarities, it has been suggested that the holiday has origins in the Roman festival of Lupercalia, held in mid-February. The festival, which celebrated the coming of spring, included fertility rites and the pairing off of women with men by lottery. At the end of the 5th century, Pope Gelasius I forbid the celebration of Lupercalia and is sometimes attributed with replacing it with St. Valentine’s Day, but the true origin of the holiday is vague at best. Valentine’s Day did not come to be celebrated as a day of romance until about the 14th century.',
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: CustomTextField(
                    label: 'Enter passcode',
                    hint: '000000',
                    keyboardType: TextInputType.number,
                    controller: viewModel.passCodeController,
                  ),
                ),
                CustomStickyButton(
                  label: 'Attend This Event',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class CustomStickyButton extends StatelessWidget {
  const CustomStickyButton({
    required this.label,
    required this.onPressed,
    this.margin,
    this.padding,
    Key? key,
  }) : super(key: key);

  final String label;
  final Function() onPressed;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        margin: margin ?? const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CupertinoButton.filled(
          disabledColor: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
          onPressed: onPressed,
          padding: padding,
          child: Text(
            label,
            style: textTheme.labelLarge?.copyWith(color: colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }
}
