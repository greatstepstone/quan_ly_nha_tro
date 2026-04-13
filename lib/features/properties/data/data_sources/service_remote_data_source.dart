import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/models/models.dart';

class ServiceRemoteDataSource {
  final SupabaseClient _client;

  ServiceRemoteDataSource(this._client);

  Future<List<Service>> getServicesByProperty(String propertyId) async {
    final response = await _client
        .from('services')
        .select()
        .eq('property_id', propertyId);
    
    return (response as List).map((json) => _mapToService(json)).toList();
  }

  Future<void> upsertService(Service service) async {
    await _client.from('services').upsert(_mapFromService(service));
  }

  Service _mapToService(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      propertyId: json['property_id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      type: BillingType.values.firstWhere((e) => e.toString() == 'BillingType.${json['type']}'),
    );
  }

  Map<String, dynamic> _mapFromService(Service s) {
    return {
      'id': s.id,
      'property_id': s.propertyId,
      'name': s.name,
      'price': s.price,
      'type': s.type.toString().split('.').last,
    };
  }
}
