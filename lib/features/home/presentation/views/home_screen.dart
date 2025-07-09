import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsystemforschools/features/family/data/manager/add_child_cubit/add_child_cubit.dart';
import 'package:smartsystemforschools/features/payment_parent/data/cubit/parent_childs_transcations_cubit.dart';
import 'package:smartsystemforschools/features/payment_parent/presentation/widgets/transactions_list_widget.dart';
import '../../../../core/utils/Constants.dart';
import '../../../../core/widgets/build_loading_view.dart';
import '../../../payment_parent/presentation/screens/spare.dart';
import '../../../notification_view/presenation/views/notification_view.dart';
import '../../../payment/presentation/manager/cubit/payment_cubit.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../core/models/get_child_details/result.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/services/school_service/school_service.dart';
import '../../../settings/presentation/views/settings_view.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_balance_card_details.dart';
import '../widgets/custom_details_child_view.dart';
import 'dart:developer';

class HomeView extends StatefulWidget {
  static const String id = '/HomeView';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? parentName;
  List<ResultForChildDetails> childDetails = [];
  bool _isLoading = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    loadFamilyDetails();
    getUserInfo();
    loadBalance();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when the screen is shown
    loadFamilyDetails();
  }

  getUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    parentName = sharedPreferences.getString(Constants.username);
  }

  Future<void> loadBalance() async {
    context.read<PaymentCubit>().getBalance();
  }

  Future<void> loadFamilyDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final results = await SchoolService().getAllChildDetails();
      setState(() {
        childDetails.clear();
        childDetails.addAll(results);
        _isLoading = false;
      });
      log("Loaded ${results.length} children in HomeView");
      Future.wait([
        loadBalance(),
        loadTranscations(),
      ]);
    } catch (e) {
      log("Error loading children in HomeView: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteChild(ResultForChildDetails child, int index) async {
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Icon(
            Icons.info,
            color: Colors.orange,
            size: 60,
          ),
          content: Text(
            '${LocaleKeys.common_areYouSureYouWantToDelete.tr()} ${child.fullName}?',
            style: AppStyles.styleRegular14(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                LocaleKeys.common_Cancel.tr(),
                style: AppStyles.styleRegular14(),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(
                LocaleKeys.common_Delete.tr(),
                style: AppStyles.styleRegular14(),
              ),
            ),
          ],
        );
      },
    );
    if (shouldDelete == true) {
      setState(() {
        _isDeleting = true;
      });
      try {
        final result =
            await SchoolService().removeChild(id: child.id.toString());
        if (result['isSuccess'] == true) {
          // Remove from local list
          setState(() {
            childDetails.removeAt(index);
            _isDeleting = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                  LocaleKeys.common_ChildDeletedSuccessfully.tr(),
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
          loadFamilyDetails();
        } else {
          setState(() {
            _isDeleting = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                  result['message'] ??
                      LocaleKeys.common_ErrorDeletingChild.tr(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        setState(() {
          _isDeleting = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                LocaleKeys.common_ErrorDeletingChild.tr(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  DateTime selectedDate = DateTime.now();
  String formattedDate = '';
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade900,
              onPrimary: Colors.white,
              onSurface: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        formattedDate = DateFormat('yyyy/MM/dd').format(selectedDate);
      });
      loadTranscations(formattedDate);
    }
  }

  Future<void> loadTranscations([String? selectedDate]) async {
    await context
        .read<ParentChildsTranscationsCubit>()
        .fetchTransactions(date: formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey(context.locale.toString()),
      child: Scaffold(
        appBar: CustomAppBarHomeView(
          waveColor: Colors.blue,
          backgroundColor: Colors.blue.shade900,
          onTapPrefix: () {
            Navigator.of(context).pushNamed(SettingsHomeView.id);
          },
          onTapSuffix: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return KeyedSubtree(
                      key: ValueKey(context.locale.toString()),
                      child: (NotificationView(childDetails: childDetails)));
                },
              ),
            );
          },
        ),
        body: Stack(
          children: [
            RefreshIndicator(
              backgroundColor: Colors.white,
              color: Colors.blue.shade900,
              onRefresh: loadFamilyDetails,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 18, end: 19),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  clipBehavior: Clip.none,
                  slivers: [
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 15,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: BounceInDown(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return BlocBuilder<PaymentCubit, PaymentState>(
                                  builder: (context, state) {
                                    if (state is GetBalanceSuccess) {
                                      return AccountScreen(
                                        balance: state
                                            .getBalance.result!.amountOfMoney!,
                                        username: parentName.toString(),
                                      );
                                    } else {
                                      return AccountScreen(
                                        balance: 0.0,
                                        username: parentName.toString(),
                                      );
                                    }
                                  },
                                );
                              }),
                            );
                          },
                          child: const CustomBalanceCardDetails(),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 15,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Text(
                        LocaleKeys.homeView_family.tr(),
                        style: AppStyles.styleMedium20(),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 15,
                      ),
                    ),
                    _isLoading
                        ? SliverToBoxAdapter(
                            child: Center(
                                child: buildLoadingView(
                                    LocaleKeys.common_childs.tr(), context)),
                          )
                        : childDetails.isEmpty
                            ? SliverToBoxAdapter(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.family_restroom,
                                          size: 50,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          LocaleKeys.common_noChildrenAddedYet
                                              .tr(),
                                          style: AppStyles.styleRegular16(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : SliverList.builder(
                                itemCount: childDetails.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      bottom: index == childDetails.length - 1
                                          ? 0
                                          : 13),
                                  child: Slidable(
                                    key: ValueKey(childDetails[index].id),
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) => _deleteChild(
                                              childDetails[index], index),
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: LocaleKeys.common_Delete.tr(),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ],
                                    ),
                                    child: CustomDetailsChildView(
                                      index: index,
                                      childDetailsModel: childDetails[index],
                                    )
                                        .animate()
                                        .fadeIn(
                                            duration: 600.ms,
                                            delay: Duration(
                                                milliseconds: 150 * index))
                                        .slideX(
                                            begin: index % 2 == 0 ? .2 : -0.2,
                                            end: 0),
                                  ),
                                ),
                              ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 15,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.transactions_transactions.tr(),
                            style: AppStyles.styleMedium20(),
                          ),
                          MaterialButton(
                            color: Colors.blue[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            onPressed: () {
                              _selectDate(context);
                            },
                            child: Text(
                              LocaleKeys.transaction_date.tr(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 15,
                      ),
                    ),
                    const TransactionsListWidget(),
                  ],
                ),
              ),
            ),
            // Loading overlay while deleting
            if (_isDeleting)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
