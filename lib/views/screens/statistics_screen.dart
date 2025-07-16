// lib/screens/statistics_screen.dart
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool _showWeeklyChart = false;

  @override
  Widget build(BuildContext context) {
    // Temporary placeholder values
    final int tasksCompletedToday = 5;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Completion (Last 7 Days)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // Placeholder bar chart for daywise completion
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Center(child: Text('Bar Chart Placeholder')),
            ),

            const SizedBox(height: 24),

            Text(
              'You completed $tasksCompletedToday tasks today',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 24),

            // Toggle button
            ListTile(
              title: const Text('Show Weekly Breakdown'),
              trailing: Icon(
                _showWeeklyChart ? Icons.expand_less : Icons.expand_more,
              ),
              onTap: () {
                setState(() {
                  _showWeeklyChart = !_showWeeklyChart;
                });
              },
            ),

            // Expandable weekly bar chart
            if (_showWeeklyChart) ...[
              const SizedBox(height: 12),
              Container(
                height: 150,
                width: double.infinity,
                color: Colors.blue[100],
                child: const Center(child: Text('Weekly Bar Chart Placeholder')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
