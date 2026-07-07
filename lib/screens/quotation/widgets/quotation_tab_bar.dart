import 'package:flutter/material.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/quotation/widgets/other_info.dart';
import 'package:mobo_crm/screens/quotation/widgets/product_screen.dart';
import 'package:mobo_crm/screens/quotation/widgets/quote_builder.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_form_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotebuilder_provider.dart';
import 'package:mobo_crm/screens/quotation/widgets/signature.dart';
import 'package:provider/provider.dart';

/// Scrollable tab bar that navigates between the sections of the quotation form.
class QuotationTabBar extends StatefulWidget {
  const QuotationTabBar({super.key});

  @override
  _QuotationTabBarState createState() => _QuotationTabBarState();
}

class _QuotationTabBarState extends State<QuotationTabBar> {
  final ScrollController _tabScrollController = ScrollController();
  TabController? _tabController;
  List<GlobalKey> _tabKeys = [];
  int _lastScrolledIndex = -1;

  @override
  void dispose() {
    _tabScrollController.dispose();
    _tabController?.removeListener(_onTabChanged);
    _tabController?.animation?.removeListener(_onAnimationChanged);
    super.dispose();
  }

  void _attachController(TabController controller, int tabCount) {
    if (_tabController == controller) return;
    _tabController?.removeListener(_onTabChanged);
    _tabController?.animation?.removeListener(_onAnimationChanged);
    _tabController = controller;
    controller.addListener(_onTabChanged);
    controller.animation?.addListener(_onAnimationChanged);
  }

  void _onAnimationChanged() {
    if (_tabController == null || !mounted) return;
    final roundedIndex = _tabController!.animation!.value.round();
    if (roundedIndex != _lastScrolledIndex) {
      _lastScrolledIndex = roundedIndex;
      _scrollToTab(roundedIndex);
    }
  }

  void _onTabChanged() {
    if (_tabController == null || !mounted) return;
    if (_tabController!.indexIsChanging) return;
    _scrollToTab(_tabController!.index);
  }

  void _scrollToTab(int index) {
    if (!mounted || index >= _tabKeys.length) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final key = _tabKeys[index];
      final context = key.currentContext;
      if (context == null) return;
      final renderObject = context.findRenderObject();
      if (renderObject != null && _tabScrollController.hasClients) {
        _tabScrollController.position.ensureVisible(
          renderObject,
          alignment: 0.5,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<QuotationFormProvider, QuotationViewProvider,
            OdooClientManager, QuoteBuilderProvider>(
        builder: (context, quotationformprovider, quotationviewprovider,
            clientprovider, quotebuilderprovider, child) {
      final isSaleManagementInstalled =
          quotationformprovider.isSaleManagementInstalled;

      final tabs = isSaleManagementInstalled
          ? [
              "Order Lines",
              "Quote Builder",
              "Other Info",
              "Optional Products",
              "Signature",
            ]
          : [
              "Order Lines",
              "Other Info",
              "Signature",
            ];

      if (_tabKeys.length != tabs.length) {
        _tabKeys = List.generate(tabs.length, (_) => GlobalKey());
      }

      return DefaultTabController(
        key: ValueKey(tabs.length),
        length: tabs.length,
        child: Builder(builder: (context) {
          final tabController = DefaultTabController.of(context);
          if (tabController == null) return const SizedBox.shrink();

          _attachController(tabController, tabs.length);

          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 12),
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    controller: _tabScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    itemCount: tabs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: tabController.animation!,
                        builder: (context, _) {
                          final activeIndex =
                              tabController.animation!.value.round();
                          return GestureDetector(
                            key: _tabKeys[index],
                            onTap: () {
                              tabController.animateTo(index);
                              quotationformprovider.indexSelection(index);
                              _scrollToTab(index);
                            },
                            child: _buildPillTab(
                              context: context,
                              label: tabs[index],
                              isSelected: activeIndex == index,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height < 700 ? 12 : 24,
                  ),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification) {
                        quotationformprovider
                            .indexSelection(tabController.index);
                      }
                      return false;
                    },
                    child: TabBarView(
                      children: isSaleManagementInstalled
                          ? [
                              MainScreen(),
                              QuoteBuilderWidget(),
                              OtherInfoScreen(),
                              OPtionalProductScreen(),
                              SignatureWidget(),
                            ]
                          : [
                              MainScreen(),
                              OtherInfoScreen(),
                              SignatureWidget(),
                            ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      );
    });
  }

  Widget _buildPillTab({
    required BuildContext context,
    required String label,
    required bool isSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.black
            : (isDark ? Colors.grey[800] : Colors.white),
        border: Border.all(
          color: isSelected
              ? Colors.black
              : (isDark ? Colors.grey[600]! : Colors.grey[300]!),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.grey[400] : Colors.grey[700]),
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
