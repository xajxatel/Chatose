import 'package:chatose/common/utils/utils.dart';
import 'package:chatose/common/widgets/custom_button.dart';
import 'package:chatose/features/auth/controller/auth_controller.dart';
import 'package:chatose/helpers/colors.dart';
import 'package:country_picker/country_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const routeName = "/login-screen";

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  Country? country;

  void pickCountry() {
    showCountryPicker(
      context: context,
      onSelect: (pickedCountry) {
        setState(() {
          country = pickedCountry;
        });
      },
    );
  }

  void sendPhoneNumber(BuildContext context) {
    String phoneNumber = _phoneNumberController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, "+${country!.phoneCode}$phoneNumber");
    } else {
      showSnackBar(context: context, content: "Please check all fields");
    }
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login with your phone number',
            style: GoogleFonts.lato(fontSize: size.width / 19)),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Select Country Code"),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: pickCountry,
                  child: const Text('Pick a Country'),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    country != null
                        ? Text("+${country!.phoneCode}")
                        : const Text("+XX"),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: size.width * 0.7,
                      child: TextField(
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: redColor)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: greenColor)),
                          prefixIcon: const Icon(
                            FluentIcons.call_add_20_regular,
                            color: Colors.white,
                          ),
                          hintText: 'phone number',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.6,
                ),
                SizedBox(
                  width: 90,
                  child: CustomButton(
                      text: "Next",
                      onPressed: () {
                        sendPhoneNumber(context);
                      },
                      color: _phoneNumberController.text.isEmpty
                          ? redColor
                          : greenColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
