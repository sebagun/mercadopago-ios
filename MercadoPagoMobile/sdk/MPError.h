//
//  MPError.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/27/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>

// Mercadopago errors will have this domain
FOUNDATION_EXPORT NSString *const MercadoPagoDomain;

typedef enum MPErrorCode {
    MPBinError = 10, //error with Card bin
    MPHttpError = 20, // HTTP api call errors
    MPCardError = 30, // Credit card errors
    MPUnknownError = 40 //generic errors
} STPErrorCode;

// A developer-friendly error message that explains what went wrong.
FOUNDATION_EXPORT NSString *const MPErrorMessageKey;

// What went wrong with your MPCard
FOUNDATION_EXPORT NSString *const MPCardErrorCodeKey;

// Which parameter on the MPCard had an error (e.g., "expirationMonth").
FOUNDATION_EXPORT NSString *const MPErrorParameterKey;

// Which was the http status error
FOUNDATION_EXPORT NSString *const MPHttpStatusKey;

// Which was the http status error
FOUNDATION_EXPORT NSString *const MPApiErrorResponseKey;

//MPCard possible errors:
FOUNDATION_EXPORT NSString *const MPInvalidCardNumber;
FOUNDATION_EXPORT NSString *const MPInvalidExpirationMonth;
FOUNDATION_EXPORT NSString *const MPInvalidExpirationYear;
FOUNDATION_EXPORT NSString *const MPInvalidSecurityCode;
FOUNDATION_EXPORT NSString *const MPExpiredCard;

#define MPTokenApiCallErrorUserMessage NSLocalizedString(@"There was a problem processing your credit card info", @"Error when posting card data to create a token")
#define MPPaymentMethodApiCallErrorUserMessage NSLocalizedString(@"There was a problem processing your credit card info", @"Error when posting card data to create a token")
#define MPCardErrorInvalidNumberUserMessage NSLocalizedString(@"Your card's number is invalid", @"Error when the card number is not valid")
#define MPCardErrorInvalidSecurityCodeUserMessage NSLocalizedString(@"Your card's security code is invalid", @"Error when the card's CVC is not valid")
#define MPCardErrorInvalidExpMonthUserMessage NSLocalizedString(@"Your card's expiration month is invalid", @"Error when the card's expiration month is not valid")
#define MPCardErrorInvalidExpYearUserMessage NSLocalizedString(@"Your card's expiration year is invalid", @"Error when the card's expiration year is not valid")
#define MPCardErrorExpiredCardUserMessage NSLocalizedString(@"Your card has expired", @"Error when the card has already expired")
