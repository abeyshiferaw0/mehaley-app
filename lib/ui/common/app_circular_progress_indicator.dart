import 'package:flutter/material.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AppCircularProgressIndicator extends StatelessWidget {
  const AppCircularProgressIndicator(
      {Key? key, required this.progress, required this.color})
      : super(key: key);

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 100,
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            axisLineStyle: AxisLineStyle(
              thickness: 0.05,
              color: color,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: progress,
                width: 0.95,
                pointerOffset: 0.05,
                color: ColorUtil.darken(color, 0.02),
                sizeUnit: GaugeSizeUnit.factor,
              )
            ],
          )
        ],
      ),
    );
  }
}
