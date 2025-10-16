import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DishInfo extends StatefulWidget {
  final String name;
  final String description;

  const DishInfo({required this.name, required this.description, super.key});

  @override
  State<DishInfo> createState() => _DishInfoState();
}

class _DishInfoState extends State<DishInfo> {
  bool _isExpanded = false;
  final int _maxLines = 6; // 👈 عدد السطور قبل ظهور See More

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final description =
        widget.description.isNotEmpty
            ? widget.description
            : loc.noDescriptionAvailable;

    return Directionality(
      textDirection: Directionality.of(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textPainter = TextPainter(
            text: TextSpan(
              text: description,
              style: TextStyle(fontSize: 16.sp, color: Colors.black54),
            ),
            maxLines: _maxLines,
            textDirection: Directionality.of(context),
          );
          textPainter.layout(maxWidth: constraints.maxWidth);
          final isTextOverflowing = textPainter.didExceedMaxLines;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🟧 اسم الطبق
              Text(
                widget.name,
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5.h),

              // 🟩 الوصف
              Text(
                description,
                style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                maxLines: _isExpanded ? null : _maxLines,
                overflow:
                    _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),

              // 🟦 زر عرض المزيد / عرض أقل
              if (isTextOverflowing)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      setState(() => _isExpanded = !_isExpanded);
                    },
                    icon: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: Colors.orange,
                      size: 18.sp,
                    ),
                    label: Text(
                      _isExpanded ? loc.seeLess : loc.seeMore,
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
