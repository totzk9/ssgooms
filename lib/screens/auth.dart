import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../routes/pages.dart';
import '../viewmodels/authviewmodel.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AuthViewModel viewModel = context.read<AuthViewModel>();

    return _MainScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 32),
          Text(
            'SSGO-OMS Admin Portal',
            textAlign: TextAlign.center,
            style: textTheme.displaySmall,
          ),
          const Spacer(),
          CustomTextField(
            onChanged: viewModel.onEmailChanged,
            validator: (String? input) {
              if (!viewModel.isEmailChanged) {
                if (input?.isEmailValid ?? false) {
                  return null;
                } else {
                  if (input == null || input.trim().isEmpty) {
                    return 'Enter your email.';
                  } else {
                    return 'Email format is invalid.';
                  }
                }
              }
              return null;
            },
            label: 'Email',
            hint: 'jane.doe@gmail.com',
            keyboardType: TextInputType.emailAddress,
            controller: viewModel.emailController,
            focusNode: viewModel.emailNode,
            nextNode: viewModel.passwordNode,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            onChanged: viewModel.onPasswordChanged,
            validator: (String? input) {
              if (!viewModel.isPasswordChanged) {
                if (input == null || input.trim().isEmpty) {
                  return 'Password is required.';
                }
              }
              return null;
            },
            label: 'Password',
            hint: 'Enter your password',
            controller: viewModel.passwordController,
            focusNode: viewModel.passwordNode,
            isPassword: true,
            textInputAction: TextInputAction.done,
          ),
          const Spacer(flex: 2),
          CustomStickyButton(
            label: 'Sign in',
            onPressed: () async {
              final bool state = await viewModel.signIn();
              if (!state) {
                return;
              }
              Navigator.pushReplacementNamed(
                context,
                Routes.home,
              );
            },
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          Selector<AuthViewModel, bool>(
            selector: (_, AuthViewModel viewModel) => viewModel.isLoading,
            builder: (_, bool isLoading, __) {
              if (isLoading) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 24,
                    width: 24,
                    child: const CircularProgressIndicator(),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _MainScaffold extends StatelessWidget {
  const _MainScaffold({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: context.read<AuthViewModel>().loginForm,
            child: child,
          ),
        ),
      ),
    );
  }
}

class CustomStickyButton extends StatelessWidget {
  const CustomStickyButton({
    required this.label,
    required this.onPressed,
    this.margin,
    this.padding,
    this.color,
    Key? key,
  }) : super(key: key);

  final String label;
  final Function() onPressed;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? color;

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

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    this.onSubmit,
    this.onChanged,
    this.onTap,
    required this.label,
    this.labelColor,
    this.errorColor,
    required this.controller,
    this.hint,
    this.readOnly = false,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.nextNode,
    this.validator,
    this.isPassword = false,
    this.suffix,
    this.capitalization = TextCapitalization.none,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.expands = false,
    Key? key,
  }) : super(key: key);

  final String label;
  final Color? labelColor;
  final Color? errorColor;
  final String? hint;
  final TextEditingController controller;
  final bool readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final String? Function(String?)? validator;
  final bool isPassword;
  final Widget? suffix;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function()? onSubmit;
  final TextCapitalization capitalization;
  final Function(String)? onFieldSubmitted;
  final int maxLines;
  final bool expands;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          widget.label,
          style: textTheme.titleMedium?.copyWith(
            color: widget.labelColor ?? colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          controller: widget.controller,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.capitalization,
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          obscureText: widget.isPassword && !_showPassword,
          cursorColor: colorScheme.primary,
          style: textTheme.bodyLarge,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: colorScheme.background.withOpacity(0.81),
            suffixIcon: widget.suffix ??
                (widget.isPassword ? _buildEyeSuffixIcon() : null),
            hintText: widget.hint,
            hintStyle: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onBackground.withOpacity(0.7),
            ),
            errorStyle: textTheme.bodySmall?.copyWith(
              color: widget.errorColor,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.primary.withOpacity(0.50),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(
                color: colorScheme.primary.withOpacity(0.8),
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.primary.withOpacity(0.50),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(
                color: colorScheme.primary.withOpacity(0.8),
                width: 2.0,
              ),
            ),
          ),
          onEditingComplete: () {
            switch (widget.textInputAction) {
              case TextInputAction.next:
                FocusScope.of(context).requestFocus(widget.nextNode);
                break;
              case TextInputAction.done:
                FocusManager.instance.primaryFocus?.unfocus();
                widget.onSubmit?.call();
                break;
              default:
            }
          },
          onFieldSubmitted: widget.onFieldSubmitted,
          maxLines: widget.maxLines,
          expands: widget.expands,
        ),
      ],
    );
  }

  /// Build show password suffix icon.
  Widget _buildEyeSuffixIcon() => GestureDetector(
        onTap: () => setState(() => _showPassword = !_showPassword),
        child: Icon(
          _showPassword ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
          size: 24,
        ),
      );
}

extension StringExt on String {
  bool get isEmailValid {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }
}
