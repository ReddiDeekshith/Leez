import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatLauncherScreen extends StatelessWidget {
  const ChatLauncherScreen({super.key});

  void _openChat(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Chat',
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const ChatOverlay();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _openChat(context),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 0,
          icon: const Icon(Icons.chat_bubble_outline),
          label: const Text(
            "Chat",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class ChatOverlay extends StatefulWidget {
  const ChatOverlay({super.key});

  @override
  _ChatOverlayState createState() => _ChatOverlayState();
}

class _ChatOverlayState extends State<ChatOverlay> {
  double _bottomOffset = 16.0; // Default bottom offset

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Update bottom offset based on keyboard height
    _bottomOffset = keyboardHeight > 0 ? keyboardHeight + 16.0 : 16.0;

    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          bottom: _bottomOffset,
          right: 16,
          child: Material(
            elevation: 20,
            borderRadius: BorderRadius.circular(20),
            shadowColor: Colors.black.withOpacity(0.3),
            child: Container(
              width: isTablet ? 400 : screenSize.width * 0.85,
              height: isTablet ? 600 : screenSize.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        colors: [Colors.indigo, Colors.indigo.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.support_agent,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'LEEZ Assistant',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            minimumSize: const Size(32, 32),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        child: const ChatBotWebView(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChatBotWebView extends StatefulWidget {
  const ChatBotWebView({super.key});

  @override
  State<ChatBotWebView> createState() => _ChatBotWebViewState();
}

class _ChatBotWebViewState extends State<ChatBotWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setUserAgent(
            'Mozilla/5.0 (Linux; Android 10; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });

                // Inject comprehensive scroll fixes
                Future.delayed(const Duration(milliseconds: 1500), () {
                  _controller.runJavaScript('''
                // Global scroll fixes
                document.documentElement.style.overflow = 'auto';
                document.documentElement.style.height = '100%';
                document.body.style.overflow = 'auto';
                document.body.style.height = '100%';
                document.body.style.margin = '0';
                document.body.style.padding = '0';
                document.body.style.touchAction = 'manipulation';
                document.body.style.webkitOverflowScrolling = 'touch';
                
                function enableScrolling() {
                  // Find all possible chat containers
                  const selectors = [
                    '.bp-chat-container',
                    '.bp-messenger-sidebar', 
                    '.bp-widget-container',
                    '.bp-conversation-container',
                    '.bp-conversation-list',
                    '[data-testid="chat-container"]',
                    '[class*="chat"]',
                    '[class*="conversation"]',
                    '[class*="message"]',
                    'div[style*="overflow: hidden"]',
                    'div[style*="height"]'
                  ];
                  
                  // Apply fixes to all matching elements
                  selectors.forEach(selector => {
                    document.querySelectorAll(selector).forEach(element => {
                      element.style.overflow = 'auto';
                      element.style.overflowY = 'auto';
                      element.style.webkitOverflowScrolling = 'touch';
                      element.style.touchAction = 'pan-y';
                      element.style.maxHeight = 'none';
                    });
                  });
                  
                  // Fix all divs with problematic styles
                  document.querySelectorAll('div').forEach(div => {
                    const computedStyle = window.getComputedStyle(div);
                    if (computedStyle.overflow === 'hidden' || 
                        computedStyle.overflowY === 'hidden' ||
                        div.style.overflow === 'hidden') {
                      div.style.overflow = 'auto';
                      div.style.overflowY = 'auto';
                      div.style.webkitOverflowScrolling = 'touch';
                    }
                  });
                  
                  console.log('Scroll fixes applied');
                }
                
                // Apply fixes immediately and repeatedly
                enableScrolling();
                setTimeout(enableScrolling, 1000);
                setTimeout(enableScrolling, 3000);
                setTimeout(enableScrolling, 5000);
                
                // Watch for DOM changes and reapply fixes
                const observer = new MutationObserver(() => {
                  setTimeout(enableScrolling, 100);
                });
                observer.observe(document.body, { 
                  childList: true, 
                  subtree: true, 
                  attributes: true,
                  attributeFilter: ['style', 'class']
                });
                
                // Also fix on window resize
                window.addEventListener('resize', enableScrolling);
              ''');
                });
              },
            ),
          )
          ..loadRequest(
            Uri.parse(
              "https://cdn.botpress.cloud/webchat/v3.0/shareable.html?configUrl=https://files.bpcontent.cloud/2025/06/25/13/20250625130919-OYYF6SJ4.json",
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Loading chat...",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
