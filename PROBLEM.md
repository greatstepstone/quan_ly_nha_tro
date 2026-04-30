# Summary of Issues by Priority

| Problem | Priority |
| :--- | :--- |
| Incomplete Offline-First Implementation (Data Loss Risk) | Critical |
| Potential Crash in `meter_reading_dao.dart` | High |
| Flawed Deletion Strategy (No soft delete) | High |
| Separation of Concerns in `property_dao.dart` | Medium |
| Inconsistent Error Handling during Sync | Medium |
| Hardcoded Navigation Routes | Medium |
| "Fat" UI Pages (God Widgets) | Medium |
| Missing Standard CRUD Operation in `user_dao.dart` | Low |
| Business Logic in Data Layer | Low |
| Architectural Inconsistency in AuthRepository | Low |
| Inefficient Data Loading in Forms | Low |
| Inconsistent Conflict Handling Across DAOs | Minor |

---

# Database DAOs Review - Identified Problems & Improvements

Based on the review of all files in `lib/core/database/daos`, here are the potential problems, bugs, and architectural improvements to address.

## 1. High Priority: Potential Crash in `meter_reading_dao.dart`
**Issue**: The method `getMeterReadingByRoomId` uses `.getSingleOrNull()` on a query that filters only by `roomId`. 
```dart
// Current implementation
Future<MeterReading?> getMeterReadingByRoomId(String roomId) => 
  (select(meterReadings)..where((t) => t.roomId.equals(roomId))).getSingleOrNull();
```
Because a single room will have multiple meter readings over time (e.g., month over month), this query will return multiple rows. When `.getSingleOrNull()` receives more than one row, it **throws a `StateError` ("Too many elements")**, causing the app to crash.

**Proposed Fix**: If the intent is to get the *latest* meter reading for a room, you should order the results and apply a `limit(1)`:
```dart
Future<MeterReading?> getLatestMeterReadingByRoomId(String roomId) => 
  (select(meterReadings)
    ..where((t) => t.roomId.equals(roomId))
    ..orderBy([(t) => OrderingTerm(expression: t.month, mode: OrderingMode.desc)]) // Adjust ordering based on your schema
    ..limit(1)
  ).getSingleOrNull();
```

## 2. Medium Priority: Separation of Concerns in `property_dao.dart`
**Issue**: The `PropertyDao` currently manages operations for both the `Properties` table and the `Services` table. 
```dart
@DriftAccessor(tables: [Properties, Services])
class PropertyDao extends DatabaseAccessor<AppDatabase> with _$PropertyDaoMixin {
  // ... property methods ...

  // Services
  Future<List<Service>> getServicesByProperty(String propertyId) => ...
  // ... other service methods ...
}
```
While this works since services are closely related to properties, it violates the Single Responsibility Principle. If the `Services` table grows in complexity or requires more complex queries, this file will become bloated.

**Proposed Improvement**: Extract the `Services` operations into a dedicated `service_dao.dart` file.

## 3. Low Priority: Missing Standard CRUD Operation in `user_dao.dart`
**Issue**: The `user_dao.dart` provides `getAllUsers`, `insertUser`, `updateUser`, and `deleteUser`, but it lacks a `getUserById` method.

**Proposed Improvement**: Add the missing lookup method for completeness, as it will likely be needed to fetch the current user's profile from the local DB:
```dart
Future<User?> getUserById(String id) => 
  (select(users)..where((t) => t.id.equals(id))).getSingleOrNull();
```

## 4. Minor Improvement: Inconsistent Conflict Handling Across DAOs
**Issue**: When inserting new records, different DAOs handle conflicts differently:
- `property_dao.dart` and `room_dao.dart` use `.insertOnConflictUpdate()`.
- `tenant_dao.dart`, `invoice_dao.dart`, `meter_reading_dao.dart`, and `user_dao.dart` use `.insert()`.

**Proposed Improvement**: Given the application has offline synchronization (as seen by `isSynced` in properties), you might want to standardize on `.insertOnConflictUpdate()` across all entities that will be synced from Supabase to prevent `UniqueKeyFailure` exceptions when pulling existing data to the local Drift database.

---

# Data Repositories Review - Identified Problems & Improvements

Based on the review of all implementation files in `lib/features/.../data/repositories`, here are the identified issues:

