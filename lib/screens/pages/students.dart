import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/students_viewmodel.dart';
import '../auth.dart';
import 'events.dart';

class StudentsView extends StatelessWidget {
  const StudentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Students',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 32,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Consumer<StudentsViewModel>(
                builder: (_, StudentsViewModel viewModel, __) {
                  if (viewModel.isLoading) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (viewModel.students.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: Text('No students available'),
                      ),
                    );
                  }
                  return Expanded(
                    flex: 2,
                    child: ListView.separated(
                      itemCount: viewModel.students.length,
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
                              // Navigator.of(context).pushNamed(
                              //   Routes.student,
                              //   arguments: viewModel.events[i],
                              // );
                            },
                            child: Column(
                              children: <Widget>[
                                Text(
                                  '${viewModel.students[i].firstname} ${viewModel.students[i].lastname}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  viewModel.students[i].dob
                                          ?.toIso8601String() ??
                                      '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
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
              Consumer<StudentsViewModel>(
                builder: (_, StudentsViewModel viewModel, __) {
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
                              label: 'First Name',
                              hint: 'First Name',
                              controller: viewModel.firstnameController,
                              // focusNode: viewModel.emailNode,
                              // nextNode: viewModel.passwordNode,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Last Name',
                              hint: 'Last Name',
                              controller: viewModel.lastnameController,
                              // focusNode: viewModel.emailNode,
                              // nextNode: viewModel.passwordNode,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Email',
                              hint: 'Email',
                              controller: viewModel.emailController,
                              // focusNode: viewModel.passwordNode,
                              // isPassword: true,
                              // textInputAction: TextInputAction.done,
                            ),
                            if (viewModel.hasError)
                              const Text(
                                'Email already in used.',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Gender',
                              hint: 'Gender',
                              controller: viewModel.genderController,
                              // focusNode: viewModel.passwordNode,
                              // isPassword: true,
                              // textInputAction: TextInputAction.done,
                            ),
                            const SizedBox(height: 16),
                            CustomDateField(
                              onDatePicked: viewModel.onDatePicked,
                              label: 'Date of birth',
                              controller: viewModel.dobController,
                              // focusNode: viewModel.dobNode,
                              currentTime: viewModel.date,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Level',
                              hint: '2nd Year',
                              controller: viewModel.levelController,

                              // focusNode: viewModel.passwordNode,
                              // isPassword: true,
                              // textInputAction: TextInputAction.done,
                            ),
                            const SizedBox(height: 40),
                            CustomStickyButton(
                              label: 'Add Student',
                              onPressed: () async {
                                await viewModel.addStudent();
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
