import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterProvider = StateProvider<String>((ref) => '');
final sortProvider = StateProvider<String>((ref) => 'none');