## 1. Critical: Incomplete Offline-First Implementation
**Issue**: The application appears to use an offline-first architecture, but only `Property` implements the `isSynced` flag and logic. Other entities like `Room`, `Tenant`, `Invoice`, and `MeterReading` lack this flag.
- When creating these entities offline, they are saved locally, but the remote sync call throws an error.
- Because there is no `isSynced` flag, the app never knows which records need to be synced when the connection is restored.
- **Data Loss Risk**: In `RoomRepositoryImpl.syncAllRooms()`, the code deletes local rooms that are not present on the remote server:
  ```dart
  for (var lr in localData) {
    if (!remoteIds.contains(lr.id)) {
      await localDataSource.deleteRoom(lr.id); // Deletes unsynced offline rooms!
    }
  }
  ```
**Proposed Fix**: Implement an `isSynced` flag for all tables in Drift (Rooms, Tenants, Invoices, MeterReadings). Update all repository methods to save with `isSynced = false`, attempt sync, and update to `isSynced = true` on success. Update sync methods to push unsynced local data *before* pulling and deleting from remote.

## 2. High Priority: Flawed Deletion Strategy
**Issue**: Across all repositories (`property`, `room`, `tenant`, etc.), the `delete` methods immediately remove the record from the local database and then attempt to delete it from the remote. 
- If the device is offline, the remote deletion fails silently (or just logs to the console).
- The record is now permanently gone from the local device but still exists on the server.
**Proposed Fix**: Implement an `isDeleted` flag (soft delete). When a user deletes a record offline, set `isDeleted = true`. The sync process should check for these flags, delete them on the remote server, and only then permanently delete them locally.

## 3. Medium Priority: Inconsistent Error Handling
**Issue**: Error handling during synchronization is inconsistent across methods and repositories.
- `RoomRepositoryImpl.addRoom` uses `rethrow` on sync failure, which might break the UI flow even though data was successfully saved locally.
- `RoomRepositoryImpl.saveRoom` catches and ignores the exact same sync error.
**Proposed Fix**: Standardize error handling. For an offline-first app, if the local save succeeds, the sync failure should typically be caught, logged, and the user should be informed that the data is saved offline, rather than throwing an exception that disrupts the flow.

## 4. Low Priority: Business Logic in Data Layer
**Issue**: `InvoiceRepositoryImpl.calculateInvoice()` orchestrates multiple DAOs and contains domain-specific logic. 
**Proposed Fix**: Move this logic into a Use Case (e.g., `CalculateInvoiceUseCase`) or a Domain Service. The Repository should ideally only be responsible for CRUD operations and data synchronization, not computing fees.

## 5. Architectural Inconsistency
**Issue**: `AuthRepository` is a direct class implementation without the `Repository` (Interface) and `RepositoryImpl` (Implementation) split used by all other features.
**Proposed Fix**: Create an `AuthRepository` interface and an `AuthRepositoryImpl` class to maintain consistent architecture across all features.

---

# Presentation Layer Review - Identified Problems & Improvements

Based on a cross-file analysis of `lib/features/.../presentation`, here are the identified issues:

## 1. Medium Priority: Hardcoded Navigation Routes
**Issue**: The application heavily relies on string-based routing interpolation, such as:
- `context.push('/rooms/${room.id}')`
- `context.push('/tenants/${tenant.id}/edit')`
- `context.push('/invoices/create?roomId=$roomId')`

Using raw strings for routing is brittle, error-prone, and hard to refactor. If a route definition changes, these strings will break silently until tested at runtime.
**Proposed Fix**: Use `context.pushNamed('routeName', pathParameters: {'id': id})` or adopt a typed routing package like `go_router_builder` to ensure compile-time safety for navigation.

## 2. Medium Priority: "Fat" UI Pages (God Widgets)
**Issue**: Many of the form pages (e.g., `add_room_page.dart` (31KB), `create_invoice_page.dart` (23KB)) are extremely large and contain a mix of complex layouts, local state management (`setState`), and business/saving logic.
**Proposed Fix**: 
- Extract repeated layout pieces into small stateless widgets.
- Move the complex state and validation/saving logic out of the Widget into a Riverpod `Notifier` or `StateNotifier` (acting as a ViewModel). This separates the "How it looks" from the "How it behaves" and reduces file size.

## 3. Low Priority: Inefficient Data Loading in Forms
**Issue**: Some pages (like `edit_property_page.dart`) use `ref.read` to fetch initial data asynchronously in `initState`. While this works, it bypasses the robust caching and reactive updating capabilities of Riverpod. If the app loses connection, or if the data was already fetched by the list view, fetching it manually via `initState` can be inefficient.
**Proposed Fix**: Use `ref.watch(provider)` on a `FutureProvider` or `StreamProvider` to inject the initial data into the form. This allows you to gracefully handle `.when(data: ..., loading: ..., error: ...)` and keeps the data perfectly synchronized.
