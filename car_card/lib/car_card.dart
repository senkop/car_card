import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Device {
  final String name;
  final LastRow lastRow;

  Device({required this.name, required this.lastRow});
}

class LastRow {
  final bool? ignition;
  final String? status;
  final int? time;

  LastRow({this.ignition, this.status, this.time});
}

class DeviceCard extends StatelessWidget {
  final Device device;
  final Function onTap;

  const DeviceCard({
    required this.device,
    required this.onTap,
  });

  String formatEpochToHumanReadable(int epochSeconds) {
    final now = DateTime.now();
    final dateTime = DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000);
    final duration = now.difference(dateTime);

    return formatDuration(duration);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight * 0.8,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE0E0E0), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 15,
                  right: 8,
                  child: device.lastRow.ignition == true
                      ? _buildStatusContainer(device.lastRow.status ?? 'unknown')
                      : Container(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50.h),
                    Center(
                      child: Image.asset(
                        'assets/icons/carCard2.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                width: 18,
                                height: 18,
                                padding: const EdgeInsets.all(4),
                                decoration: ShapeDecoration(
                                  color: device.lastRow.ignition ?? false
                                      ? const Color(0xFFDBF0DC)
                                      : const Color(0xFFFFCDD2),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1, color: Color(0xFFCCEECD)),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: device.lastRow.ignition ?? false
                                          ? const Color(0xFF2E6B30)
                                          : const Color(0xFFD32F2F),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Text(device.name),
                          ]),
                          const SizedBox(height: 8),
                          Text(
                            'Last seen: ${formatDuration(Duration(milliseconds: device.lastRow.time ?? 0))}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: const Text(
                              'More Details >',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusContainer(String status) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    String displayText;

    switch (status) {
      case 'moving':
        backgroundColor = const Color(0xFFECFCF2);
        borderColor = const Color.fromARGB(255, 170, 239, 210);
        textColor = const Color(0xFF057647);
        displayText = 'Moving';
        break;
      case 'idling':
        backgroundColor = const Color(0xFFFFFAEE);
        borderColor = const Color(0xFFFFF1C9);
        textColor = const Color(0xFFDD984A);
        displayText = 'Idling';
        break;
      case 'parking':
        backgroundColor = const Color(0xFFE5F3FF);
        borderColor = const Color.fromARGB(255, 11, 91, 212);
        textColor = const Color(0xFF0B6FD4);
        displayText = 'Parking';
        break;
      case 'towed':
        backgroundColor = const Color(0xFFF2F2F2);
        borderColor = Colors.black;
        textColor = const Color(0xFF4D4D4D);
        displayText = 'Towed';
        break;
      default:
        backgroundColor = const Color(0xFFE5F3FF);
        borderColor = const Color.fromARGB(255, 11, 91, 212);
        textColor = const Color(0xFF0B6FD4);
        displayText = 'Parking';
        break;
    }

    return Container(
      width: 60.w,
      height: 24.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: borderColor),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            displayText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 12.sp,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    if (duration.inMilliseconds == 0) {
      return 'Pending';
    }

    if (duration.inDays >= 365) {
      int years = (duration.inDays / 365).floor();
      return '$years ${years > 1 ? 'years' : 'year'} ago';
    } else if (duration.inDays >= 30) {
      int months = (duration.inDays / 30).floor();
      return '$months ${months > 1 ? 'months' : 'month'} ago';
    } else if (duration.inDays >= 1) {
      return '${duration.inDays} ${duration.inDays > 1 ? 'days' : 'day'} ago';
    } else if (duration.inHours >= 1) {
      return '${duration.inHours} ${duration.inHours > 1 ? 'hours' : 'hour'} ago';
    } else if (duration.inMinutes >= 1) {
      return '${duration.inMinutes} ${duration.inMinutes > 1 ? 'minutes' : 'minute'} ago';
    } else {
      return '${duration.inSeconds} ${duration.inSeconds > 1 ? 'seconds' : 'second'} ago';
    }
  }
}