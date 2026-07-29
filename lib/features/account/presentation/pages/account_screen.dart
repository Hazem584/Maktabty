import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/account/presentation/pages/account_screen_body.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.account),
        actions: [
          IconButton(
            tooltip: context.l10n.logout,
            onPressed: () => context.read<AuthCubit>().logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const SafeArea(child: AccountScreenBody()),
    );
  }
}
