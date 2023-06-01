import 'package:flutter/material.dart';
import 'package:users/utils/fonts.dart';
import 'package:users/widgets/input_field.dart';
import 'package:users/widgets/save_button.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.08,
                ),
                Text(
                  'Hello!\nWelcome back',
                  style: FontsProvider.titleLarge,
                ),
                SizedBox(
                  height: size.height * 0.08,
                ),
                InputField(
                  controller: nameController,
                  hint: 'name',
                  keyBoard: TextInputType.name,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                InputField(
                  controller: emailController,
                  hint: 'email',
                  keyBoard: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                InputField(
                  controller: ageController,
                  hint: 'age',
                  keyBoard: TextInputType.number,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(
                  height: size.height * 0.08,
                ),
                SaveButton(title: 'save', onTap: () {}),
                SizedBox(
                  height: size.height * 0.10,
                ),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('View all users'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
