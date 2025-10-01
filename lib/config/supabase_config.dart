class SupabaseConfig {
  // Supabase project URL and anon key
  static const String supabaseUrl = 'https://jkqeyiubmgfhvjvkmbwd.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImprcWV5aXVibWdmaHZqdmttYndkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkyNjA5MDMsImV4cCI6MjA3NDgzNjkwM30.44S7-nCCzaTeDKuu7alq-IkFK35jtRAfRxXb1DkYTcs';
  
  // You can also add other configuration options here
  static const String supabaseSchema = 'public';
  static const Duration timeoutDuration = Duration(seconds: 30);
}
