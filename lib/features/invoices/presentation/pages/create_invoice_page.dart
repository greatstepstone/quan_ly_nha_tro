import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:uuid/uuid.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/tenant_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/property_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/service_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/meter_reading_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/invoice_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/contract_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/database_providers.dart';
import 'package:quan_ly_nha_tro/features/invoices/presentation/pages/invoice_export_page.dart';
import 'package:quan_ly_nha_tro/features/invoices/presentation/widgets/invoice_form_widgets.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/widgets/error_dialog.dart';
import 'package:quan_ly_nha_tro/core/widgets/meter_reading_section_card.dart';
import 'package:quan_ly_nha_tro/core/utils/meter_image_storage.dart';

class CreateInvoicePage extends ConsumerStatefulWidget {
  final String roomId;
  final String? month;
  const CreateInvoicePage({super.key, required this.roomId, this.month});

  @override
  ConsumerState<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends ConsumerState<CreateInvoicePage> {
  final _electricOldCtrl = TextEditingController();
  final _electricNewCtrl = TextEditingController();
  final _waterOldCtrl = TextEditingController();
  final _waterNewCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  XFile? _electricOldImage;
  XFile? _electricNewImage;
  XFile? _waterOldImage;
  XFile? _waterNewImage;

  bool _isSaving = false;
  Room? _room;
  Tenant? _tenant;
  Property? _property;
  List<Service> _services = [];
  Invoice? _existingInvoice;
  MeterReading? _existingMeterReading;
  InvoiceStatus _status = InvoiceStatus.unpaid;
  bool _isLoading = true;
  int _membersCount = 1;

  String get _currentMonth {
    if (widget.month != null) return widget.month!;
    final now = DateTime.now();
    return '${now.month.toString().padLeft(2, '0')}/${now.year}';
  }

  @override
  void initState() {
    super.initState();
    _electricOldCtrl.addListener(_onInputChanged);
    _electricNewCtrl.addListener(_onInputChanged);
    _waterOldCtrl.addListener(_onInputChanged);
    _waterNewCtrl.addListener(_onInputChanged);
    Future.microtask(() => _loadData());
  }

  void _onInputChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final roomRepo = ref.read(roomRepositoryProvider);
      final tenantRepo = ref.read(tenantRepositoryProvider);
      final propertyRepo = ref.read(propertyRepositoryProvider);
      final serviceRepo = ref.read(serviceRepositoryProvider);
      final meterReadingRepo = ref.read(meterReadingRepositoryProvider);
      final invoiceRepo = ref.read(invoiceRepositoryProvider);

      final room = await roomRepo.getRoomById(widget.roomId);
      if (room == null) {
        setState(() => _isLoading = false);
        return;
      }
      _room = room;

      if (room.tenantId != null) {
        _tenant = await tenantRepo.getTenantById(room.tenantId!);
      }

      _property = await propertyRepo.getPropertyById(room.propertyId);
      _services = await serviceRepo.getServicesByProperty(room.propertyId);

      // Fetch active contract and members count for perPerson services
      final contractRepo = ref.read(contractRepositoryProvider);
      final roomMemberDao = ref.read(roomMemberDaoProvider);
      final activeContract = await contractRepo.getActiveContractByRoom(
        widget.roomId,
      );
      if (activeContract != null) {
        final members = await roomMemberDao.getMembersByContract(
          activeContract.id,
        );
        _membersCount = members.length;
      }

      final readings = await meterReadingRepo.getMeterReadingsByRoom(
        widget.roomId,
      );
      if (readings.isNotEmpty) {
        final currentMonthReading =
            readings.where((r) => r.month == _currentMonth).firstOrNull;
        if (currentMonthReading != null) {
          _existingMeterReading = currentMonthReading;
          _electricOldCtrl.text = currentMonthReading.electricOld.toString();
          _electricNewCtrl.text =
              (currentMonthReading.electricNew ?? 0).toString();
          _waterOldCtrl.text = currentMonthReading.waterOld.toString();
          _waterNewCtrl.text = (currentMonthReading.waterNew ?? 0).toString();
          // Load previously saved images
          if (currentMonthReading.electricNewImagePath != null) {
            _electricNewImage = XFile(
              currentMonthReading.electricNewImagePath!,
            );
          }
          if (currentMonthReading.waterNewImagePath != null) {
            _waterNewImage = XFile(currentMonthReading.waterNewImagePath!);
          }
        } else {
          // Pre-fill old values and auto-load newImage → oldImage from last month
          final latest = readings.first;
          _electricOldCtrl.text =
              (latest.electricNew ?? latest.electricOld).toString();
          _waterOldCtrl.text = (latest.waterNew ?? latest.waterOld).toString();
          if (latest.electricNewImagePath != null) {
            _electricOldImage = XFile(latest.electricNewImagePath!);
          }
          if (latest.waterNewImagePath != null) {
            _waterOldImage = XFile(latest.waterNewImagePath!);
          }
        }
      }

      final invoices = await invoiceRepo.getInvoicesByRoom(widget.roomId);
      _existingInvoice =
          invoices.where((i) => i.month == _currentMonth).firstOrNull;
      _status = _existingInvoice?.status ?? InvoiceStatus.unpaid;
    } catch (e, stackTrace) {
      debugPrint('Error loading invoice data: $e');
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Lỗi tải dữ liệu',
          message: 'Không thể tải dữ liệu hóa đơn.',
          error: e,
          stackTrace: stackTrace,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int get _electricOld => int.tryParse(_electricOldCtrl.text) ?? 0;
  int get _electricNew => int.tryParse(_electricNewCtrl.text) ?? 0;
  int get _waterOld => int.tryParse(_waterOldCtrl.text) ?? 0;
  int get _waterNew => int.tryParse(_waterNewCtrl.text) ?? 0;

  double get _electricCost =>
      (_electricNew - _electricOld).clamp(0, 99999) *
      (_property?.electricityPrice ?? 3500);

  double get _waterCost =>
      (_waterNew - _waterOld).clamp(0, 99999) *
      (_property?.waterPrice ?? 15000);

  double get _rentPrice => _room?.rentPrice ?? 0;
  double get _servicesTotalCost => _services.fold(0.0, (sum, s) {
    if (s.type == BillingType.perPerson) {
      return sum + (s.price * _membersCount);
    }
    return sum + s.price;
  });
  double get _total =>
      _electricCost + _waterCost + _rentPrice + _servicesTotalCost;

  Future<void> _saveInvoice() async {
    if (_isSaving) return;

    final ownerId = ref.read(currentUserProvider)?.id;
    if (ownerId == null) {
      if (mounted) {
        ErrorDialog.show(context, message: AppStrings.invoiceLoginRequired);
      }
      return;
    }

    setState(() => _isSaving = true);

    try {
      final invoiceRepo = ref.read(invoiceRepositoryProvider);
      final meterReadingRepo = ref.read(meterReadingRepositoryProvider);

      final now = DateTime.now();
      final dueDateTime = DateTime(now.year, now.month + 1, now.day);
      final dueDate = dueDateTime.toIso8601String().split('T')[0];

      final electricNew = _electricNewCtrl.text.isEmpty ? null : _electricNew;
      final waterNew = _waterNewCtrl.text.isEmpty ? null : _waterNew;

      final readingId = _existingMeterReading?.id ?? const Uuid().v4();

      // Save images to local storage
      final electricOldPath =
          _electricOldImage != null
              ? await saveMeterImage(
                _electricOldImage!,
                readingId: readingId,
                type: 'electric_old',
                month: _currentMonth,
              )
              : _existingMeterReading?.electricOldImagePath;
      final electricNewPath =
          _electricNewImage != null
              ? await saveMeterImage(
                _electricNewImage!,
                readingId: readingId,
                type: 'electric_new',
                month: _currentMonth,
              )
              : _existingMeterReading?.electricNewImagePath;
      final waterOldPath =
          _waterOldImage != null
              ? await saveMeterImage(
                _waterOldImage!,
                readingId: readingId,
                type: 'water_old',
                month: _currentMonth,
              )
              : _existingMeterReading?.waterOldImagePath;
      final waterNewPath =
          _waterNewImage != null
              ? await saveMeterImage(
                _waterNewImage!,
                readingId: readingId,
                type: 'water_new',
                month: _currentMonth,
              )
              : _existingMeterReading?.waterNewImagePath;

      await meterReadingRepo.saveMeterReading(
        MeterReading(
          id: readingId,
          ownerId: ownerId,
          roomId: widget.roomId,
          month: _currentMonth,
          electricOld: _electricOld,
          electricNew: electricNew,
          waterOld: _waterOld,
          waterNew: waterNew,
          electricOldImagePath: electricOldPath,
          electricNewImagePath: electricNewPath,
          waterOldImagePath: waterOldPath,
          waterNewImagePath: waterNewPath,
          isRecorded: true,
        ),
      );

      final invoice = Invoice(
        id: _existingInvoice?.id ?? const Uuid().v4(),
        ownerId: ownerId,
        roomId: widget.roomId,
        month: _currentMonth,
        totalAmount: _total,
        status: _status,
        dueDate: dueDate,
      );

      await invoiceRepo.saveInvoice(invoice);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppStrings.invoiceSaveSuccess}${_room?.name ?? ''} ${AppStrings.monthSuffix} $_currentMonth!',
            ),
            backgroundColor: AppColors.emerald,
          ),
        );
        context.pop();
      }
    } catch (e) {
      debugPrint('Error saving invoice: $e');
      if (mounted) {
        ErrorDialog.show(
          context,
          message: AppStrings.invoiceSaveError,
          error: e,
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _electricOldCtrl.removeListener(_onInputChanged);
    _electricNewCtrl.removeListener(_onInputChanged);
    _waterOldCtrl.removeListener(_onInputChanged);
    _waterNewCtrl.removeListener(_onInputChanged);
    _electricOldCtrl.dispose();
    _electricNewCtrl.dispose();
    _waterOldCtrl.dispose();
    _waterNewCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(AppStrings.invoiceTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _room == null
              ? Center(
                child: Text(
                  AppStrings.invoiceRoomNotFound,
                  style: manrope(
                    fontSize: FontSize.s16,
                    color: AppColors.textSecondary,
                  ),
                ),
              )
              : _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.all(AppPadding.p16),
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceBright,
            borderRadius: BorderRadius.circular(AppRadius.r16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: AppHeight.h100,
                decoration: const BoxDecoration(
                  color: Color(0xFF1a2a3a),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppRadius.r16),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.apartment_rounded,
                    color: Colors.white24,
                    size: AppSize.s60,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppPadding.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.invoiceRoomInfo,
                      style: manrope(
                        fontSize: FontSize.s10,
                        fontWeight: FontWeightManager.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      _room!.name,
                      style: manrope(
                        fontSize: FontSize.s18,
                        fontWeight: FontWeightManager.extraBold,
                      ),
                    ),
                    if (_property != null)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: AppSize.s14,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: AppWidth.w4),
                          Expanded(
                            child: Text(
                              _property!.name,
                              style: manrope(
                                fontSize: FontSize.s13,
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    if (_tenant != null)
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: AppSize.s14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppWidth.w4),
                          Text(
                            '${AppStrings.invoiceTenantLabel}${_tenant!.name}',
                            style: manrope(
                              fontSize: FontSize.s13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: AppHeight.h4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.p10,
                        vertical: AppPadding.p4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(AppRadius.r50),
                      ),
                      child: Text(
                        '${AppStrings.monthSuffix} $_currentMonth',
                        style: manrope(
                          fontSize: FontSize.s12,
                          fontWeight: FontWeightManager.semiBold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppHeight.h16),

        MeterReadingSectionCard(
          icon: Icons.bolt,
          iconColor: AppColors.amber,
          iconBg: AppColors.amberLight,
          title: 'ĐIỆN (KWH)',
          subtitle: 'Sử dụng trong tháng',
          oldValue: _electricOldCtrl.text.isEmpty ? '0' : _electricOldCtrl.text,
          controller: _electricNewCtrl,
          hint: 'Nhập số điện mới...',
          oldImage: _electricOldImage,
          newImage: _electricNewImage,
          onImagePicked: (file, isOld) {
            setState(() {
              if (isOld) {
                _electricOldImage = file;
              } else {
                _electricNewImage = file;
              }
            });
          },
        ),
        const SizedBox(height: AppHeight.h8),
        InvoiceCostRow(
          label:
              '${AppStrings.invoiceElectricCost} (${fmtDouble(_property?.electricityPrice ?? 3500)}/kWh)',
          value: _electricCost,
        ),
        const SizedBox(height: AppHeight.h16),
        MeterReadingSectionCard(
          icon: Icons.water_drop,
          iconColor: AppColors.primary,
          iconBg: AppColors.primaryLight,
          title: 'NƯỚC (M3)',
          subtitle: 'Lượng nước tiêu thụ',
          oldValue: _waterOldCtrl.text.isEmpty ? '0' : _waterOldCtrl.text,
          controller: _waterNewCtrl,
          hint: 'Nhập số nước mới...',
          oldImage: _waterOldImage,
          newImage: _waterNewImage,
          onImagePicked: (file, isOld) {
            setState(() {
              if (isOld) {
                _waterOldImage = file;
              } else {
                _waterNewImage = file;
              }
            });
          },
        ),
        const SizedBox(height: AppHeight.h8),
        InvoiceCostRow(
          label:
              '${AppStrings.invoiceWaterCost} (${fmtDouble(_property?.waterPrice ?? 15000)}/m³)',
          value: _waterCost,
        ),
        const SizedBox(height: AppHeight.h16),

        InvoiceCard(
          icon: Icons.layers_outlined,
          iconColor: AppColors.emerald,
          title: AppStrings.invoiceRentServices,
          child: Column(
            children: [
              InvoiceServiceRow(
                icon: Icons.bed_outlined,
                label:
                    '${AppStrings.homeRooms} ${AppStrings.monthSuffix} $_currentMonth',
                value: _rentPrice,
                isHighlight: true,
              ),
              if (_services.isNotEmpty) ...[
                Divider(height: AppHeight.h16, color: AppColors.surface),
                ..._services.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: AppPadding.p8),
                    child: InvoiceServiceRow(
                      icon: serviceIcon(s.name),
                      label:
                          s.type == BillingType.perPerson
                              ? '${s.name} (x$_membersCount)'
                              : s.name,
                      value:
                          s.type == BillingType.perPerson
                              ? s.price * _membersCount
                              : s.price,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppHeight.h16),

        InvoiceCard(
          icon: Icons.info_outline_rounded,
          iconColor: AppColors.primary,
          title: 'Trạng thái hóa đơn',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<InvoiceStatus>(
              value: _status,
              isExpanded: true,
              items:
                  InvoiceStatus.values
                      .where((s) => s != InvoiceStatus.notCreated)
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.label, style: manrope()),
                        ),
                      )
                      .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _status = v);
              },
            ),
          ),
        ),
        const SizedBox(height: AppHeight.h16),

        InvoiceCard(
          icon: Icons.edit_note_rounded,
          iconColor: AppColors.textSecondary,
          title: AppStrings.invoiceNotes,
          child: TextField(
            controller: _noteCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: AppStrings.invoiceNotesHint,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              filled: false,
            ),
          ),
        ),
        const SizedBox(height: AppHeight.h16),

        Container(
          padding: const EdgeInsets.all(AppPadding.p16),
          decoration: BoxDecoration(
            color: AppColors.surfaceBright,
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(color: AppColors.primaryLight, width: 1.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.invoiceTotalAmountToPay,
                      style: manrope(
                        fontSize: FontSize.s13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppHeight.h4),
                    Text(
                      fmtDouble(_total),
                      style: manrope(
                        fontSize: FontSize.s22,
                        fontWeight: FontWeightManager.extraBold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: AppSize.s44,
                height: AppSize.s44,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppHeight.h24),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.share_outlined),
                label: Text(AppStrings.invoiceExportBtn),
                onPressed: () {
                  if (_existingInvoice == null) {
                    ErrorDialog.show(
                      context,
                      message: AppStrings.invoiceMustSaveBeforeExport,
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => InvoiceExportPage(
                            invoice: _existingInvoice!,
                            room: _room!,
                            property: _property,
                            tenant: _tenant,
                            services: _services,
                            electricOld: _electricOld,
                            electricNew: _electricNew,
                            waterOld: _waterOld,
                            waterNew: _waterNew,
                          ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: AppPadding.p14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r50),
                  ),
                  side: BorderSide(color: AppColors.primary),
                  foregroundColor: AppColors.primary,
                ),
              ),
            ),
            SizedBox(width: AppWidth.w12),
            Expanded(
              child: ElevatedButton.icon(
                icon:
                    _isSaving
                        ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Icon(Icons.save_outlined),
                label: Text(
                  _existingInvoice != null
                      ? AppStrings.invoiceUpdateBtn
                      : AppStrings.invoiceSaveBtn,
                ),
                onPressed: _isSaving ? null : _saveInvoice,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.p14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r50),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppHeight.h32),
      ],
    );
  }
}
