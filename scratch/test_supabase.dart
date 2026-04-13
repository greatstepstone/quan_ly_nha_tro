import 'package:supabase/supabase.dart';

void main() async {
  final supabase = SupabaseClient(
    'https://rliehmqaahnvpdtxptkx.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJsaWVobXFhYWhudnBkdHhwdGt4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzYwMDU2MzEsImV4cCI6MjA5MTU4MTYzMX0.oXST4v6553-0Kk-lR9uopM1zMuCikDeX9PK_HXaYEeE',
  );

  print('Testing Supabase Connection...');

  try {
    // Try to list tables (or just select from properties if exists)
    final response = await supabase
        .from('properties')
        .select()
        .limit(1);
    
    print('Connection Successful!');
    print('Data sample: $response');
  } catch (e) {
    print('Connection Failed!');
    print('Error: $e');
  }
}
