import 'package:admin_ssgooms/screens/pages/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import '../viewmodels/event_viewmodel.dart';
import 'auth.dart';

class EventView extends StatelessWidget {
  const EventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventViewModel>(
      builder: (_, EventViewModel viewModel, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(viewModel.event.title),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: Container(
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
                    label: 'Update Event',
                    onPressed: () async {
                      final bool isSuccess = await viewModel.updateEvent();
                      if (!isSuccess) {
                        return;
                      }
                      Navigator.pop(context, true);
                    },
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  const SizedBox(height: 24),
                  CupertinoButton(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                    onPressed: () async {
                      final bool isSuccess = await viewModel.deleteEvent();
                      if (!isSuccess) {
                        return;
                      }
                      Navigator.pop(context, true);
                    },
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Container(
                      width: double.maxFinite,
                      alignment: Alignment.center,
                      child: Text(
                        'Delete Event',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
