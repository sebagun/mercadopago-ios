//
//  MPCheckout.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/7/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPJSONRestClient.h"
#import "MPCardTokenRequestData.h"
#import "MPCardTokenResponseData.h"
#import "MPPaymentMethodInfo.h"

@interface MercadoPago : NSObject

//Your MercadoPago public key
@property (nonatomic,strong) NSString *publishableKey;

//gets the payment method info for the card bin (first six numbers)
- (void) paymentMethodInfoForCardBin:(NSString *) bin onSuccess:(void (^)(MPPaymentMethodInfo *)) success onFailure:(void (^)(NSError *)) failure;

//creates a Card Token with the collected card info (post the info to our servers). You will later need this token to create a payment
- (void) createTokenWithCardInfo:(MPCardTokenRequestData *) info onSuccess:(void (^)(MPCardTokenResponseData *)) success onFailure:(void (^)(NSError *)) failure;

@end
