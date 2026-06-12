class PainEntry {
  final int? id;
  final DateTime date;
  final int painScore; // 1-10
  final String painLocation;
  final List<String> triggers;
  final String notes;

  PainEntry({
    this.id,
    required this.date,
    required this.painScore,
    this.painLocation = '',
    this.triggers = const [],
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'date': date.toIso8601String(),
      'painScore': painScore,
      'painLocation': painLocation,
      'triggers': triggers.join(','),
      'notes': notes,
    };
  }

  factory PainEntry.fromMap(Map<String, dynamic> map) {
    return PainEntry(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      painScore: map['painScore'] as int,
      painLocation: map['painLocation'] as String? ?? '',
      triggers: (map['triggers'] as String?)?.isNotEmpty == true
          ? (map['triggers'] as String).split(',')
          : [],
      notes: map['notes'] as String? ?? '',
    );
  }

  static const List<String> availableTriggers = [
    'Long sitting',
    'Bad sleep',
    'Heavy lifting',
    'Exercise',
    'Stress',
    'Cold weather',
    'Standing too long',
    'Driving',
    'Bending',
    'Unknown',
  ];
}
