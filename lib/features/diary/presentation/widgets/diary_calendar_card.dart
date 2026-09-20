import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../domain/calendar_math.dart' as calendar_math;

const List<String> _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const List<String> _weekdayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

/// A collapsible calendar: a week-strip by default, expandable into a full
/// month grid. Picking a date always collapses back to the week-strip,
/// scrolled to that date's week.
class DiaryCalendarCard extends StatefulWidget {
  const DiaryCalendarCard({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.loggedDates,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  /// Day-only normalized dates that have at least one logged entry, used to
  /// show a dot indicator.
  final Set<DateTime> loggedDates;

  @override
  State<DiaryCalendarCard> createState() => _DiaryCalendarCardState();
}

class _DiaryCalendarCardState extends State<DiaryCalendarCard> {
  bool _expanded = false;
  int _weekOffset = 0;
  int _monthOffset = 0;

  DateTime get _today => DateUtils.dateOnly(DateTime.now());

  DateTime get _displayedWeekStart =>
      calendar_math.startOfWeek(_today).add(Duration(days: _weekOffset * 7));

  DateTime get _displayedMonthAnchor =>
      DateTime(_today.year, _today.month + _monthOffset, 1);

  int _weeksBetween(DateTime a, DateTime b) =>
      calendar_math
          .startOfWeek(b)
          .difference(calendar_math.startOfWeek(a))
          .inDays ~/
      7;

  void _goPrev() {
    setState(() {
      if (_expanded) {
        _monthOffset -= 1;
      } else {
        _weekOffset -= 1;
      }
    });
  }

  void _goNext() {
    setState(() {
      if (_expanded) {
        _monthOffset += 1;
      } else {
        _weekOffset += 1;
      }
    });
  }

  void _toggleExpanded() {
    setState(() {
      if (!_expanded) {
        final weekStart = _displayedWeekStart;
        _monthOffset =
            (weekStart.year - _today.year) * 12 +
            (weekStart.month - _today.month);
        _expanded = true;
      } else {
        _weekOffset = _weeksBetween(_today, widget.selectedDate);
        _expanded = false;
      }
    });
  }

  void _pickDate(DateTime date) {
    widget.onDateSelected(date);
    setState(() {
      _weekOffset = _weeksBetween(_today, date);
      _expanded = false;
    });
  }

  bool _isSelected(DateTime date) =>
      DateUtils.isSameDay(date, widget.selectedDate);

  bool _isToday(DateTime date) => DateUtils.isSameDay(date, _today);

  bool _hasEntries(DateTime date) =>
      widget.loggedDates.contains(DateUtils.dateOnly(date));

  @override
  Widget build(BuildContext context) {
    final headerDate = _expanded ? _displayedMonthAnchor : _displayedWeekStart;
    final monthLabel = '${_monthNames[headerDate.month - 1]} ${headerDate.year}';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: DashboardColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _NavButton(icon: Icons.chevron_left, onTap: _goPrev),
              Expanded(
                child: _MonthButton(
                  label: monthLabel,
                  expanded: _expanded,
                  onTap: _toggleExpanded,
                ),
              ),
              _NavButton(icon: Icons.chevron_right, onTap: _goNext),
            ],
          ),
          const SizedBox(height: 10),
          if (_expanded) _buildMonthGrid() else _buildWeekStrip(),
        ],
      ),
    );
  }

  Widget _buildWeekStrip() {
    final dates = calendar_math.weekDates(_displayedWeekStart);
    return Row(
      children: [
        for (var i = 0; i < dates.length; i++)
          Expanded(
            child: _WeekDayChip(
              date: dates[i],
              letter: _weekdayLetters[i],
              isToday: _isToday(dates[i]),
              isSelected: _isSelected(dates[i]),
              hasEntries: _hasEntries(dates[i]),
              onTap: () => _pickDate(dates[i]),
            ),
          ),
      ],
    );
  }

  Widget _buildMonthGrid() {
    final anchor = _displayedMonthAnchor;
    final dates = calendar_math.monthGridDates(anchor);
    return Column(
      children: [
        Row(
          children: [
            for (final letter in _weekdayLetters)
              Expanded(
                child: Text(
                  letter,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: DashboardColors.textMuted,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            for (final date in dates)
              _MonthDayCell(
                date: date,
                inMonth: date.month == anchor.month,
                isToday: _isToday(date),
                isSelected: _isSelected(date),
                hasEntries: _hasEntries(date),
                onTap: () => _pickDate(date),
              ),
          ],
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(icon, size: 20, color: DashboardColors.textSecondary),
        ),
      ),
    );
  }
}

class _MonthButton extends StatelessWidget {
  const _MonthButton({
    required this.label,
    required this.expanded,
    required this.onTap,
  });

  final String label;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: DashboardColors.textPrimary,
                ),
              ),
              const SizedBox(width: 5),
              AnimatedRotation(
                turns: expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 150),
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: DashboardColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EntryDot extends StatelessWidget {
  const _EntryDot({required this.visible, required this.color});

  final bool visible;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 4,
      height: 4,
      child: visible
          ? DecoratedBox(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            )
          : null,
    );
  }
}

class _WeekDayChip extends StatelessWidget {
  const _WeekDayChip({
    required this.date,
    required this.letter,
    required this.isToday,
    required this.isSelected,
    required this.hasEntries,
    required this.onTap,
  });

  final DateTime date;
  final String letter;
  final bool isToday;
  final bool isSelected;
  final bool hasEntries;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final letterColor = isSelected
        ? DashboardColors.gaugeCardBackground
        : DashboardColors.textMuted;
    final numberColor = isSelected
        ? DashboardColors.surface
        : DashboardColors.textPrimary;
    final dotColor = isSelected ? DashboardColors.surface : DashboardColors.primary;

    return Material(
      color: isSelected ? DashboardColors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: isToday && !isSelected
                ? Border.all(color: DashboardColors.primary, width: 1.5)
                : null,
          ),
          child: Column(
            children: [
              Text(
                letter,
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: letterColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${date.day}',
                style: GoogleFonts.roboto(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: numberColor,
                ),
              ),
              const SizedBox(height: 2),
              _EntryDot(visible: hasEntries, color: dotColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthDayCell extends StatelessWidget {
  const _MonthDayCell({
    required this.date,
    required this.inMonth,
    required this.isToday,
    required this.isSelected,
    required this.hasEntries,
    required this.onTap,
  });

  final DateTime date;
  final bool inMonth;
  final bool isToday;
  final bool isSelected;
  final bool hasEntries;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final numberColor = isSelected
        ? DashboardColors.surface
        : inMonth
        ? DashboardColors.textPrimary
        : const Color(0xFFC7C2AC);
    final dotColor = isSelected ? DashboardColors.surface : DashboardColors.primary;

    return Material(
      color: isSelected ? DashboardColors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isToday && !isSelected
                ? Border.all(color: DashboardColors.primary, width: 1.5)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${date.day}',
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: numberColor,
                ),
              ),
              const SizedBox(height: 2),
              _EntryDot(
                visible: hasEntries && inMonth,
                color: dotColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
