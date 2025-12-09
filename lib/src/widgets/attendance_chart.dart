import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttendanceChart extends StatelessWidget {
  final int hadir;
  final int belum;

  const AttendanceChart({super.key, required this.hadir, required this.belum});

  @override
  Widget build(BuildContext context) {
    final total = hadir + belum;
    final hadirPercent = total == 0 ? 0.0 : (hadir / total) * 100.0;
    final belumPercent = total == 0 ? 0.0 : (belum / total) * 100.0;

    return Column(
      children: [
        const SizedBox(height: 10),

        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 55,
              sectionsSpace: 2,
              startDegreeOffset: -90,
              sections: [
                PieChartSectionData(
                  value: hadirPercent.toDouble(),
                  color: CupertinoColors.activeGreen,
                  title: "${hadirPercent.toStringAsFixed(1)}%",
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  value: belumPercent.toDouble(),
                  color: CupertinoColors.systemRed,
                  title: "${belumPercent.toStringAsFixed(1)}%",
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Legend ala iOS
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendItem(CupertinoColors.activeGreen, "Sudah Hadir: $hadir"),
            const SizedBox(width: 20),
            _legendItem(CupertinoColors.systemRed, "Belum Hadir: $belum"),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 15, color: CupertinoColors.label),
        ),
      ],
    );
  }
}
