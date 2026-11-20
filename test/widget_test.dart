import 'package:flutter_test/flutter_test.dart';

import 'package:student_management_app/main.dart';

void main() {
  testWidgets('renders the student manager app', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentManagementApp());

    expect(find.text('Student Manager'), findsOneWidget);
  });
}
