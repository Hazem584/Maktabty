
import 'dart:io';
import 'dart:typed_data';

import 'package:arabic_reshaper/arabic_reshaper.dart';
import 'package:bidi/bidi.dart' as bidi;
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:maktabty/core/services/bluetooth_printer_adapter.dart';
import 'package:maktabty/core/services/printer_device.dart';
import 'package:maktabty/core/storage/printer_settings_storage.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';

class PrinterConfig {
  final PrinterMode mode;
  final PrinterDevice? device;

  const PrinterConfig({required this.mode, this.device});
}

class PrinterException implements Exception {
  final String message;

  const PrinterException(this.message);

  @override
  String toString() => message;
}

class ReceiptPrinterService {
  /// Test notes:
  /// - Simulate a sale -> receipt preview -> Print PDF.
  /// - Windows: verify system print dialog opens.
  /// - Android: select a bluetooth printer in settings then Print POS.
  final PrinterSettingsStorage _settingsStorage;
  final BluetoothPrinterAdapter _bluetoothPrinter =
      getBluetoothPrinterAdapter();
  final ArabicReshaper _arabicReshaper = ArabicReshaper();

  ReceiptPrinterService({required PrinterSettingsStorage settingsStorage})
    : _settingsStorage = settingsStorage;

  Future<void> printPdf(ReceiptEntity receipt) async {
    final doc = await _buildPdf(receipt);
    await Printing.layoutPdf(onLayout: (_) => doc.save());
  }

  Future<void> sharePdf(ReceiptEntity receipt) async {
    final doc = await _buildPdf(receipt);
    final bytes = await doc.save();
    await Printing.sharePdf(bytes: bytes, filename: _pdfFileName(receipt));
  }

  Future<void> printPos(ReceiptEntity receipt, {PrinterConfig? config}) async {
    final settings = await _settingsStorage.load();
    final mode = config?.mode ?? settings.mode;

    if (mode == PrinterMode.pdf) {
      await printPdf(receipt);
      return;
    }

    if (!_isAndroid) {
      await printPdf(receipt);
      return;
    }

    final device = config?.device ?? _deviceFromSettings(settings);
    if (device == null) {
      throw const PrinterException('No bluetooth printer selected');
    }

    await _printViaBluetooth(receipt, device);
  }

  Future<List<PrinterDevice>> getBluetoothDevices() async {
    if (!_isAndroid) return const [];
    return _bluetoothPrinter.getBondedDevices();
  }

  Future<void> _printViaBluetooth(
    ReceiptEntity receipt,
    PrinterDevice device,
  ) async {
    final connected = await _bluetoothPrinter.isConnected();
    if (!connected) {
      await _bluetoothPrinter.connect(device);
    }

    final bytes = await _buildEscPos(receipt);
    await _bluetoothPrinter.writeBytes(bytes);
  }

  PrinterDevice? _deviceFromSettings(PrinterSettings settings) {
    final address = settings.bluetoothAddress;
    if (address == null || address.isEmpty) return null;
    return PrinterDevice(
      name: settings.bluetoothName ?? 'Printer',
      address: address,
    );
  }

