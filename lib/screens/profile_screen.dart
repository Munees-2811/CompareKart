import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/price_alert_provider.dart';
import '../providers/comparison_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final alertProvider = Provider.of<PriceAlertProvider>(context);
    final comparisonProvider = Provider.of<ComparisonProvider>(context);
    
    final user = authProvider.user;
    final themeColor = const Color(0xFF0D47A1);

    // Provide default fallback user if auth is bypassable, but authProvider.user is used
    final String displayName = user?.displayName ?? 'Guest User';
    final String email = user?.email ?? 'guest.user@example.com';
    final String photoUrl = user?.photoUrl ?? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150';
    final String loginMethod = user?.loginMethod ?? 'email';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                  border: Border.all(color: Colors.grey[100]!),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: NetworkImage(photoUrl),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                displayName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Login Method Pill
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: loginMethod == 'google' ? Colors.red[50] : Colors.blue[50],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  loginMethod.toUpperCase(),
                                  style: TextStyle(
                                    color: loginMethod == 'google' ? Colors.red[800] : themeColor,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stats Row
              Row(
                children: [
                  _buildStatCard('Favorites', wishlistProvider.items.length, Icons.favorite, Colors.pink),
                  const SizedBox(width: 12),
                  _buildStatCard('Active Alerts', alertProvider.alerts.length, Icons.notifications_active, Colors.amber),
                  const SizedBox(width: 12),
                  _buildStatCard('Compare Queue', comparisonProvider.compareList.length, Icons.compare_arrows, Colors.blue),
                ],
              ),
              const SizedBox(height: 28),

              // Settings Section
              const Text(
                'App Settings',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              
              // Settings list container
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: _notificationsEnabled,
                      onChanged: (val) {
                        setState(() {
                          _notificationsEnabled = val;
                        });
                      },
                      title: const Text('Price Drop Notifications', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500)),
                      activeColor: themeColor,
                      secondary: Icon(Icons.notifications_active_outlined, color: themeColor, size: 20),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      value: _darkModeEnabled,
                      onChanged: (val) {
                        setState(() {
                          _darkModeEnabled = val;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Dark mode toggle. (Simulated UX Theme remain clean white)')),
                        );
                      },
                      title: const Text('Dark Mode', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500)),
                      activeColor: themeColor,
                      secondary: Icon(Icons.dark_mode_outlined, color: themeColor, size: 20),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.delete_sweep_outlined, color: themeColor, size: 20),
                      title: const Text('Clear Search Cache', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500)),
                      trailing: const Icon(Icons.chevron_right, size: 16),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Search cache cleared successfully!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    authProvider.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged out successfully.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFEBEE),
                    foregroundColor: const Color(0xFFC62828),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
