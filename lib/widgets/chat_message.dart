import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ChatMessage extends StatefulWidget {
  final String text;
  final bool isUser;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage>
    with AutomaticKeepAliveClientMixin {
  bool _hasPlayed = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!widget.isUser)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.psychology,
                color: primaryColor,
                size: 20,
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: widget.isUser ? primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: widget.isUser
                  ? Text(
                      widget.text,
                      style: TextStyle(
                        color: widget.isUser ? Colors.white : Colors.black87,
                      ),
                    )
                  : DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.black87,
                      ),
                      child: _hasPlayed
                          ? Text(widget.text)
                          : AnimatedTextKit(
                              onFinished: () {
                                setState(() {
                                  _hasPlayed = true;
                                });
                              },
                              displayFullTextOnTap: true,
                              repeatForever: false,
                              animatedTexts: [
                                TyperAnimatedText(
                                  widget.text,
                                ),
                              ],
                              isRepeatingAnimation: false,
                              totalRepeatCount: 1,
                            ),
                    ),
            ),
          ),
          if (widget.isUser)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.person,
                color: primaryColor,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}