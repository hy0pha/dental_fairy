import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<dynamic> _events = [];
  List<dynamic> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('images')
        .orderBy('timestamp', descending: true) // 타임스탬프를 기준으로 내림차순 정렬
        .get();

    List<dynamic> events = [];
    for (var doc in snapshot.docs) {
      final data = doc.data();
      data['id'] = doc.id;
      events.add(data);
    }

    setState(() {
      _events = events;
    });
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events
        .where((event) {
      final timestamp = event['timestamp'] as Timestamp;
      final eventDate = DateTime(timestamp.toDate().year, timestamp.toDate().month, timestamp.toDate().day);
      return isSameDay(eventDate, day);
    })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final textColor = Color(0xff6eb1d9);

    return Scaffold(
      backgroundColor: Color(0xffe0f7fa), // 배경색 변경
      appBar: AppBar(
        backgroundColor: Color(0xffe0f7fa), // 배경색 변경
        title: Text('지난 기록', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents = _getEventsForDay(selectedDay);
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(color: textColor), // 일반 텍스트 색상 변경
              weekendTextStyle: TextStyle(color: textColor), // 주말 텍스트 색상 변경
              holidayTextStyle: TextStyle(color: textColor), // 공휴일 텍스트 색상 변경
              markerDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              titleTextStyle: TextStyle(color: textColor), // 헤더 텍스트 색상 변경
              formatButtonTextStyle: TextStyle(color: textColor),
              formatButtonDecoration: BoxDecoration(
                border: Border.all(color: textColor), // 포맷 버튼 테두리 색상 변경
                borderRadius: BorderRadius.circular(12),
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: textColor),
              rightChevronIcon: Icon(Icons.chevron_right, color: textColor),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: textColor), // 요일 텍스트 색상 변경
              weekendStyle: TextStyle(color: textColor), // 주말 요일 텍스트 색상 변경
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedEvents.length,
              itemBuilder: (context, index) {
                final event = _selectedEvents[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      Container(
                        width: screenSize.width * 0.3, // 반응형 너비 설정
                        height: screenSize.width * 0.3, // 반응형 높이 설정
                        child: Image.network(event['url'], fit: BoxFit.cover),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          event['output'] ? '양치가 제대로 되지 않은 부분이 있습니다.' : '치아 건강 위험이\n발견되지 않았습니다.',
                          style: TextStyle(fontSize: screenSize.width * 0.05, color: textColor),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RecordPage(),
  ));
}