  Future<pw.Document> _buildPdf(ReceiptEntity receipt) async {
    final pdfFonts = await _resolvePdfFonts();
    final pageTheme = pdfFonts == null
        ? null
        : pw.ThemeData.withFont(base: pdfFonts.base, bold: pdfFonts.bold);

    final doc = pw.Document();
    final receiptWidth = 80 * PdfPageFormat.mm;
    final format = PdfPageFormat.a4;
    final textStyle = pw.TextStyle(fontSize: 10);

    doc.addPage(
      pw.MultiPage(
        theme: pageTheme,
        pageFormat: format,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          final dateLine = _displayDateTime(receipt);
          final content = <pw.Widget>[
            pw.Text(receipt.store.name, style: pw.TextStyle(fontSize: 14)),
            if ((receipt.store.address ?? '').isNotEmpty)
              pw.Text(receipt.store.address!, style: textStyle),
            if ((receipt.store.phone ?? '').isNotEmpty)
              pw.Text('Phone: ${receipt.store.phone}', style: textStyle),
            if ((receipt.store.taxNumber ?? '').isNotEmpty)
              pw.Text('Tax: ${receipt.store.taxNumber}', style: textStyle),
            if ((receipt.currency ?? '').isNotEmpty)
              pw.Text('Currency: ${receipt.currency}', style: textStyle),
            pw.SizedBox(height: 8),
            pw.Text('Receipt: ${receipt.receiptNo}', style: textStyle),
            if (receipt.receiptId.isNotEmpty)
              pw.Text('Receipt ID: ${receipt.receiptId}', style: textStyle),
            if (dateLine != null) pw.Text(dateLine, style: textStyle),
            if (dateLine == null && receipt.createdAt != null)
              pw.Text(_formatDate(receipt.createdAt!), style: textStyle),
            if (receipt.cashier != null)
              pw.Text(
                'Cashier: ${receipt.cashier!.fullName}',
                style: textStyle,
              ),
            pw.Divider(),
            if (receipt.distinctItems != null || receipt.totalQty != null) ...[
              pw.Text(
                'Items: ${receipt.distinctItems ?? '--'}',
                style: textStyle,
              ),
              pw.Text('Qty: ${receipt.totalQty ?? '--'}', style: textStyle),
              pw.SizedBox(height: 4),
            ],
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: textStyle,
              headers: const ['Item', 'Qty', 'Price', 'Total'],
              data: receipt.items
                  .map(
                    (item) => [
                      _itemLabel(item.name, item.code),
                      item.qty.toString(),
                      _formatMoney(item.unitPrice, currency: receipt.currency),
                      _formatMoney(item.lineTotal, currency: receipt.currency),
                    ],
                  )
                  .toList(),
              columnWidths: {
                0: const pw.FlexColumnWidth(3),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(1),
              },
            ),
            pw.Divider(),
            _buildTotalRow(
              'Subtotal',
              receipt.totals.subtotal,
              currency: receipt.currency,
            ),
            _buildTotalRow(
              'Discount',
              receipt.totals.discount,
              currency: receipt.currency,
            ),
            _buildTotalRow(
              'Tax',
              receipt.totals.tax,
              currency: receipt.currency,
            ),
            _buildTotalRow(
              'Total',
              receipt.totals.total,
              currency: receipt.currency,
              isBold: true,
            ),
            if (receipt.payment != null) ...[
              pw.SizedBox(height: 6),
              pw.Text(
                'Method: ${_paymentLabel(receipt.payment!.method)}',
                style: textStyle,
              ),
              if (receipt.payment!.paidAmount != null)
                pw.Text(
                  'Paid: ${_formatMoney(receipt.payment!.paidAmount!, currency: receipt.currency)}',
                  style: textStyle,
                ),
              if (receipt.payment!.cashAmount != null)
                pw.Text(
                  'Cash: ${_formatMoney(receipt.payment!.cashAmount!, currency: receipt.currency)}',
                  style: textStyle,
                ),
              if (receipt.payment!.cardAmount != null)
                pw.Text(
                  'Card: ${_formatMoney(receipt.payment!.cardAmount!, currency: receipt.currency)}',
                  style: textStyle,
                ),
              if (receipt.payment!.changeAmount != null)
                pw.Text(
                  'Change: ${_formatMoney(receipt.payment!.changeAmount!, currency: receipt.currency)}',
                  style: textStyle,
                ),
            ],
            if (receipt.footerLines.isNotEmpty) ...[
              pw.Divider(),
              ...receipt.footerLines.map(
                (line) => pw.Text(line, style: textStyle),
              ),
            ],
          ];
          return [
            pw.Center(
              child: pw.Container(
                width: receiptWidth,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: content,
                ),
              ),
            ),
          ];
        },
      ),
    );

    return doc;
  }

  Future<Uint8List> _buildEscPos(ReceiptEntity receipt) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    final bytes = <int>[];

    bytes.addAll(
      generator.text(
        receipt.store.name,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
    );
    if ((receipt.store.address ?? '').isNotEmpty) {
      bytes.addAll(generator.text(receipt.store.address!));
    }
    if ((receipt.store.phone ?? '').isNotEmpty) {
      bytes.addAll(generator.text('Phone: ${receipt.store.phone}'));
    }
    if ((receipt.store.taxNumber ?? '').isNotEmpty) {
      bytes.addAll(generator.text('Tax: ${receipt.store.taxNumber}'));
    }
    if ((receipt.currency ?? '').isNotEmpty) {
      bytes.addAll(generator.text('Currency: ${receipt.currency}'));
    }
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text('Receipt: ${receipt.receiptNo}'));
    if (receipt.receiptId.isNotEmpty) {
      bytes.addAll(generator.text('Receipt ID: ${receipt.receiptId}'));
    }
    final dateLine = _displayDateTime(receipt);
    if (dateLine != null) {
      bytes.addAll(generator.text(dateLine));
    } else if (receipt.createdAt != null) {
      bytes.addAll(generator.text(_formatDate(receipt.createdAt!)));
    }
    if (receipt.cashier != null) {
      bytes.addAll(generator.text('Cashier: ${receipt.cashier!.fullName}'));
    }
    bytes.addAll(generator.hr());

    if (receipt.distinctItems != null || receipt.totalQty != null) {
      bytes.addAll(generator.text('Items: ${receipt.distinctItems ?? '--'}'));
      bytes.addAll(generator.text('Qty: ${receipt.totalQty ?? '--'}'));
      bytes.addAll(generator.hr());
    }

    for (final item in receipt.items) {
      bytes.addAll(
        generator.row([
          PosColumn(text: _itemLabel(item.name, item.code), width: 6),
          PosColumn(text: item.qty.toString(), width: 2),
          PosColumn(
            text: _formatMoney(item.unitPrice, currency: receipt.currency),
            width: 2,
          ),
          PosColumn(
            text: _formatMoney(item.lineTotal, currency: receipt.currency),
            width: 2,
          ),
        ]),
      );
    }

    bytes.addAll(generator.hr());
    bytes.addAll(
      generator.row([
        PosColumn(text: 'Subtotal', width: 8),
        PosColumn(
          text: _formatMoney(
            receipt.totals.subtotal,
            currency: receipt.currency,
          ),
          width: 4,
        ),
      ]),
    );
    bytes.addAll(
      generator.row([
        PosColumn(text: 'Discount', width: 8),
        PosColumn(
          text: _formatMoney(
            receipt.totals.discount,
            currency: receipt.currency,
          ),
          width: 4,
        ),
      ]),
    );
    bytes.addAll(
      generator.row([
        PosColumn(text: 'Tax', width: 8),
        PosColumn(
          text: _formatMoney(receipt.totals.tax, currency: receipt.currency),
          width: 4,
        ),
      ]),
    );
    bytes.addAll(
      generator.row([
        PosColumn(text: 'Total', width: 8, styles: const PosStyles(bold: true)),
        PosColumn(
          text: _formatMoney(receipt.totals.total, currency: receipt.currency),
          width: 4,
          styles: const PosStyles(bold: true),
        ),
      ]),
    );

    if (receipt.payment != null) {
      bytes.addAll(
        generator.text('Method: ${_paymentLabel(receipt.payment!.method)}'),
      );
      if (receipt.payment!.paidAmount != null) {
        bytes.addAll(
          generator.text(
            'Paid: ${_formatMoney(receipt.payment!.paidAmount!, currency: receipt.currency)}',
          ),
        );
      }
      if (receipt.payment!.cashAmount != null) {
        bytes.addAll(
          generator.text(
            'Cash: ${_formatMoney(receipt.payment!.cashAmount!, currency: receipt.currency)}',
          ),
        );
      }
      if (receipt.payment!.cardAmount != null) {
        bytes.addAll(
          generator.text(
            'Card: ${_formatMoney(receipt.payment!.cardAmount!, currency: receipt.currency)}',
          ),
        );
      }
      if (receipt.payment!.changeAmount != null) {
        bytes.addAll(
          generator.text(
            'Change: ${_formatMoney(receipt.payment!.changeAmount!, currency: receipt.currency)}',
          ),
        );
      }
    }

    if (receipt.footerLines.isNotEmpty) {
      bytes.addAll(generator.hr());
      for (final line in receipt.footerLines) {
        bytes.addAll(generator.text(line));
      }
    }

    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

    return Uint8List.fromList(bytes);
  }

  pw.Widget _buildTotalRow(
    String label,
    double value, {
    String? currency,
    bool isBold = false,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        pw.Text(
          _formatMoney(value, currency: currency),
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    );
  }

  bool get _isAndroid {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  }

  String _paymentLabel(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.mixed:
        return 'Mixed';
    }
  }

  String _formatMoney(double value, {String? currency}) {
    final amount = value.toStringAsFixed(2);
    final code = currency?.trim();
    if (code == null || code.isEmpty) {
      return '\$$amount';
    }
    return '$code $amount';
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.year}-${_two(local.month)}-${_two(local.day)} ${_two(local.hour)}:${_two(local.minute)}';
  }

  String _two(int value) => value.toString().padLeft(2, '0');

  String? _displayDateTime(ReceiptEntity receipt) {
    final date = receipt.displayDate?.trim();
    if (date == null || date.isEmpty) return null;
    final time = receipt.displayTime?.trim();
    if (time == null || time.isEmpty) return date;
    return '$date $time';
  }

  String _itemLabel(String name, String? code) {
    final safeName = _forceRtlWhenArabic(name);
    final rawCode = code?.trim();
    if (rawCode == null || rawCode.isEmpty) return safeName;
    return '$safeName ($rawCode)';
  }

  String _forceRtlWhenArabic(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;
    if (!_containsArabic(trimmed)) return trimmed;
    final reshaped = _arabicReshaper.reshape(trimmed);
    final visual = String.fromCharCodes(bidi.logicalToVisual(reshaped));
    return visual;
  }

  bool _containsArabic(String value) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(value);
  }

  String _pdfFileName(ReceiptEntity receipt) {
    final raw = receipt.receiptNo.trim();
    final base = raw.isEmpty ? 'receipt' : raw;
    final safe = base.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    return '$safe.pdf';
  }

  Future<_PdfFontBundle?> _resolvePdfFonts() async {
    final windowsFonts = await _tryLoadWindowsFonts();
    if (windowsFonts != null) {
      return windowsFonts;
    }
    return _tryLoadGoogleArabicFonts();
  }

  Future<_PdfFontBundle?> _tryLoadWindowsFonts() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.windows) {
      return null;
    }

    try {
      const regularPath = r'C:\Windows\Fonts\arial.ttf';
      const boldPath = r'C:\Windows\Fonts\arialbd.ttf';

      final regularFile = File(regularPath);
      if (!regularFile.existsSync()) return null;

      final regularBytes = await regularFile.readAsBytes();
      final boldFile = File(boldPath);
      final boldBytes =
          boldFile.existsSync() ? await boldFile.readAsBytes() : regularBytes;

      final base = pw.Font.ttf(ByteData.sublistView(regularBytes));
      final bold = pw.Font.ttf(ByteData.sublistView(boldBytes));
      return _PdfFontBundle(base: base, bold: bold);
    } catch (_) {
      return null;
    }
  }

  Future<_PdfFontBundle?> _tryLoadGoogleArabicFonts() async {
    try {
      final base = await PdfGoogleFonts.notoNaskhArabicRegular();
      final bold = await PdfGoogleFonts.notoNaskhArabicBold();
      return _PdfFontBundle(base: base, bold: bold);
    } catch (_) {
      return null;
    }
  }
}

class _PdfFontBundle {
  final pw.Font base;
  final pw.Font bold;

  const _PdfFontBundle({required this.base, required this.bold});
}
