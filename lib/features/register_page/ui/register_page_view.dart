import 'package:credito_solitario_mobile/core/services/register_service.dart';
import 'package:credito_solitario_mobile/features/register_page/bloc/register_page_bloc.dart';
import 'package:credito_solitario_mobile/features/register_page/ui/register_page_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPageView extends StatelessWidget {
  const RegisterPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterPageBloc(RegisterService()),
      child: const RegisterPageForm(),
    );
  }
}