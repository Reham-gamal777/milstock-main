import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/inventory_item.dart';
import '../../domain/entities/supply_request.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/entities/stock_movement.dart';
import '../../domain/usecases/inventory_usecases.dart';

// EVENTS
abstract class InventoryEvent {}

class FetchInventoryData extends InventoryEvent {}

class SearchInventory extends InventoryEvent {
  final String query;
  SearchInventory(this.query);
}

class FilterByCategory extends InventoryEvent {
  final String category;
  FilterByCategory(this.category);
}

class FilterByStatus extends InventoryEvent {
  final String status;
  FilterByStatus(this.status);
}

class AddNewInventoryItemEvent extends InventoryEvent {
  final InventoryItem item;
  AddNewInventoryItemEvent(this.item);
}

class UpdateInventoryItemEvent extends InventoryEvent {
  final InventoryItem item;
  UpdateInventoryItemEvent(this.item);
}

class DeleteInventoryItemEvent extends InventoryEvent {
  final String id;
  DeleteInventoryItemEvent(this.id);
}

class MarkAllNotificationsAsRead extends InventoryEvent {}

// STATES
abstract class InventoryState {}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<InventoryItem> allItems;
  final List<InventoryItem> filteredItems;
  final List<SupplyRequest> requests;
  final List<NotificationItem> notifications;
  final List<Map<String, dynamic>> warehouses;
  final List<StockMovement> movements;
  final String searchQuery;
  final String selectedCategory;
  final String selectedStatus;

  InventoryLoaded({
    required this.allItems,
    required this.filteredItems,
    required this.requests,
    required this.notifications,
    this.warehouses = const [],
    this.movements = const [],
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.selectedStatus = 'All',
  });

  InventoryLoaded copyWith({
    List<InventoryItem>? allItems,
    List<InventoryItem>? filteredItems,
    List<SupplyRequest>? requests,
    List<NotificationItem>? notifications,
    List<Map<String, dynamic>>? warehouses,
    List<StockMovement>? movements,
    String? searchQuery,
    String? selectedCategory,
    String? selectedStatus,
  }) {
    return InventoryLoaded(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      requests: requests ?? this.requests,
      notifications: notifications ?? this.notifications,
      warehouses: warehouses ?? this.warehouses,
      movements: movements ?? this.movements,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }
}

class InventoryError extends InventoryState {
  final String message;
  InventoryError(this.message);
}

