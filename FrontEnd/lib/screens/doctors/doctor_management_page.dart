// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../models/userModel.dart';
// import '../../services/admin_services.dart';
// import '../../theme/app_theme.dart';

// class DoctorManagementPage extends StatefulWidget {
//   const DoctorManagementPage({super.key});

//   @override
//   State<DoctorManagementPage> createState() => _DoctorManagementPageState();
// }

// class _DoctorManagementPageState extends State<DoctorManagementPage> {
//   String _filter = 'all'; // 'all', 'active', 'inactive'
//   List<UserModel> _doctors = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchDoctors();
//   }

//   Future<void> _fetchDoctors() async {
//     // setState(() => _isLoading = true);
//     // // Replace with your real service call
//     // final adminServices = AdminServices();
//     // // Example: fetch all doctors (replace with your backend logic)
//     // List<UserModel> allDoctors = await adminServices.getAllDoctors();
//     // setState(() {
//     //   _doctors = allDoctors.where((d) => d.role == 'doctor').toList();
//     //   _isLoading = false;
//     // });
//   }

//   List<UserModel> get _filteredDoctors {
//     // if (_filter == 'active') {
//     //   return _doctors.where((d) => d.isActive == true).toList();
//     // } else if (_filter == 'inactive') {
//     //   return _doctors.where((d) => d.isActive == false).toList();
//     // }
//     // return _doctors;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Doctor Management'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Filter buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 FilterChip(
//                   label: const Text('All'),
//                   selected: _filter == 'all',
//                   onSelected: (_) => setState(() => _filter = 'all'),
//                 ),
//                 const SizedBox(width: 8),
//                 FilterChip(
//                   label: const Text('Active'),
//                   selected: _filter == 'active',
//                   onSelected: (_) => setState(() => _filter = 'active'),
//                   selectedColor: Colors.green[100],
//                 ),
//                 const SizedBox(width: 8),
//                 FilterChip(
//                   label: const Text('Inactive'),
//                   selected: _filter == 'inactive',
//                   onSelected: (_) => setState(() => _filter = 'inactive'),
//                   selectedColor: Colors.red[100],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : _filteredDoctors.isEmpty
//                       ? const Center(child: Text('No doctors found.'))
//                       : ListView.builder(
//                           itemCount: _filteredDoctors.length,
//                           itemBuilder: (context, index) {
//                             final doctor = _filteredDoctors[index];
//                             return Card(
//                               margin: const EdgeInsets.symmetric(vertical: 8),
//                               child: ListTile(
//                                 leading: CircleAvatar(
//                                   backgroundColor: doctor.isActive ? Colors.green : Colors.red,
//                                   child: const Icon(Icons.person, color: Colors.white),
//                                 ),
//                                 title: Text('${doctor.firstName ?? ''} ${doctor.lastName ?? ''}'),
//                                 subtitle: Text('ID: ${doctor.id ?? ''}'),
//                                 trailing: doctor.isActive
//                                     ? const Text('Active', style: TextStyle(color: Colors.green))
//                                     : const Text('Inactive', style: TextStyle(color: Colors.red)),
//                               ),
//                             );
//                           },
//                         ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
