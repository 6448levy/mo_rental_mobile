import 'package:carrental/app/features/data/services/payment/payment_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentCard', () {
    const validCard = PaymentCard(
      holderName: 'John Doe',
      number: '4242 4242 4242 4242',
      expiry: '12/27',
      cvv: '123',
    );

    test('isValid is true for a well-formed card', () {
      expect(validCard.isValid, isTrue);
    });

    test('last4 extracts the final four digits, ignoring spaces', () {
      expect(validCard.last4, '4242');
    });

    test('maskedLabel never exposes the full PAN', () {
      expect(validCard.maskedLabel, 'Card ****4242');
      expect(validCard.maskedLabel.contains('4242 4242'), isFalse);
    });

    test('isValid is false when the holder name is blank', () {
      const card = PaymentCard(
          holderName: '  ', number: '4242424242424242', expiry: '12/27', cvv: '123');
      expect(card.isValid, isFalse);
    });

    test('isValid is false for a malformed expiry', () {
      const card = PaymentCard(
          holderName: 'John', number: '4242424242424242', expiry: '1227', cvv: '123');
      expect(card.isValid, isFalse);
    });

    test('isValid is false for a too-short number', () {
      const card = PaymentCard(
          holderName: 'John', number: '4242', expiry: '12/27', cvv: '123');
      expect(card.isValid, isFalse);
    });
  });
}
