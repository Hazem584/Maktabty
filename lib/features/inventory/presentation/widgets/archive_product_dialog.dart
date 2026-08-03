import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/presentation/cubit/product_archive_cubit.dart';

class ArchiveDialogResult {
  final ProductEntity product;
  final bool wasAlreadyArchived;

  const ArchiveDialogResult({
    required this.product,
    this.wasAlreadyArchived = false,
  });
}

Future<ArchiveDialogResult?> showArchiveProductDialog({
  required BuildContext context,
  required ProductEntity product,
  required ProductArchiveCubit cubit,
}) {
  cubit.reset();
  return showDialog<ArchiveDialogResult>(
    context: context,
    barrierDismissible: false,
    builder: (_) => BlocProvider<ProductArchiveCubit>.value(
      value: cubit,
      child: _ArchiveProductDialog(product: product),
    ),
  );
}

class _ArchiveProductDialog extends StatefulWidget {
  final ProductEntity product;
  const _ArchiveProductDialog({required this.product});

  @override
  State<_ArchiveProductDialog> createState() => _ArchiveProductDialogState();
}

class _ArchiveProductDialogState extends State<_ArchiveProductDialog> {
  final TextEditingController _reasonController = TextEditingController();
  late ProductEntity _currentProduct;
  bool _confirmZero = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.product;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      setState(() => _error = context.l10n.enterArchiveReason);
      return;
    }
    if (reason.length > 1000) {
      setState(() => _error = context.l10n.archiveReasonTooLong);
      return;
    }
    if (_currentProduct.stock > 0 && !_confirmZero) {
      setState(() {
        _confirmZero = true;
        _error = null;
      });
      return;
    }

    await context.read<ProductArchiveCubit>().archive(
      ArchiveProductInput(
        productId: _currentProduct.id,
        reason: reason,
        adjustStockToZero: _confirmZero,
      ),
    );
    if (!mounted) return;
    final state = context.read<ProductArchiveCubit>().state;
    if (state.status == ProductArchiveStatus.archived &&
        state.product != null) {
      Navigator.of(context).pop(
        ArchiveDialogResult(product: state.product!),
      );
      return;
    }
    if (state.status == ProductArchiveStatus.conflict) {
      if (state.conflict == ProductArchiveConflict.alreadyArchived &&
          state.product != null) {
        Navigator.of(context).pop(
          ArchiveDialogResult(
            product: state.product!,
            wasAlreadyArchived: true,
          ),
        );
        return;
      }
      if (state.conflict == ProductArchiveConflict.remainingStock) {
        setState(() {
          _currentProduct = state.product ?? _currentProduct;
          _confirmZero = true;
          _error = context.l10n.productHasRemainingStock;
        });
        return;
      }
      setState(() => _error = context.l10n.archiveConflictRefreshStatus);
      return;
    }
    setState(() => _error = _safeFailureMessage(state.failure));
  }

  String _safeFailureMessage(AppFailure? failure) {
    if (failure?.code == FailureCode.validation) {
      return context.l10n.archiveRequestRejected;
    }
    return context.localizeFailure(
      failure,
      fallback: context.l10n.archiveRequestFailed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final submitting = context.select<ProductArchiveCubit, bool>(
      (cubit) => cubit.state.status == ProductArchiveStatus.submitting,
    );
    return AlertDialog(
      title: Text(context.l10n.archiveProduct),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentProduct.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Text(context.l10n.archiveProductExplanation),
              const SizedBox(height: 8),
              Text(context.l10n.historicalRecordsRemain),
              Text(context.l10n.barcodeRemainsReserved),
              Text(context.l10n.productCanBeRestored),
              const SizedBox(height: 16),
              TextField(
                controller: _reasonController,
                enabled: !submitting,
                autofocus: true,
                maxLength: 1000,
                minLines: 2,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: context.l10n.archiveReason,
                  hintText: context.l10n.enterArchiveReason,
                  errorText: _error,
                ),
              ),
              if (_confirmZero) ...[
                const SizedBox(height: 8),
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.currentStockValue(
                            _currentProduct.stock,
                          ),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(context.l10n.archiveStockAdjustmentWarning),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: submitting ? null : () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancel),
        ),
        FilledButton.icon(
          onPressed: submitting ? null : _submit,
          icon: submitting
              ? const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.archive_outlined),
          label: Text(
            _confirmZero
                ? context.l10n.archiveAndSetStockToZero
                : context.l10n.archiveProduct,
          ),
        ),
      ],
    );
  }
}
