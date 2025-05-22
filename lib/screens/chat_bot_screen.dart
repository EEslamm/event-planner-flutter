import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatBotScreen extends StatelessWidget {
  final ChatBotController controller = Get.put(ChatBotController());

  ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Bot'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final isUser = msg['sender'] == 'User';
                  return Align(
                    alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blueAccent : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg['text'] ?? '',
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              )),
            ),
            Obx(() {
              final options = controller.currentOptions;
              if (options.isEmpty) {
                return const SizedBox.shrink();
              }
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: options.map((option) {
                  return ElevatedButton(
                    onPressed: () => controller.selectOption(option),
                    child: Text(option),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 12),
            TextField(
              controller: controller.textController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    controller.handleUserInput(controller.textController.text);
                  },
                ),
              ),
              onSubmitted: (text) {
                controller.handleUserInput(text);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBotController extends GetxController {
  var messages = <Map<String, String>>[].obs;
  var currentOptions = <String>[].obs;
  final TextEditingController textController = TextEditingController();

  final Map<String, dynamic> questionsTree = {
    'Welcome to Event Planner! How can I assist you?': [
      'What types of events do you manage?',
      'How do I book an appointment with a coordinator?',
      'Do you provide catering services?'
    ],
    'What types of events do you manage?': [
      'Weddings',
      'Birthday parties',
      'Conferences and seminars'
    ],
    'How do I book an appointment with a coordinator?':
    'You can book through our app or contact us directly.',
    'Do you provide catering services?':
    'Yes, we offer a variety of catering services for all occasions.',
    'Weddings': 'We provide comprehensive services for weddings.',
    'Birthday parties': 'We offer complete setups for birthday parties.',
    'Conferences and seminars':
    'We organize and manage conferences and seminars professionally.',
  };

  final Map<String, List<String>> trainedQuestions = {
    'tickets': [
      'How do I buy a ticket?',
      'What is the ticket price?',
      'Can I cancel a ticket?'
    ],
    'price': [
      'What is the cost of organizing an event?',
      'Are there any discounts?'
    ],
    'appointment': [
      'How do I book an appointment?',
      'What are your working hours?'
    ],
  };

  late final GenerativeModel _geminiModel;
  late final GeminiProvider geminiProvider;

  ChatBotController() {
    _geminiModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: 'AIzaSyAnjViVcNa5CKqoI1KXZCOywzUjJ1Dlx0Y', // Replace with your Gemini API key
    );
    geminiProvider = GeminiProvider(model: _geminiModel);
  }

  @override
  void onInit() {
    super.onInit();
    startChat();
  }

  void startChat() {
    const greeting = 'Welcome to Event Planner! How can I assist you?';
    messages.add({'sender': 'Bot', 'text': greeting});
    currentOptions.value = List<String>.from(questionsTree[greeting]);
  }

  void handleUserInput(String input) {
    if (input.isEmpty) return;

    messages.add({'sender': 'User', 'text': input});
    textController.clear();

    final response = questionsTree[input];
    if (response != null) {
      if (response is String) {
        messages.add({'sender': 'Bot', 'text': response});
        currentOptions.clear();
      } else if (response is List<String>) {
        messages.add({
          'sender': 'Bot',
          'text': 'Please select a question from the following options:'
        });
        currentOptions.value = response;
      }
    } else {
      final related = findRelatedQuestions(input);
      if (related.isNotEmpty) {
        messages.add({
          'sender': 'Bot',
          'text': 'I’m not sure, but did you mean one of these?'
        });
        currentOptions.value = related;
      } else {
        getAIResponse(input);
      }
    }
  }

  void selectOption(String option) {
    handleUserInput(option);
  }

  List<String> findRelatedQuestions(String userQuestion) {
    List<String> found = [];
    trainedQuestions.forEach((keyword, questions) {
      if (userQuestion.toLowerCase().contains(keyword)) {
        found.addAll(questions);
      }
    });
    return found;
  }

  void getAIResponse(String query) async {
    try {
      final chatSession = _geminiModel.startChat();
      final response = await chatSession.sendMessage(Content.text(query));
      final aiResponse = response.text ?? 'Sorry, I couldn’t process that.';
      messages.add({'sender': 'Bot', 'text': aiResponse});
      currentOptions.clear();
    } catch (e) {
      messages.add({
        'sender': 'Bot',
        'text': 'Sorry, I encountered an error. Please contact customer service.'
      });
      currentOptions.clear();
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}