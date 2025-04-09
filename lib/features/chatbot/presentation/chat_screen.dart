import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smartsystemforschools/core/utils/animated_app_bar.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/notification_service/notification_details_screen.dart';
import 'package:smartsystemforschools/core/widgets/build_loading_view.dart';
import 'package:smartsystemforschools/features/chatbot/data/cubit/chatbot_cubit.dart';
import 'package:smartsystemforschools/features/chatbot/data/cubit/chatbot_state.dart';
import 'package:smartsystemforschools/features/chatbot/data/model/message.dart';
import 'package:smartsystemforschools/features/main_screen/presentation/views/main_screen.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImagePath;
  String? _selectedFilePath;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeModeCubit>().currentTheme;
    return Scaffold(
      appBar: AnimatedCustomAppBar(
        waveColor: Colors.blue.shade700,
        backgroundColor: Colors.blue.shade900,
        onTapBack: () {
          Navigator.of(context).pushReplacementNamed(MainScreen.id);
        },
        textStyle: AppStyles.styleSemiBold20(),
        title: 'AI ChatBot',
        thereIsIcon: false,
      ),
      backgroundColor: themeMode == ThemeMode.dark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: state.messages.length +
                      (state.currentTypingResponse.isNotEmpty ? 1 : 0) +
                      (state.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // First, show all existing messages
                    if (index < state.messages.length) {
                      final message = state.messages[index];
                      return _buildMessageBubble(message, themeMode);
                    }
                    // Then, show typing animation if there's content being typed
                    else if (state.currentTypingResponse.isNotEmpty &&
                        index == state.messages.length) {
                      return _buildTypingBubble(
                          state.currentTypingResponse, themeMode);
                    }
                    // Finally, show loading indicator if we're waiting for a response
                    else if (state.isLoading) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: LoadingAnimationWidget.hexagonDots(
                            color: themeMode == ThemeMode.dark
                                ? Colors.blue
                                : const Color(0xFF3D5AFE),
                            size: 40,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                );
              },
            ),
          ),
          // Preview of selected files
          if (_selectedImagePath != null || _selectedFilePath != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: themeMode == ThemeMode.dark
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: themeMode == ThemeMode.dark
                        ? const Color(0xFFFFFFFF).withOpacity(.1)
                        : const Color(0x3F000000),
                    blurRadius: 6,
                    offset: const Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                children: [
                  if (_selectedImagePath != null)
                    Stack(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(File(_selectedImagePath!)),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: themeMode == ThemeMode.dark
                                    ? const Color(0xFFFFFFFF).withOpacity(.2)
                                    : const Color(0x3F000000),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          right: -5,
                          top: -5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImagePath = null;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: themeMode == ThemeMode.dark
                                    ? Colors.grey[800]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeMode == ThemeMode.dark
                                        ? const Color(0xFFFFFFFF)
                                            .withOpacity(.2)
                                        : const Color(0x3F000000),
                                    blurRadius: 4,
                                    offset: const Offset(0, 0),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Icon(Icons.close_rounded,
                                  size: 16,
                                  color: themeMode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (_selectedFilePath != null)
                    Stack(
                      children: [
                        Container(
                          height: 60,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: themeMode == ThemeMode.dark
                                ? Colors.grey[850]
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: themeMode == ThemeMode.dark
                                    ? const Color(0xFFFFFFFF).withOpacity(.2)
                                    : const Color(0x3F000000),
                                blurRadius: 4,
                                offset: const Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.insert_drive_file_rounded,
                                color: themeMode == ThemeMode.dark
                                    ? Colors.blue
                                    : const Color(0xFF3D5AFE),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _selectedFilePath!.split('/').last,
                                style: TextStyle(
                                    color: themeMode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: -5,
                          top: -5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFilePath = null;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: themeMode == ThemeMode.dark
                                    ? Colors.grey[800]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeMode == ThemeMode.dark
                                        ? const Color(0xFFFFFFFF)
                                            .withOpacity(.2)
                                        : const Color(0x3F000000),
                                    blurRadius: 4,
                                    offset: const Offset(0, 0),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Icon(Icons.close_rounded,
                                  size: 16,
                                  color: themeMode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          // Input area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: themeMode == ThemeMode.dark
                      ? const Color(0xFFFFFFFF).withOpacity(.4)
                      : const Color(0x3F000000),
                  blurRadius: 6,
                  offset: const Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
              children: [
                _buildIconButton(
                  icon: Icons.attach_file_rounded,
                  onPressed: _pickFile,
                  themeMode: themeMode,
                ),
                const SizedBox(width: 8),
                _buildIconButton(
                  icon: Icons.photo_rounded,
                  onPressed: _pickImage,
                  themeMode: themeMode,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: themeMode == ThemeMode.dark
                          ? const Color(0xFF1E1E1E)
                          : Colors.grey[100],
                      boxShadow: [
                        BoxShadow(
                          color: themeMode == ThemeMode.dark
                              ? const Color(0xFFFFFFFF).withOpacity(.1)
                              : const Color(0x1F000000),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(
                        color: themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: themeMode == ThemeMode.dark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      minLines: 1,
                      maxLines: 3,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    return _buildIconButton(
                      icon: Icons.send_rounded,
                      onPressed: state.isLoading
                          ? _scroll()
                          : () => _sendMessage(context),
                      themeMode: themeMode,
                      color: themeMode == ThemeMode.dark
                          ? Colors.blue
                          : const Color(0xFF3D5AFE),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required ThemeMode themeMode,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: themeMode == ThemeMode.dark
            ? const Color(0xFF1E1E1E)
            : Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: themeMode == ThemeMode.dark
                ? const Color(0xFFFFFFFF).withOpacity(.1)
                : const Color(0x1F000000),
            blurRadius: 4,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: color ??
              (themeMode == ThemeMode.dark ? Colors.white : Colors.black87),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildMessageBubble(Message message, ThemeMode themeMode) {
    return Animate(
      effects: [
        SlideEffect(
          begin: Offset(message.isUser ? 0.1 : -0.1, 0),
          end: Offset.zero,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuad,
        ),
        const FadeEffect(
          begin: 0.0,
          end: 1.0,
          duration: Duration(milliseconds: 250),
        ),
      ],
      child: Align(
        alignment:
            message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: message.isUser
                ? (themeMode == ThemeMode.dark
                    ? const Color(0xFF0D47A1)
                    : const Color(0xFF3D5AFE))
                : (themeMode == ThemeMode.dark
                    ? const Color(0xFF1E1E1E)
                    : Colors.white),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: themeMode == ThemeMode.dark
                    ? const Color(0xFFFFFFFF).withOpacity(.1)
                    : const Color(0x3F000000).withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              )
            ],
          ),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.imageUrl != null)
                Container(
                  height: 200,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(File(message.imageUrl!)),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: themeMode == ThemeMode.dark
                            ? const Color(0xFFFFFFFF).withOpacity(.2)
                            : const Color(0x3F000000),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              if (message.filePath != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: themeMode == ThemeMode.dark
                        ? Colors.grey[850]
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: themeMode == ThemeMode.dark
                            ? const Color(0xFFFFFFFF).withOpacity(.1)
                            : const Color(0x3F000000),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.insert_drive_file_rounded,
                        size: 20,
                        color: message.isUser
                            ? Colors.white
                            : (themeMode == ThemeMode.dark
                                ? Colors.blue
                                : const Color(0xFF3D5AFE)),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          message.filePath!.split('/').last,
                          style: TextStyle(
                            fontSize: 14,
                            color: message.isUser
                                ? Colors.white
                                : (themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black87),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                message.content,
                style: TextStyle(
                  fontSize: 16,
                  color: message.isUser
                      ? Colors.white
                      : (themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black87),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}:${message.timestamp.second.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 12,
                  color: message.isUser
                      ? Colors.white.withOpacity(0.7)
                      : (themeMode == ThemeMode.dark
                          ? Colors.white70
                          : Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _scroll() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildTypingBubble(String text, ThemeMode themeMode) {
    return Animate(
      effects: const [
        SlideEffect(
          begin: Offset(-0.1, 0),
          end: Offset.zero,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOutQuad,
        ),
        FadeEffect(
          begin: 0.0,
          end: 1.0,
          duration: Duration(milliseconds: 250),
        ),
      ],
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: themeMode == ThemeMode.dark
                ? const Color(0xFF1E1E1E)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: themeMode == ThemeMode.dark
                    ? const Color(0xFFFFFFFF).withOpacity(.1)
                    : const Color(0x3F000000).withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              )
            ],
          ),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Typing',
                    style: TextStyle(
                      fontSize: 12,
                      color: themeMode == ThemeMode.dark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 5),
                  LoadingAnimationWidget.staggeredDotsWave(
                    color: themeMode == ThemeMode.dark
                        ? Colors.white70
                        : Colors.black54,
                    size: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate(onPlay: (controller) => controller.repeat()).shimmer(
          duration: 1200.ms,
          color: themeMode == ThemeMode.dark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05)),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFilePath = result.files.single.path;
      });
    }
  }

  void _sendMessage(BuildContext context) {
    if (_messageController.text.isNotEmpty ||
        _selectedImagePath != null ||
        _selectedFilePath != null) {
      context.read<ChatCubit>().sendMessage(
            _messageController.text,
            imagePath: _selectedImagePath,
            filePath: _selectedFilePath,
          );

      // Clear inputs
      _messageController.clear();
      setState(() {
        _selectedImagePath = null;
        _selectedFilePath = null;
      });

      // Scroll to bottom after a small delay to ensure the list has updated
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
