# MercadoPago iOS SDK

The MercadoPago iOS SDK make it easy to collect your users' credit card details inside your iOS app. By creating [tokens](https://coming-soon), MercadoPago handles the bulk of PCI compliance by preventing sensitive card data from hitting your server.

## Installation

There are two ways to add Stripe to your project:

### Copy manually

1. Clone this repository ('git clone --recursive')
1. Open your project in xcode. In the menubar, click on 'File' then 'Add files to "Project"...'
1. Select the 'MercadoPagoMobileSDK' directory in your cloned mpmobile-ios_sdk repository
1. Make sure "Copy items into destination group's folder (if needed)" is checked
1. Click "Add"

### CocoaPods

Coming soon.

## Example app

Coming soon.

## Integration

First, you need a publishable key to collect a token. Send an email to developers@mercadopago.com to ask for your public key.

Once you have it:

[MercadoPago setPublishableKey:@"your_publishable_key"];

You can do this in your 'AppDelegate' in 'application:didFinishLaunchingWithOptions' method.

### Processing payments with Credit Card (simple way, no installments)

#### Argentina, Venezuela & Brasil

After showing your view, create and populate a 'MPCard' with the details you collected:

    MPCard *card = [[MPCard alloc] init];
    card.cardNumber = @"4509953566233704";
    card.expirationMonth = [NSNumber numberWithInt:12];
    card.expirationYear = [NSNumber numberWithInt:2020];
    card.securityCode = @"123";
	card.cardholderName = @"APRO Test user";
	card.cardholderIDType = @"DNI"; //Depends on the country. See MPUtils.h for possible values
	//card.cardholderIDSubType = @"J"; //Only for Venezuela. See MPUtils for possible values
	card.cardholderIDNumber = @"12345678";

Then send it to MercadoPago:

	 [MercadoPago createTokenWithCard:card
		                    onSuccess:^(MPCardToken *tokenResponse){
		                        //send tokenId, your customer email and whatever information needed to your server
								//to charge the user
		                    }
		                    onFailure:^(NSError *error){
		                        //Handle error, see MPError.h
		                    }
	]

#### México

Coming soon.

### Processing payments with Credit Card (a bit complex, with installments)

Coming soon.

### Processing payments with Debit Card

Coming soon (only in México)
								
## Using tokens

Once you've collected a token, you can send the tokenId to your server to charge immediately your customer.

From your server:
curl -X POST \
	 -H 'accept: application/json' \
	 -H 'content-type: application/json' \
	 https://api.mercadolibre.com/checkout/custom/create_payment?access_token=your_access_token \
	 -d '{
      "amount": 10,
      "reason": "Item Title",
      "installments": 1,
      "payment_code": "tokenId",
      "payer_email": "payer@email.com",
      "external_reference": "1234_your_reference"
	 }'

### Handling errors

See MPError.h

### Validation

You have a few options for handling validation of credit card data on the client, depending on what your application does.  Client-side validation of credit card data is not required since our API will correctly reject invalid card information, but can be useful to validate information as soon as a user enters it, or simply to save a network request.

The simplest thing you can do is to populate your 'MPCard' object and, before sending the request, call '- (BOOL)validateCardReturningError:' on the card.  This validates the entire card object, but is not useful for validating card properties one at a time.

To validate 'MPCard' properties individually, you should use the following:

     - (BOOL)validateCardNumber:error:
     - (BOOL)validateSecurityCode:error:
     - (BOOL)validateExpirationMonth:error:
     - (BOOL)validateExpirationYear:error:
	 - (BOOL)validateCardholderIDType:error:
	 - (BOOL)validateCardholderIDSubType:error:

These methods follow the validation method convention used by [key-value validation](http://developer.apple.com/library/mac/#documentation/cocoa/conceptual/KeyValueCoding/Articles/Validation.html).  So, you can use these methods by invoking them directly, or by calling '[card validateValue:forKey:error]' for a property on the 'STPCard' object.

When using these validation methods, you will want to set the property on your card object when a property does validate before validating the next property.  This allows the methods to use existing properties on the card correctly to validate a new property.  For example, validating '5' for the 'expirationMonth' property will return YES if no 'expirationYear' is set.  But if 'expirationYear' is set and you try to set 'expirationMonth' to 5 and the combination of 'expirationMonth' and 'expirationYear' is in the past, '5' will not validate.  The order in which you call the validate methods does not matter for this though.