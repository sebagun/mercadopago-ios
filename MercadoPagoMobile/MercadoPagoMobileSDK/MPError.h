//
//  MPError.h
//  MercadoPagoMobile
//
//  Created by jgyonzo on 5/27/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>

// Mercadopago errors will have this domain
FOUNDATION_EXPORT NSString *const MercadoPagoDomain;

typedef enum MPErrorCode {
    MPHttpError = 20, // HTTP api call errors
    MPCardError = 30, // Credit card errors
    MPUnknownError = 40 //generic errors
} STPErrorCode;


/*
 Keys for 'userInfo' map in NSError:
 */
// A developer-friendly error message that explains what went wrong.
FOUNDATION_EXPORT NSString *const MPErrorMessageKey;
// What went wrong with your MPCard
FOUNDATION_EXPORT NSString *const MPCardErrorCodeKey;
// Which parameter on the MPCard had an error (e.g., "expirationMonth").
FOUNDATION_EXPORT NSString *const MPErrorParameterKey;
// Which was the http status error
FOUNDATION_EXPORT NSString *const MPHttpStatusKey;
// Which was the API response error
FOUNDATION_EXPORT NSString *const MPApiErrorResponseKey;


/*
 Possible values for 'MPCardErrorCodeKey'
 */
//MPCard possible errors:
FOUNDATION_EXPORT NSString *const MPInvalidCardNumber;
FOUNDATION_EXPORT NSString *const MPInvalidExpirationMonth;
FOUNDATION_EXPORT NSString *const MPInvalidExpirationYear;
FOUNDATION_EXPORT NSString *const MPInvalidSecurityCode;
FOUNDATION_EXPORT NSString *const MPInvalidCardholderName;
FOUNDATION_EXPORT NSString *const MPInvalidCardholderIDNumber;
FOUNDATION_EXPORT NSString *const MPInvalidCardholderIDType;
FOUNDATION_EXPORT NSString *const MPInvalidCardholderIDSubType;
FOUNDATION_EXPORT NSString *const MPExpiredCard;


/*
 Possible values for 'NSLocalizedDescriptionKey' in 'userInfo' of NSError
 */
//Api call errors
#define MPTokenApiCallErrorUserMessage NSLocalizedString(@"There was a problem processing your credit card info", @"Error when posting card data to create a token")
#define MPPaymentMethodApiCallErrorUserMessage NSLocalizedString(@"There was a problem getting payment method info for your card", @"Error when getting payment method info from API")

//Card number & security code errors
#define MPCardErrorInvalidNumberUserMessage NSLocalizedString(@"Your card's number is invalid", @"Error when the card number is not valid")
#define MPCardErrorInvalidSecurityCodeUserMessage NSLocalizedString(@"Your card's security code is invalid", @"Error when the card's CVC is not valid")

//Card date Errors
#define MPCardErrorInvalidExpMonthUserMessage NSLocalizedString(@"Your card's expiration month is invalid", @"Error when the card's expiration month is not valid")
#define MPCardErrorInvalidExpYearUserMessage NSLocalizedString(@"Your card's expiration year is invalid", @"Error when the card's expiration year is not valid")
#define MPCardErrorExpiredCardUserMessage NSLocalizedString(@"Your card has expired", @"Error when the card has already expired")

//Cardholder Errors
#define MPCardErrorInvalidCardholderNameUserMessage NSLocalizedString(@"Your name is invalid", @"Error when the cardholder's name is not valid")
#define MPCardErrorInvalidCardholderIDNumberUserMessage NSLocalizedString(@"Your identification number is invalid", @"Error when the cardholder's ID number is not valid")
#define MPCardErrorInvalidCardholderIDTypeUserMessage NSLocalizedString(@"Your identification type is invalid", @"Error when the cardholder's ID type is not valid")
#define MPCardErrorInvalidCardholderIDSubTypeUserMessage NSLocalizedString(@"Your identification sub type is invalid", @"Error when the cardholder's ID sub type is not valid")