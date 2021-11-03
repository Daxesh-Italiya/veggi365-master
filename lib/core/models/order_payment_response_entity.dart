import 'package:veggi/generated/json/base/json_convert_content.dart';
import 'package:veggi/generated/json/base/json_field.dart';

class OrderPaymentResponseEntity with JsonConvert<OrderPaymentResponseEntity> {
	String status;
	OrderPaymentResponsePayment payment;
}

class OrderPaymentResponsePayment with JsonConvert<OrderPaymentResponsePayment> {
	String id;
	String entity;
	int amount;
	@JSONField(name: "amount_paid")
	int amountPaid;
	@JSONField(name: "amount_due")
	int amountDue;
	String currency;
	String receipt;
	@JSONField(name: "offer_id")
	dynamic offerId;
	String status;
	int attempts;
	List<dynamic> notes;
	@JSONField(name: "created_at")
	int createdAt;
}
