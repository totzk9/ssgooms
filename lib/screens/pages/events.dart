import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../routes/pages.dart';
import '../../viewmodels/eventsviewmodel.dart';
import '../auth.dart';

class EventsView extends StatelessWidget {
  const EventsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Events',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 32,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Consumer<EventsViewModel>(
                builder: (_, EventsViewModel viewModel, __) {
                  if (viewModel.isLoading) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (viewModel.events.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: Text('No events available'),
                      ),
                    );
                  }
                  return Expanded(
                    flex: 2,
                    child: ListView.separated(
                      itemCount: viewModel.events.length,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      itemBuilder: (_, int i) {
                        return Container(
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
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                Routes.event,
                                arguments: viewModel.events[i],
                              );
                            },
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 64,
                                  width: double.maxFinite,
                                  color: Colors.blue.shade100,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        viewModel.events[i].title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        viewModel.events[i].date.toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ReadMoreText(
                                    viewModel.events[i].body,
                                    trimLines: 3,
                                    colorClickableText: Colors.pink,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: ' Show more',
                                    trimExpandedText: ' Show less',
                                    moreStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    lessStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, int i) {
                        return const SizedBox(height: 16);
                      },
                    ),
                  );
                },
              ),
              Consumer<EventsViewModel>(
                builder: (_, EventsViewModel viewModel, __) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
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
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CustomTextField(
                              label: 'Event Name',
                              hint: 'Event Name',
                              controller: viewModel.nameController,
                              // focusNode: viewModel.emailNode,
                              // nextNode: viewModel.passwordNode,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Description',
                              hint: 'Description',
                              controller: viewModel.descController,
                              maxLines: 8,
                              // focusNode: viewModel.passwordNode,
                              // isPassword: true,
                              // textInputAction: TextInputAction.done,
                            ),
                            const SizedBox(height: 16),
                            CustomDateField(
                              onDatePicked: viewModel.onDatePicked,
                              label: 'Date of event',
                              controller: viewModel.dateController,
                              // focusNode: viewModel.dobNode,
                              currentTime: viewModel.date,
                              maxTime: DateTime.now().subtract(
                                const Duration(days: 6575),
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Attendance Passcode',
                              hint: 'Attendance Passcode',
                              controller: viewModel.passCodeController,

                              // focusNode: viewModel.passwordNode,
                              // isPassword: true,
                              // textInputAction: TextInputAction.done,
                            ),
                            const SizedBox(height: 40),
                            CustomStickyButton(
                              label: 'Add Event',
                              onPressed: () async {
                                await viewModel.addEvent();
                              },
                              margin: EdgeInsets.zero,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomDateField extends StatelessWidget {
  const CustomDateField({
    this.validator,
    this.onDatePicked,
    required this.label,
    required this.controller,
    this.hint = 'dd/mm/yyyy',
    this.dateFormatDisplay = 'dd/MM/yyyy',
    this.focusNode,
    this.suffix,
    this.currentTime,
    this.maxTime,
    Key? key,
  }) : super(key: key);

  final FormFieldValidator<String>? validator;
  final String label;
  final TextEditingController controller;
  final String hint;
  final String dateFormatDisplay;
  final FocusNode? focusNode;
  final Widget? suffix;
  final Function(DateTime)? onDatePicked;
  final DateTime? currentTime;
  final DateTime? maxTime;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: textTheme.subtitle2?.copyWith(color: colorScheme.primary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          onTap: () async => _showDatePicker(context),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          readOnly: true,
          focusNode: focusNode,
          cursorColor: colorScheme.primary,
          style: textTheme.bodyText2,
          decoration: InputDecoration(
            filled: true,
            fillColor: colorScheme.background.withOpacity(0.81),
            suffixIcon: suffix,
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
        ),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    DateTime? initialDateTime;
    if (currentTime == null || maxTime == null) {
      initialDateTime = DateTime.now();
    } else {
      if (currentTime!.isBefore(maxTime!)) {
        initialDateTime = currentTime;
      } else {
        initialDateTime = maxTime;
      }
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 9999)),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) {
      onDatePicked!(picked);
    }
  }
}
