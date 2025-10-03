import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoinWidget extends StatelessWidget {
  final int coinCount;

  const CoinWidget({super.key, required this.coinCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 60,
      decoration: _buildCoinDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Coin icon
            Image.asset(
              'assets/images/coin.png',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.monetization_on,
                  color: Color(0xFFFFD700),
                  size: 32,
                );
              },
            ),
            const SizedBox(width: 4),
            // Coin count
            Flexible(
              child: Text(
                '$coinCount',
                style: GoogleFonts.vt323(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildCoinDecoration() {
    return BoxDecoration(
      color: const Color(0xFFF5EFE4), // Same creamy background as calendar
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFF795548), // Same brown border as calendar
        width: 4,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 0,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
