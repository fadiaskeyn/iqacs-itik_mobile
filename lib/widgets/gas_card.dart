import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:inovokasi_rebuild/Theme.dart';

class GasCard extends StatelessWidget {
  final String title;
  final String kode;
  final double value;
  final Color color;

  const GasCard({
    required this.title,
    required this.kode,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: color, width: 0.1),
      ),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: blackTextStyle.copyWith(fontWeight: FontWeight.w400),
                ),
                const SizedBox(width: 30),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 140,
              width: 140,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    interval: 20,
                    startAngle: 0,
                    endAngle: 360,
                    showTicks: false,
                    showLabels: false,
                    axisLineStyle: AxisLineStyle(thickness: 20),
                    pointers: <GaugePointer>[
                      RangePointer(
                        value: value,
                        width: 20,
                        color: Color.fromARGB(237, 247, 177, 91),
                        enableAnimation: true,
                        cornerStyle: CornerStyle.bothCurve,
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                '${value.toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Text(
                              kode,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        angle: 270,
                        positionFactor: 0.1,
                      ),
                    ],
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
