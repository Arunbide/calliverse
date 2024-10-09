import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class UserContacts extends StatefulWidget {
  @override
  _UserContactsState createState() => _UserContactsState();
}

class _UserContactsState extends State<UserContacts> {
  List<Contact>? contacts;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  Future<void> getContacts() async {
    // Request permission to access contacts
    PermissionStatus permissionStatus = await _getContactPermission();

    if (permissionStatus == PermissionStatus.granted) {
      try {
        // Attempt to fetch contacts and update state
        List<Contact> _contacts = (await ContactsService.getContacts()).toList();
        setState(() {
          contacts = _contacts;
          isLoading = false;
        });
      } catch (e) {
        // Handle any errors while fetching contacts
        setState(() {
          errorMessage = 'Failed to load contacts: $e';
          isLoading = false;
        });
      }
    } else {
      // Handle permission denied error
      setState(() {
        errorMessage = 'Permission denied to access contacts.';
        isLoading = false;
      });
    }
  }

  // Handle permission request
  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;

    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Contacts'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : contacts == null || contacts!.isEmpty
          ? Center(child: Text('No contacts found.'))
          : ListView.builder(
        itemCount: contacts!.length,
        itemBuilder: (context, index) {
          var contact = contacts![index];

          var displayName = (contact.displayName != null &&
              contact.displayName!.isNotEmpty)
              ? contact.displayName
              : "Unnamed Contact";

          return ListTile(
            title: Text(displayName!),
            subtitle: contact.phones != null &&
                contact.phones!.isNotEmpty &&
                contact.phones!.first.value != null
                ? Text(contact.phones!.first.value!)
                : Text('No phone number available'),
          );
        },
      ),
    );
  }
}