// BLOC
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetInventoryItems getInventoryItems;
  final AddInventoryItem addInventoryItem;
  final UpdateInventoryItem updateInventoryItem;
  final DeleteInventoryItem deleteInventoryItem;
  final GetSupplyRequests getSupplyRequests;
  final GetNotifications getNotifications;
  final GetWarehouses getWarehouses;
  final GetMovements getMovements;

  InventoryBloc({
    required this.getInventoryItems,
    required this.addInventoryItem,
    required this.updateInventoryItem,
    required this.deleteInventoryItem,
    required this.getSupplyRequests,
    required this.getNotifications,
    required this.getWarehouses,
    required this.getMovements,
  }) : super(InventoryInitial()) {
    on<FetchInventoryData>(_onFetchInventoryData);
    on<SearchInventory>(_onSearchInventory);
    on<FilterByCategory>(_onFilterByCategory);
    on<FilterByStatus>(_onFilterByStatus);
    on<AddNewInventoryItemEvent>(_onAddNewInventoryItem);
    on<UpdateInventoryItemEvent>(_onUpdateInventoryItem);
    on<DeleteInventoryItemEvent>(_onDeleteInventoryItem);
    on<MarkAllNotificationsAsRead>(_onMarkAllNotificationsAsRead);
  }

  void _onMarkAllNotificationsAsRead(
    MarkAllNotificationsAsRead event,
    Emitter<InventoryState> emit,
  ) {
    if (state is InventoryLoaded) {
      final s = state as InventoryLoaded;
      final updatedNotifications = s.notifications.map((n) => n.copyWith(isRead: true)).toList();
      emit(s.copyWith(notifications: updatedNotifications));
    }
  }

  Future<void> _onFetchInventoryData(
    FetchInventoryData event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      final items = await getInventoryItems(NoParams());
      final reqs = await getSupplyRequests(NoParams());
      final alerts = await getNotifications(NoParams());
      final whs = await getWarehouses(NoParams());
      final mvts = await getMovements(NoParams());
      
      emit(InventoryLoaded(
        allItems: items,
        filteredItems: items,
        requests: reqs,
        notifications: alerts,
        warehouses: whs,
        movements: mvts,
      ));
    } catch (e) {
      // ignore: avoid_print
      print('Inventory Fetch Error: $e');
      emit(InventoryError(e.toString()));
    }
  }

  void _onSearchInventory(
    SearchInventory event,
    Emitter<InventoryState> emit,
  ) {
    if (state is InventoryLoaded) {
      final s = state as InventoryLoaded;
      final query = event.query.toLowerCase();
      final filtered = _applyFilters(s.allItems, query, s.selectedCategory, s.selectedStatus);
      emit(s.copyWith(filteredItems: filtered, searchQuery: event.query));
    }
  }

  void _onFilterByCategory(
    FilterByCategory event,
    Emitter<InventoryState> emit,
  ) {
    if (state is InventoryLoaded) {
      final s = state as InventoryLoaded;
      final filtered = _applyFilters(s.allItems, s.searchQuery, event.category, s.selectedStatus);
      emit(s.copyWith(filteredItems: filtered, selectedCategory: event.category));
    }
  }

  void _onFilterByStatus(
    FilterByStatus event,
    Emitter<InventoryState> emit,
  ) {
    if (state is InventoryLoaded) {
      final s = state as InventoryLoaded;
      final filtered = _applyFilters(s.allItems, s.searchQuery, s.selectedCategory, event.status);
      emit(s.copyWith(filteredItems: filtered, selectedStatus: event.status));
    }
  }

  Future<void> _onAddNewInventoryItem(
    AddNewInventoryItemEvent event,
    Emitter<InventoryState> emit,
  ) async {
    if (state is InventoryLoaded) {
      final s = state as InventoryLoaded;
      try {
        await addInventoryItem(event.item);
        // Refresh data
        final items = await getInventoryItems(NoParams());
        final filtered = _applyFilters(items, s.searchQuery, s.selectedCategory, s.selectedStatus);
        emit(s.copyWith(allItems: items, filteredItems: filtered));
      } catch (e) {
        // ignore: avoid_print
        print('Add Item Error: $e');
      }
    }
  }

  Future<void> _onUpdateInventoryItem(
    UpdateInventoryItemEvent event,
    Emitter<InventoryState> emit,
  ) async {
    if (state is InventoryLoaded) {
      final s = state as InventoryLoaded;
      try {
        await updateInventoryItem(event.item);
        // Refresh data
        final items = await getInventoryItems(NoParams());
        final filtered = _applyFilters(items, s.searchQuery, s.selectedCategory, s.selectedStatus);
        emit(s.copyWith(allItems: items, filteredItems: filtered));
      } catch (e) {
        // ignore: avoid_print
        print('Update Item Error: $e');
      }
    }
  }

  Future<void> _onDeleteInventoryItem(
    DeleteInventoryItemEvent event,
    Emitter<InventoryState> emit,
  ) async {
    if (state is InventoryLoaded) {
      final s = state as InventoryLoaded;
      try {
        await deleteInventoryItem(event.id);
        // Refresh data
        final items = await getInventoryItems(NoParams());
        final filtered = _applyFilters(items, s.searchQuery, s.selectedCategory, s.selectedStatus);
        emit(s.copyWith(allItems: items, filteredItems: filtered));
      } catch (e) {
        // ignore: avoid_print
        print('Delete Item Error: $e');
      }
    }
  }

  List<InventoryItem> _applyFilters(
    List<InventoryItem> items,
    String query,
    String category,
    String status,
  ) {
    return items.where((item) {
      final matchesQuery = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.id.toLowerCase().contains(query) ||
          (item.serialNumber != null && item.serialNumber!.toLowerCase().contains(query));
      
      final matchesCategory = category == 'All' || item.category == category;
      
      final matchesStatus = status == 'All' || item.status == status;

      return matchesQuery && matchesCategory && matchesStatus;
    }).toList();
  }
}
