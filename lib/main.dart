import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const GrocyyApp());
}

class GrocyyApp extends StatelessWidget {
  const GrocyyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocyy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const RoleSelectionScreen(),
    );
  }
}

// ---------------------------------------------------------
// 1. ROLE SELECTION (CUSTOMER / SHOPKEEPER / OWNER ADMIN)
// ---------------------------------------------------------
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.shopping_cart_checkout_rounded, size: 85, color: Colors.green),
              const SizedBox(height: 12),
              const Text(
                'Grocyy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Colors.green,
                  letterSpacing: 1.2,
                ),
              ),
              const Text(
                'लोकल किराना सीधे घर तक (3 KM दायरा)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 48),
              
              // Customer Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.person, color: Colors.white, size: 24),
                label: const Text('Customer App (ग्राहक)', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerHomeScreen())),
              ),
              const SizedBox(height: 16),
              
              // Shopkeeper Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade800,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.storefront, color: Colors.white, size: 24),
                label: const Text('Shopkeeper App (दुकानदार)', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopkeeperDashboard())),
              ),
              const SizedBox(height: 16),
              
              // Owner Admin Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.black87, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.admin_panel_settings, color: Colors.black87, size: 24),
                label: const Text('Owner Admin Panel (मालिक)', style: TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.bold)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OwnerAdminPanel())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 2. CUSTOMER MODULE (3 KM RADIUS & ₹30/KM DELIVERY RULES)
// ---------------------------------------------------------
class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final List<Map<String, dynamic>> shops = [
    {"name": "शर्मा जी किराना स्टोर", "distance": 1.2, "isOpen": true, "rating": 4.8},
    {"name": "गुप्ता प्रोविजन स्टोर", "distance": 2.3, "isOpen": true, "rating": 4.5},
    {"name": "जय माता दी जनरल स्टोर", "distance": 3.6, "isOpen": false, "rating": 4.1}, // Out of 3 KM
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocyy - नजदीकी दुकानें'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: shops.length,
        itemBuilder: (context, index) {
          final shop = shops[index];
          final double distance = shop['distance'];
          final bool isWithin3Km = distance <= 3.0;
          final double deliveryFee = distance * 30.0;

          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: shop['isOpen'] && isWithin3Km ? Colors.green.shade100 : Colors.grey.shade200,
                child: Icon(Icons.store, color: shop['isOpen'] && isWithin3Km ? Colors.green : Colors.grey),
              ),
              title: Text(shop['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text(
                'दूरी: ${distance} KM | डिलीवरी चार्ज: ₹${deliveryFee.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.black87),
              ),
              trailing: isWithin3Km
                  ? (shop['isOpen']
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: const Text('ऑर्डर करें', style: TextStyle(color: Colors.white)),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ShopDetailScreen(shop: shop)),
                          ),
                        )
                      : const Text('बंद है', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)))
                  : Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6)),
                      child: const Text('3 KM से बाहर', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    ),
            ),
          );
        },
      ),
    );
  }
}

class ShopDetailScreen extends StatefulWidget {
  final Map<String, dynamic> shop;
  const ShopDetailScreen({super.key, required this.shop});

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  final List<Map<String, dynamic>> products = [
    {"name": "आशीर्वाद आटा (10 kg)", "price": 420, "qty": 0},
    {"name": "फॉर्च्यून रिफाइंड तेल (1 L)", "price": 140, "qty": 0},
    {"name": "टाटा नमक (1 kg)", "price": 28, "qty": 0},
    {"name": "अमूल ताज़ा दूध (500 ml)", "price": 27, "qty": 0},
  ];

  @override
  Widget build(BuildContext context) {
    double itemTotal = products.fold(0, (sum, p) => sum + (p['price'] * p['qty']));
    double deliveryCharge = widget.shop['distance'] * 30.0; // ₹30/KM Rule
    double platformCommission = itemTotal * 0.05; // 5% Rule
    double totalBill = itemTotal > 0 ? (itemTotal + deliveryCharge) : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shop['name']),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: products.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final p = products[index];
                return ListTile(
                  title: Text(p['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('₹${p['price']}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                        onPressed: () => setState(() {
                          if (p['qty'] > 0) p['qty']--;
                        }),
                      ),
                      Text('${p['qty']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () => setState(() => p['qty']++),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (itemTotal > 0)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -3))],
              ),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('सामान का मूल्य:'),
                    Text('₹${itemTotal.toStringAsFixed(0)}')
                  ]),
                  const SizedBox(height: 4),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('डिलीवरी चार्ज (${widget.shop['distance']} KM x ₹30):'),
                    Text('₹${deliveryCharge.toStringAsFixed(0)}')
                  ]),
                  const Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('कुल बिल (Total):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('₹${totalBill.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green)),
                  ]),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(14)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green.shade800,
                            content: Text('ऑर्डर प्लेस हो गया! (Grocey 5% कमिशन: ₹${platformCommission.toStringAsFixed(1)})'),
                          ),
                        );
                      },
                      child: const Text('ऑर्डर कन्फर्म करें (Cash on Delivery)', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// 3. SHOPKEEPER DASHBOARD (दुकानदार ऐप)
// ---------------------------------------------------------
class ShopkeeperDashboard extends StatefulWidget {
  const ShopkeeperDashboard({super.key});

  @override
  State<ShopkeeperDashboard> createState() => _ShopkeeperDashboardState();
}

class _ShopkeeperDashboardState extends State<ShopkeeperDashboard> {
  bool isStoreOpen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('दुकानदार डैशबोर्ड'),
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: SwitchListTile(
                title: const Text('दुकान स्टेटस', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(isStoreOpen ? 'दुकान खुली है (ग्राहक ऑर्डर कर सकते हैं)' : '
