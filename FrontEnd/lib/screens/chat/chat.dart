import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/services/chatBot_Services.dart';
import '../../../theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // <-- Add this

class MedicalChatBot extends StatefulWidget {
  const MedicalChatBot({super.key});

  @override
  State<MedicalChatBot> createState() => _MedicalChatBotState();
}

class _MedicalChatBotState extends State<MedicalChatBot>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  late AnimationController _typingAnimationController;
  String? _token;

  static const Color botOrange = Color(0xCDFF8A50);
  static const Color lightOrange = Color(0xFFFFF3E0);
  static const Color accentOrange = Color(0xFFD6E0FF);
  static const Color lightBlue = Color(0xC06A9BF7);

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _token ??= Provider.of<AuthProvider>(context, listen: false).token;
    // Add welcome message from bot
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loc = AppLocalizations.of(context)!;
      _addBotMessage(
        loc.medicalAssistantWelcome,
        suggestions: [
          loc.suggestionHeadache1,
          loc.suggestionCold1,
          loc.suggestionBloodPressure1,
          loc.suggestionWater1,
        ],
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();

    ChatBotService().deleteChat(_token!);
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _messageController.clear();

    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
      _isTyping = true;
    });

    _typingAnimationController.repeat();
    _scrollToBottom();

    String language = isArabic(text) ? "ar" : "en";

    _sendBotResponse(text, language);
  }

  Future<void> _sendBotResponse(String userMessage, String language) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final loc = AppLocalizations.of(context)!;

    String botResponse;
    List<String> suggestions = [];
    botResponse = await ChatBotService().pushMessage(token!, userMessage);

    if (userMessage.toLowerCase().contains("headache")) {
      suggestions = [
        loc.suggestionHeadache1,
        loc.suggestionHeadache2,
        loc.suggestionHeadache3,
      ];
    } else if (userMessage.toLowerCase().contains("cold")) {
      suggestions = [
        loc.suggestionCold1,
        loc.suggestionCold2,
        loc.suggestionCold3,
      ];
    } else if (userMessage.toLowerCase().contains("blood pressure")) {
      suggestions = [
        loc.suggestionBloodPressure1,
        loc.suggestionBloodPressure2,
        loc.suggestionBloodPressure3,
      ];
    } else if (userMessage.toLowerCase().contains("water")) {
      suggestions = [
        loc.suggestionWater1,
        loc.suggestionWater2,
        loc.suggestionWater3,
      ];
    } else {
      suggestions = [
        loc.suggestionCommon1,
        loc.suggestionCommon2,
        loc.suggestionCommon3,
        loc.suggestionCommon4,
      ];
    }

    _addBotMessage(botResponse, suggestions: suggestions);
  }

  bool isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  void _addBotMessage(String text, {List<String> suggestions = const []}) {
    setState(() {
      _isTyping = false;
      _messages.add(
        ChatMessage(
          text: text,
          isUser: false,
          timestamp: DateTime.now(),
          suggestions: suggestions,
        ),
      );
    });

    _typingAnimationController.stop();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.medicalAssistant), // Localized
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryColor, botOrange.withOpacity(0.6)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.backgroundGradientStart,
                    lightOrange.withOpacity(0.3),
                    AppTheme.backgroundGradientEnd,
                  ],
                ),
              ),
              child: _messages.isEmpty
                  ? _buildWelcomeScreen()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessage(_messages[index]);
                      },
                    ),
            ),
          ),

          if (_isTyping) _buildTypingIndicator(),

          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    final loc = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Custom bot avatar for welcome screen
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, botOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: botOrange.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: _buildCustomBotIcon(size: 60),
          ),
          const SizedBox(height: 24),
          Text(
            loc.medicalAssistant, // Localized
            style: AppTheme.headingStyle.copyWith(
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [AppTheme.primaryColor, botOrange],
                ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              loc.medicalAssistantAskAnything, // Localized
              textAlign: TextAlign.center,
              style: AppTheme.subheadingStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) _buildBotAvatar(),

          const SizedBox(width: 8),

          Flexible(
            child: Column(
              crossAxisAlignment:
                  message.isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: message.isUser
                        ? LinearGradient(
                            colors: [AppTheme.primaryColor, lightBlue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: message.isUser ? null : AppTheme.white,
                    borderRadius: BorderRadius.circular(20).copyWith(
                      bottomRight:
                          message.isUser ? const Radius.circular(0) : null,
                      bottomLeft:
                          !message.isUser ? const Radius.circular(0) : null,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: message.isUser
                            ? botOrange.withOpacity(0.3)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    textDirection:
                        isArabic(message.text)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                    textAlign:
                        isArabic(message.text)
                            ? TextAlign.right
                            : TextAlign.left,
                    style: AppTheme.subheadingStyle.copyWith(
                      color: message.isUser ? AppTheme.white : AppTheme.black,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Timestamp
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(color: AppTheme.textGrey, fontSize: 12),
                ),

                // Suggestion chips for bot messages
                if (!message.isUser && message.suggestions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: message.suggestions.map((suggestion) {
                        return GestureDetector(
                          onTap: () {
                            _handleSubmitted(suggestion);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  lightOrange,
                                  accentOrange.withOpacity(0.3),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: botOrange.withOpacity(0.4),
                              ),
                            ),
                            child: Text(
                              suggestion,
                              style: TextStyle(
                                color: AppTheme.primaryColor.withOpacity(
                                  0.8,
                                ),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          if (message.isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildBotAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, botOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: botOrange.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildCustomBotIcon(size: 22),
    );
  }

  Widget _buildCustomBotIcon({required double size}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.smart_toy_rounded, color: AppTheme.white, size: size),
        Positioned(
          bottom: size * 0.1,
          right: size * 0.1,
          child: Container(
            width: size * 0.3,
            height: size * 0.3,
            decoration: BoxDecoration(
              color: lightOrange,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.white, width: 1),
            ),
            child: Icon(
              Icons.medical_services,
              color: botOrange,
              size: size * 0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.secondaryColor, accentOrange.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: accentOrange.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.person, color: AppTheme.white, size: 22),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 16),
          _buildBotAvatar(),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnimatedDot(0),
                _buildAnimatedDot(1),
                _buildAnimatedDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedDot(int index) {
    return AnimatedBuilder(
      animation: _typingAnimationController,
      builder: (context, child) {
        final animationValue = _typingAnimationController.value;
        final opacity = (0.4 + (0.6 * ((animationValue + index * 0.33) % 1.0)))
            .clamp(0.0, 1.0);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor.withOpacity(opacity),
                botOrange.withOpacity(opacity),
              ],
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildMessageComposer() {
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Voice input button (disabled)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor.withOpacity(0.1), lightOrange],
                ),
                shape: BoxShape.circle,
              ),
            ),

            // Text field
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppTheme.grey,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: lightOrange.withOpacity(0.5)),
                ),
                child: TextField(
                  controller: _messageController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: loc.typeYourHealthQuestion, // Localized
                    hintStyle: TextStyle(color: AppTheme.textGrey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: _handleSubmitted,
                ),
              ),
            ),

            // Send button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, botOrange],
                ),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: AppTheme.white),
                onPressed: () => _handleSubmitted(_messageController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  void _showInfoDialog(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            loc.medicalAssistantInfoTitle, // Localized
            style: AppTheme.cardTitleStyle.copyWith(
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [AppTheme.primaryColor, botOrange],
                ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.medicalAssistantInfoDesc, // Localized
                style: AppTheme.subheadingStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Text(
                loc.medicalAssistantDisclaimer, // Localized
                style: AppTheme.cardTitleStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                loc.medicalAssistantDisclaimerBullets, // Localized
                style: AppTheme.subheadingStyle.copyWith(fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(loc.close, style: TextStyle(color: botOrange)), // Localized
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String> suggestions;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.suggestions = const [],
  });
}
