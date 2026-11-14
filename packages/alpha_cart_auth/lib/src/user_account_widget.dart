import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';

/// Reusable user account card showing Firebase Auth status, email/phone, and sign-out button.
class UserAccountCard extends StatelessWidget {
  const UserAccountCard({
    super.key,
    required this.accentColor,
    this.backgroundColor,
    this.textColor,
    this.subtitleColor,
    this.onSignOut,
  });

  final Color accentColor;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? subtitleColor;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        final user = snapshot.data ?? AuthService.instance.currentUser;

        final displayName = user?.displayName ??
            (user?.email != null ? user!.email!.split('@').first : null) ??
            (user?.phoneNumber != null ? 'User ${user!.phoneNumber}' : 'Alpha Cart User');

        final identity = user?.email ?? user?.phoneNumber ?? 'Signed in as Guest';

        final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'A';

        final bgColor = backgroundColor ?? Theme.of(context).cardColor;
        final mainTextColor = textColor ?? Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
        final subTextColor = subtitleColor ?? Colors.grey;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: accentColor.withValues(alpha: 0.2),
                child: Text(
                  initial,
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: mainTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      identity,
                      style: TextStyle(
                        fontSize: 12,
                        color: subTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Sign Out',
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                onPressed: () => _confirmSignOut(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await AuthService.instance.signOut();
              if (onSignOut != null) onSignOut!();
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

/// A list tile for Settings/Profile screens to trigger Sign Out.
class SignOutTile extends StatelessWidget {
  const SignOutTile({
    super.key,
    required this.accentColor,
    this.onSignOut,
  });

  final Color accentColor;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
      title: const Text(
        'Sign Out',
        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
      ),
      subtitle: const Text('Log out of your current session'),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await AuthService.instance.signOut();
                  if (onSignOut != null) onSignOut!();
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
