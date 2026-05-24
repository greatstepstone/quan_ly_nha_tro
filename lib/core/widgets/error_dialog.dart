import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:share_plus/share_plus.dart';

import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';

class ErrorDialog extends StatefulWidget {
  final String? title;
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  const ErrorDialog({
    super.key,
    this.title,
    required this.message,
    this.error,
    this.stackTrace,
  });

  static Future<void> show(
    BuildContext context, {
    String? title,
    required String message,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => ErrorDialog(
            title: title ?? AppStrings.errorTitle,
            message: message,
            error: error,
            stackTrace: stackTrace,
          ),
    );
  }

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  bool _showDetails = false;

  String get _fullErrorLog {
    final buffer = StringBuffer();
    buffer.writeln(AppStrings.errorReportHeader);
    buffer.writeln(
      '${AppStrings.errorReportTitle}: ${widget.title ?? AppStrings.errorTitle}',
    );
    buffer.writeln('${AppStrings.errorReportMessage}: ${widget.message}');
    buffer.writeln('${AppStrings.errorReportTimestamp}: ${DateTime.now()}');
    if (widget.error != null) {
      buffer.writeln(
        '${AppStrings.errorReportTechnicalDetails}: ${widget.error}',
      );
    }
    if (widget.stackTrace != null) {
      buffer.writeln(
        '${AppStrings.errorReportStackTrace}:\n${widget.stackTrace}',
      );
    }
    buffer.writeln('---------------------');
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      elevation: 24,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Accent Bar
            Container(height: 6, width: double.infinity, color: AppColors.red),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.red.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.red,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    widget.title ?? AppStrings.errorTitle,
                    textAlign: TextAlign.center,
                    style: manrope(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Message
                  Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: manrope(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),

                  // Technical Details Toggle
                  if (widget.error != null) ...[
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () => setState(() => _showDetails = !_showDetails),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _showDetails
                                  ? AppStrings.hideTechnicalDetails
                                  : AppStrings.showTechnicalDetails,
                              style: manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            Icon(
                              _showDetails
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (_showDetails)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.2),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: SelectableText(
                            _fullErrorLog,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceBright,
                border: Border(
                  top: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Copy Button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: _fullErrorLog),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppStrings.copyLogSuccess),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy_rounded, size: 18),
                          label: Text(AppStrings.copy),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Share Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Share.share(
                              _fullErrorLog,
                              subject: AppStrings.appErrorReportSubject,
                            );
                          },
                          icon: const Icon(Icons.send_rounded, size: 18),
                          label: Text(AppStrings.sendReport),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Close Button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppStrings.close,
                        style: manrope(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
