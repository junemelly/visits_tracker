import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/visit.dart';
import '../../domain/entities/customer.dart';
import '../bloc/visits_bloc.dart';
import '../bloc/data_bloc.dart';

class AddVisitScreen extends StatefulWidget {
  const AddVisitScreen({super.key});

  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  Customer? _selectedCustomer;
  DateTime _selectedDate = DateTime.now();
  String _selectedStatus = 'Pending';
  List<int> _selectedActivities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Add Visit')),
      body: BlocListener<VisitsBloc, VisitsState>(listener: (context, state) {
        if (state is VisitsLoaded) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Visit created successfully')),);
        } else if (state is VisitsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),);
        }
      }, child: BlocBuilder<DataBloc, DataState>(builder: (context, state) {
        if (state is DataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DataLoaded) {
          return Form(key: _formKey,
              child: SafeArea(child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery
                    .of(context)
                    .viewPadding
                    .bottom + 24,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Customer
                  const Text('Customer', style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<Customer>(
                    value: _selectedCustomer,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select a customer',),
                    items: state.customers.map((customer) {
                      return DropdownMenuItem(
                        value: customer, child: Text(customer.name),);
                    }).toList(),
                    onChanged: (customer) =>
                        setState(() => _selectedCustomer = customer),
                    validator: (value) =>
                    value == null
                        ? 'Please select a customer'
                        : null,),

                  const SizedBox(height: 16),

                  // Visit Date
                  const Text('Visit Date', style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  InkWell(onTap: _selectDate,
                    child: Container(padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),),
                      child: Row(children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 8),
                        Text(_selectedDate.toLocal().toString().split(' ')[0]),
                      ],),),),

                  const SizedBox(height: 16),

                  // Status
                  const Text('Status', style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(value: _selectedStatus,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder()),
                    items: ['Pending', 'Completed', 'Cancelled'].map((status) {
                      return DropdownMenuItem(
                          value: status, child: Text(status));
                    }).toList(),
                    onChanged: (status) =>
                        setState(() => _selectedStatus = status!),),

                  const SizedBox(height: 16),

                  // Location
                  const Text('Location', style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(controller: _locationController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter visit location',),),

                  const SizedBox(height: 16),

                  // Activities
                  const Text('Activities', style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8,
                    runSpacing: 8,
                    children: state.activities.map((activity) {
                      final isSelected = _selectedActivities.contains(
                          activity.id);
                      return ChoiceChip(
                        label: Text(activity.description),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedActivities.add(activity.id);
                            } else {
                              _selectedActivities.remove(activity.id);
                            }
                          });
                        },
                        selectedColor: Colors.blue.shade100,
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(color: isSelected ? Colors.blue
                            .shade800 : Colors.black87,),);
                    }).toList(),),
                  const SizedBox(height: 16),

                  // Notes
                  const Text('Notes', style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(controller: _notesController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter visit notes...',),),
                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveVisit, child: const Text('SAVE'),),),
                ],),),)
          );
          } else
              if (state is DataError)
          {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<DataBloc>().add(LoadData()),
                  child: const Text('Retry'),),
              ],),);
          }
          return const Center(child: CircularProgressIndicator());
        },),),);
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),);

    if (date != null) setState(() => _selectedDate = date);
  }

  void _saveVisit() {
    if (_formKey.currentState?.validate() == true) {
      final visit = Visit(
        customerId: _selectedCustomer!.id,
        visitDate: _selectedDate,
        status: _selectedStatus,
        location: _locationController.text.isEmpty ? null : _locationController
            .text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        activitiesDone: _selectedActivities,
        createdAt: DateTime.now(),);

      context.read<VisitsBloc>().add(CreateVisit(visit));
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}