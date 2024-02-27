import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/bar graph/individual_bar.dart';
class MyBarGraph extends StatefulWidget {
  final List<double> monthlySummary;
  final int startMonth;
  const MyBarGraph({super.key, required this.monthlySummary, required this.startMonth});

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  List<IndividualBar> barData = [];

  void initializeBarData(){
    barData = List.generate(widget.monthlySummary.length, (index) => IndividualBar(x: index, y: widget.monthlySummary[index]));
  }

  @override
  Widget build(BuildContext context) {

    initializeBarData();

    double barWidth = 20;
    double spaceBetweensBar =   15;

    double calculateMax(){
      double max = 500;
      widget.monthlySummary.sort();
      max = widget.monthlySummary.last * 1.05;

      if( max < 500){
        return max;
      }
      return max;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: SizedBox(
          width: barWidth*barData.length + spaceBetweensBar*(barData.length - 1),
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: calculateMax(),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(
                show:  true,
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false)
                ),
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false)
                ),
                rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false)
                ),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: getBottomTitles,
                        reservedSize: 30

                    ),

                ),
              ),
              barGroups: barData.map(
                  (data)=>BarChartGroupData(
                    x: data.x,
                    barRods: [
                      BarChartRodData(
                          toY: data.y,
                          width: barWidth,
                          borderRadius: BorderRadius.circular(4),
                          color:Colors.grey.shade800,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: calculateMax(),
                            color: Colors.white
                          )
                      )
                    ]
                  )
              ).toList(),
              alignment: BarChartAlignment.center,
              groupsSpace: spaceBetweensBar

            )
          ),
        ),
      ),
    );
  }

}

Widget getBottomTitles(double value, TitleMeta meta){
  const textStyle = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 16
  );
  String text;
  switch(value.toInt() % 12){
    case 0:
      text = 'O';
      break;
    case 1:
      text = 'Ş';
      break;
    case 2:
      text = 'M';
      break;
    case 3:
      text = 'N';
      break;
    case 4:
      text = 'M';
      break;
    case 5:
      text = 'H';
      break;
    case 6:
      text = 'T';
      break;
    case 7:
      text = 'A';
      break;
    case 8:
      text = 'E';
      break;
    case 9:
      text = 'E';
      break;
    case 10:
      text = 'K';
      break;
    case 11:
      text = 'A';
      break;
    default:
      text = '';
      break;
  }

  return SideTitleWidget(child: Text(text, style: textStyle,), axisSide: meta.axisSide);
}