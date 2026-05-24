import 'package:pdf/widgets.dart' as pw;
import 'package:quan_ly_nha_tro/core/models/models.dart';

/// Builds the "Điều khoản bổ sung" (Additional Terms) section for a contract PDF.
///
/// Pass the list of [ContractCustomTerm] fetched from the database.
/// Terms are sorted by [ContractCustomTerm.sortOrder] before rendering.
/// Each term is rendered as a numbered paragraph with [softWrap] enabled so
/// long sentences wrap gracefully on A4 paper.
///
/// Example usage inside a pdf document builder:
/// ```dart
/// final terms = await repo.getTermsByContract(contractId);
/// final section = buildTermsSection(terms, font: ttFont);
/// pdf.addPage(pw.Page(build: (ctx) => section));
/// ```
pw.Widget buildTermsSection(
  List<ContractCustomTerm> terms, {
  pw.Font? font,
  pw.Font? boldFont,
}) {
  // Sort ascending by sort_order
  final sorted = List<ContractCustomTerm>.from(terms)
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  if (sorted.isEmpty) {
    return pw.SizedBox.shrink();
  }

  final baseStyle = pw.TextStyle(font: font, fontSize: 11, lineSpacing: 4);

  final headerStyle = pw.TextStyle(
    font: boldFont ?? font,
    fontSize: 12,
    fontWeight: pw.FontWeight.bold,
  );

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      // Section header
      pw.Text('ĐIỀU KHOẢN BỔ SUNG', style: headerStyle),
      pw.SizedBox(height: 8),
      pw.Divider(thickness: 0.5),
      pw.SizedBox(height: 8),

      // Numbered terms – softWrap is the default for pw.Text (Text wraps
      // automatically within the column width).  maxLines is NOT set so text
      // can span multiple lines without truncation.
      ...sorted.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final term = entry.value;

        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Number badge (e.g. "1.")
              pw.SizedBox(
                width: 24,
                child: pw.Text(
                  '$index.',
                  style: pw.TextStyle(
                    font: boldFont ?? font,
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(width: 4),
              // Term text – Expanded so it fills the remaining width and wraps
              pw.Expanded(
                child: pw.Text(
                  term.termText,
                  style: baseStyle,
                  // softWrap is enabled by default in package:pdf
                  // Setting maxLines to null (omitted) ensures no truncation
                ),
              ),
            ],
          ),
        );
      }),
    ],
  );
}
