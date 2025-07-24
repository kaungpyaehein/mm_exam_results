import 'package:flutter/material.dart';
import 'package:mm_exam/view/regions_details_page.dart';
import '../data/api_service.dart';
import '../data/year_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<YearModel>> _yearsFuture;

  @override
  void initState() {
    super.initState();
    _loadYears();
  }

  void _loadYears() {
    _yearsFuture = ApiService.getExamYears();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          "MM Matriculation Exam Results",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<YearModel>>(
        future: _yearsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }

          final years = snapshot.data ?? [];

          if (years.isEmpty) {
            return _buildEmptyState();
          }

          return _buildYearsList(years);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.green, strokeWidth: 3),
          SizedBox(height: 24),
          Text(
            "Loading exam years...",
            style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            ),
            const SizedBox(height: 24),
            Text(
              "Failed to load exam years",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red[700]),
            ),
            const SizedBox(height: 12),
            Text(
              "Please check your internet connection and try again",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _loadYears();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Try Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.calendar_today, size: 48, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          Text(
            "No exam years available",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          Text("No exam years found", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildYearsList(List<YearModel> years) {
    // Check if 2025 exists in the years list
    final bool has2025 = years.any((year) => year.year == 2025);

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _loadYears();
        });
        await _yearsFuture;
      },
      color: Colors.green,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: years.length + (!has2025 ? 1 : 0), // Add 1 if 2025 doesn't exist
        itemBuilder: (context, index) {
          // Show 2025 coming soon card first if it doesn't exist
          if (!has2025 && index == 0) {
            return Padding(padding: const EdgeInsets.only(bottom: 12), child: _build2025ComingSoonCard());
          }

          // Adjust index for regular cards when 2025 coming soon card is shown
          final yearIndex = !has2025 ? index - 1 : index;
          final yearModel = years[yearIndex];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: YearCard(yearModel: yearModel, onTap: () => _handleCardTap(context, yearModel)),
          );
        },
      ),
    );
  }

  Widget _build2025ComingSoonCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green, width: 2),
        gradient: LinearGradient(
          colors: [Colors.green.withOpacity(0.1), Colors.green.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Results not available yet"),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(16),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "2025",
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.green[700]),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(16)),
                            child: Text(
                              "Coming Soon",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text("Exam results will be available soon", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.green[600])),
                    ],
                  ),
                ),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 3))],
                  ),
                  child: Icon(Icons.access_time_rounded, color: Colors.green[700], size: 28),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleCardTap(BuildContext context, YearModel yearModel) {
    if (yearModel.year == 2025) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Results not available yet"),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => RegionsPage(yearModel: yearModel)));
    }
  }
}

class YearCard extends StatelessWidget {
  final YearModel yearModel;
  final VoidCallback onTap;

  const YearCard({super.key, required this.yearModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = yearModel.regions.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: !isAvailable ? Border.all(color: Colors.green, width: 2, style: BorderStyle.solid) : null,
      ),
      child: Material(
        color: !isAvailable ? Colors.green.withOpacity(0.1) : Colors.green,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            yearModel.year.toString(),
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: !isAvailable ? Colors.green[700] : Colors.white),
                          ),
                          if (!isAvailable) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                "Coming Soon",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${yearModel.regions.length} Regions Available",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: !isAvailable ? Colors.green[600] : Colors.white.withOpacity(0.9)),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Icon(
                    !isAvailable ? Icons.access_time_rounded : Icons.chevron_right_rounded,
                    color: !isAvailable ? Colors.green : Colors.green[700],
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
