import 'package:awesome_card/awesome_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CreditCardCarousel extends StatefulWidget {
  final List<CreditCardData> cards;
  final Function(CreditCardData) onCardSelected;
  final List<Color> colors;
  final bool isTapped;

  const CreditCardCarousel({
    super.key,
    required this.cards,
    required this.onCardSelected,
    required this.colors,
    required this.isTapped,
  });

  @override
  _CreditCardCarouselState createState() => _CreditCardCarouselState();
}

class _CreditCardCarouselState extends State<CreditCardCarousel>
    with SingleTickerProviderStateMixin {
  int _currentCardIndex = 0;
  double _dragOffset = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation;
  double _targetOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuart,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateToCard(int index) {
    setState(() {
      _targetOffset = (index - _currentCardIndex).toDouble();
      _currentCardIndex = index;
      _controller.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragOffset = details.primaryDelta!;
        });
      },
      onHorizontalDragEnd: (details) {
        // Determine swipe threshold (20% of screen width)
        if (_dragOffset > 0 && _dragOffset > screenWidth * 0.001) {
          // Swipe right
          _animateToCard((_currentCardIndex - 1 + widget.cards.length) %
              widget.cards.length);
        } else if (_dragOffset < 0 && _dragOffset.abs() > screenWidth * 0.001) {
          // Swipe left
          _animateToCard((_currentCardIndex + 1) % widget.cards.length);
        } else {
          // Return to current card if swipe wasn't significant
          _animateToCard(_currentCardIndex);
        }

        setState(() {
          _dragOffset = 0.0;
        });
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final animatedOffset = _targetOffset * (1 - _animation.value);
            return Stack(
              alignment: Alignment.center,
              children: [
                // Background cards
                for (int i = 0; i < widget.cards.length; i++)
                  if (i != _currentCardIndex)
                    Positioned(
                      child: Transform.translate(
                        offset: Offset(
                          (i - _currentCardIndex) * 30.0 +
                              _dragOffset * 0.3 +
                              animatedOffset * 30.0,
                          0,
                        ),
                        child: Transform.scale(
                          scale: 0.9,
                          child: Transform.rotate(
                            angle: (i - _currentCardIndex) * 0.05 +
                                animatedOffset * 0.05,
                            child: Opacity(
                              opacity: 0.8,
                              child: _buildCreditCard(widget.cards[i],
                                  isDarkMode, widget.colors[i]),
                            ),
                          ),
                        ),
                      ),
                    ),
                // Transform.translate(
                //   offset: Offset(
                //       _dragOffset +
                //           animatedOffset * MediaQuery.of(context).size.width,
                //       0),
                //   child: _buildCreditCard(widget.cards[_currentCardIndex],
                //           isDarkMode, widget.colors[_currentCardIndex])
                //       .animate()
                //       .fadeIn(duration: 300.ms),
                // ),
                // const SizedBox(
                //   height: 60,
                // ),
                Transform.translate(
                  offset: Offset(
                      _dragOffset +
                          animatedOffset * MediaQuery.of(context).size.width,
                      0),
                  child: _buildCreditCard2(
                          widget.cards[_currentCardIndex],
                          isDarkMode,
                          widget.colors[_currentCardIndex],
                          widget.isTapped)
                      .animate()
                      .fadeIn(duration: 300.ms),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCreditCard2(
    CreditCardData card,
    bool isDarkMode,
    Color baseColor,
    bool isTapped,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: CreditCard(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          cardNumber: card.cardNumber,
          cardExpiry: card.expiryDate,
          cardHolderName: card.holderName,
          cvv: card.cvc,
          bankName: card.bankName,
          cardType: CardType.masterCard,
          showBackSide: isTapped,
          horizontalMargin: 0,
          frontBackground: baseColor == Colors.black
              ? CardBackgrounds.black
              : CardBackgrounds.custom(baseColor.value),
          backBackground: baseColor == Colors.black
              ? CardBackgrounds.white
              : CardBackgrounds.custom(baseColor.value),
          showShadow: true,
          textExpDate: 'Exp. Date',
          textName: 'Name',
          textExpiry: 'MM/YY'),
    );
  }

  Widget _buildCreditCard(
    CreditCardData card,
    bool isDarkMode,
    Color baseColor,
  ) {
    return GestureDetector(
      onTap: () => widget.onCardSelected(card),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.25,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [baseColor.withOpacity(.8), baseColor.withOpacity(.9)]
                : [
                    baseColor.withOpacity(0.7),
                    baseColor.withOpacity(0.9),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  card.bankName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.contactless,
                  color: Colors.white.withOpacity(0.7),
                )
              ],
            ),
            const Spacer(),
            Text(
              card.cardNumber
                  .replaceAllMapped(
                    RegExp(r".{4}"),
                    (match) => "${match.group(0)} ",
                  )
                  .trim(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  card.holderName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  card.expiryDate,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CreditCardData {
  final String bankName;
  final String cardNumber;
  final String holderName;
  final String expiryDate;
  final String cvc;

  CreditCardData({
    required this.bankName,
    required this.cardNumber,
    required this.holderName,
    required this.expiryDate,
    required this.cvc,
  });
}
