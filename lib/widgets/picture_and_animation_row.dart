import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SamplePictureAndAnimationRow extends StatefulWidget {
  const SamplePictureAndAnimationRow({super.key});

  @override
  State<SamplePictureAndAnimationRow> createState() => _SamplePictureAndAnimationRowState();
}

class _SamplePictureAndAnimationRowState extends State<SamplePictureAndAnimationRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: ResponsiveValue(context, defaultValue: 200.0, valueWhen: const [Condition.smallerThan(name: MOBILE, value: 160.0)]).value,
          width: ResponsiveValue(context, defaultValue: 200.0, valueWhen: const [Condition.smallerThan(name: MOBILE, value: 160.0)]).value,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClayContainer(
              color: Theme.of(context).primaryColor,
              borderRadius: 10.0,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset('assets/bg-1.jpg', fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
