import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/work_hours/presentation/cubit/work_hours_cubit.dart';
import 'package:maktabty/features/work_hours/presentation/pages/add_work_hours_screen_body.dart';

class AddWorkHoursScreen extends StatelessWidget {
  const AddWorkHoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkHoursCubit>(
      create: (_) => sl<WorkHoursCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.workHours),
        ),
        body: const SafeArea(
          child: AddWorkHoursScreenBody(),
        ),
      ),
    );
  }
}
