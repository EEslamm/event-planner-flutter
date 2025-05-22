import 'package:event_planner/screens/home_screen.dart';
import 'package:event_planner/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:event_planner/screens/booking_screen.dart';
import 'package:event_planner/models/hall_model.dart';
import 'package:event_planner/components/booking_photo.dart';
import 'package:event_planner/components/booking_dialog.dart';
import 'package:event_planner/components/venue_booking.dart';
import 'package:event_planner/components/booking_makeup.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final dynamic arguments = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please enter your email and password',
                      backgroundColor: Colors.blue.shade400,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                    return;
                  }

                  try {
                    final response = await Supabase.instance.client.auth.signInWithPassword(
                      email: email,
                      password: password,
                    );

                    if (response.user != null) {
                      Get.snackbar(
                        'Success',
                        'Login Successful',
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                      );
                      Future.delayed(const Duration(seconds: 1), () {
                        if (arguments != null &&
                            arguments is Map &&
                            arguments.containsKey('redirectRoute') &&
                            arguments.containsKey('bookingDetails')) {
                          final String redirectRoute = arguments['redirectRoute'];
                          final dynamic bookingDetails = arguments['bookingDetails'];
                          final String? bookingType = arguments['bookingType'];

                          if (redirectRoute == '/booking' && bookingType == 'hall' && bookingDetails is HallModel) {
                            Get.off(() => BookingScreen(hall: bookingDetails));
                          } else if (redirectRoute == '/booking_photographer_dialog' &&
                                     bookingType == 'photographer' &&
                                     bookingDetails is Map) {
                            Get.back();
                            Future.delayed(Duration.zero, () {
                              if (Get.overlayContext != null) {
                                 showDialog(
                                  context: Get.overlayContext!,
                                  builder: (_) => BookingPhotographerDialog(
                                    photographerName: bookingDetails['name'],
                                    hourlyRate: bookingDetails['hourlyRate'],
                                  ),
                                );
                              } else if (Get.context != null) {
                                showDialog(
                                  context: Get.context!,
                                  builder: (_) => BookingPhotographerDialog(
                                    photographerName: bookingDetails['name'],
                                    hourlyRate: bookingDetails['hourlyRate'],
                                  ),
                                );
                              }
                            });
                          } else if (redirectRoute == '/booking_restaurant_dialog' &&
                                     bookingType == 'restaurant' &&
                                     bookingDetails is Map) {
                            Get.back();
                            Future.delayed(Duration.zero, () {
                              if (Get.overlayContext != null) {
                                showDialog(
                                  context: Get.overlayContext!,
                                  builder: (_) => BookingRestaurantDialog(
                                    restaurantName: bookingDetails['name'],
                                  ),
                                );
                              } else if (Get.context != null) {
                                showDialog(
                                  context: Get.context!,
                                  builder: (_) => BookingRestaurantDialog(
                                    restaurantName: bookingDetails['name'],
                                  ),
                                );
                              }
                            });
                          } else if (redirectRoute == '/booking_birthday_venue_dialog' &&
                                     bookingType == 'birthday_venue' &&
                                     bookingDetails is Map) {
                            Get.back();
                            Future.delayed(Duration.zero, () {
                              if (Get.overlayContext != null) {
                                showDialog(
                                  context: Get.overlayContext!,
                                  builder: (_) => BookingBirthdayVenueDialog(
                                    venueId: bookingDetails['id'],
                                    venueName: bookingDetails['name'],
                                  ),
                                );
                              } else if (Get.context != null) {
                                showDialog(
                                  context: Get.context!,
                                  builder: (_) => BookingBirthdayVenueDialog(
                                    venueId: bookingDetails['id'],
                                    venueName: bookingDetails['name'],
                                  ),
                                );
                              }
                            });
                          } else if (redirectRoute == '/booking_makeup_dialog' &&
                                     bookingType == 'makeup_artist' &&
                                     bookingDetails is Map) {
                            Get.back();
                            Future.delayed(Duration.zero, () {
                              if (Get.overlayContext != null) {
                                showDialog(
                                  context: Get.overlayContext!,
                                  builder: (_) => BookingMakeupDialog(
                                    artistName: bookingDetails['name'],
                                    hourlyRate: bookingDetails['hourlyRate'],
                                  ),
                                );
                              } else if (Get.context != null) {
                                showDialog(
                                  context: Get.context!,
                                  builder: (_) => BookingMakeupDialog(
                                    artistName: bookingDetails['name'],
                                    hourlyRate: bookingDetails['hourlyRate'],
                                  ),
                                );
                              }
                            });
                          } else {
                            Get.off(() => const HomeScreen());
                          }
                        } else {
                          Get.off(() => const HomeScreen());
                        }
                      });
                    }
                  } catch (e) {
                    String errorMessage = 'Login Failed';

                    if (e is AuthException) {
                      errorMessage = e.message;
                    }

                    Get.snackbar(
                      'Error',
                      errorMessage,
                      backgroundColor: Colors.blue.shade400,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Get.to(() => const RegisterScreen());
                },
                child: const Text(
                  'Register now?',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
