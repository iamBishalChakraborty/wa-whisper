import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static Future<void> openChat(BuildContext context, String phoneInput, String message) async {
    final String phone = phoneInput.replaceAll(RegExp(r'[^0-9]'), '');
    final String encodedText = message.isNotEmpty ? Uri.encodeComponent(message) : '';

    final Uri waScheme = Uri.parse('whatsapp://send?phone=$phone${encodedText.isNotEmpty ? '&text=$encodedText' : ''}');
    final Uri waBizScheme = Uri.parse('whatsapp-business://send?phone=$phone${encodedText.isNotEmpty ? '&text=$encodedText' : ''}');
    final Uri waMe = Uri.parse('https://wa.me/$phone${encodedText.isNotEmpty ? '?text=$encodedText' : ''}');
    final Uri apiWhatsApp = Uri.parse('https://api.whatsapp.com/send?phone=$phone${encodedText.isNotEmpty ? '&text=$encodedText' : ''}');

    // Web: only HTTPS endpoints work reliably
    if (kIsWeb) {
      if (await launchUrl(waMe, mode: LaunchMode.externalApplication)) return;
      if (await launchUrl(apiWhatsApp, mode: LaunchMode.externalApplication)) return;
      throw Exception('Unable to open WhatsApp links in this environment.');
    }

    // Try installed app schemes first (WhatsApp, then WhatsApp Business)
    if (await canLaunchUrl(waScheme)) {
      if (await launchUrl(waScheme, mode: LaunchMode.externalApplication)) return;
    }
    if (await canLaunchUrl(waBizScheme)) {
      if (await launchUrl(waBizScheme, mode: LaunchMode.externalApplication)) return;
    }

    // Fallback to HTTPS endpoints
    if (await canLaunchUrl(waMe)) {
      if (await launchUrl(waMe, mode: LaunchMode.externalApplication)) return;
    }
    if (await canLaunchUrl(apiWhatsApp)) {
      if (await launchUrl(apiWhatsApp, mode: LaunchMode.externalApplication)) return;
    }

    // Final fallback: direct to store pages
    if (defaultTargetPlatform == TargetPlatform.android) {
      final Uri market = Uri.parse('market://details?id=com.whatsapp');
      final Uri play = Uri.parse('https://play.google.com/store/apps/details?id=com.whatsapp');
      if (await launchUrl(market, mode: LaunchMode.externalApplication)) return;
      if (await launchUrl(play, mode: LaunchMode.externalApplication)) return;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final Uri appStore = Uri.parse('https://apps.apple.com/app/whatsapp-messenger/id310633997');
      if (await launchUrl(appStore, mode: LaunchMode.externalApplication)) return;
    }

    throw Exception('WhatsApp is not available on this device.');
  }

  static bool isLikelyValidE164Digits(String input) {
    final String digits = input.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length >= 8 && digits.length <= 15;
  }
}