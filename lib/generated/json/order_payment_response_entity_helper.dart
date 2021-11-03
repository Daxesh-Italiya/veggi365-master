import 'package:veggi/core/models/order_payment_response_entity.dart';

orderPaymentResponseEntityFromJson(OrderPaymentResponseEntity data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status'].toString();
	}
	if (json['payment'] != null) {
		data.payment = OrderPaymentResponsePayment().fromJson(json['payment']);
	}
	return data;
}

Map<String, dynamic> orderPaymentResponseEntityToJson(OrderPaymentResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['payment'] = entity.payment?.toJson();
	return data;
}

orderPaymentResponsePaymentFromJson(OrderPaymentResponsePayment data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['entity'] != null) {
		data.entity = json['entity'].toString();
	}
	if (json['amount'] != null) {
		data.amount = json['amount'] is String
				? int.tryParse(json['amount'])
				: json['amount'].toInt();
	}
	if (json['amount_paid'] != null) {
		data.amountPaid = json['amount_paid'] is String
				? int.tryParse(json['amount_paid'])
				: json['amount_paid'].toInt();
	}
	if (json['amount_due'] != null) {
		data.amountDue = json['amount_due'] is String
				? int.tryParse(json['amount_due'])
				: json['amount_due'].toInt();
	}
	if (json['currency'] != null) {
		data.currency = json['currency'].toString();
	}
	if (json['receipt'] != null) {
		data.receipt = json['receipt'].toString();
	}
	if (json['offer_id'] != null) {
		data.offerId = json['offer_id'];
	}
	if (json['status'] != null) {
		data.status = json['status'].toString();
	}
	if (json['attempts'] != null) {
		data.attempts = json['attempts'] is String
				? int.tryParse(json['attempts'])
				: json['attempts'].toInt();
	}
	if (json['notes'] != null) {
		data.notes = (json['notes'] as List).map((v) => v).toList().cast<dynamic>();
	}
	if (json['created_at'] != null) {
		data.createdAt = json['created_at'] is String
				? int.tryParse(json['created_at'])
				: json['created_at'].toInt();
	}
	return data;
}

Map<String, dynamic> orderPaymentResponsePaymentToJson(OrderPaymentResponsePayment entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['entity'] = entity.entity;
	data['amount'] = entity.amount;
	data['amount_paid'] = entity.amountPaid;
	data['amount_due'] = entity.amountDue;
	data['currency'] = entity.currency;
	data['receipt'] = entity.receipt;
	data['offer_id'] = entity.offerId;
	data['status'] = entity.status;
	data['attempts'] = entity.attempts;
	data['notes'] = entity.notes;
	data['created_at'] = entity.createdAt;
	return data;
}