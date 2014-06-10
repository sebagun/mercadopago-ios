//
//  MPError.m
//  MercadoPagoMobile
//
//  Created by jgyonzo on 5/27/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPError.h"

NSString *const MercadoPagoDomain = @"com.mercadopago.lib";

NSString *const MPCardErrorCodeKey = @"com.mercadopago.lib:CardErrorCodeKey";
NSString *const MPErrorMessageKey = @"com.mercadopago.lib:ErrorMessageKey";
NSString *const MPErrorParameterKey = @"com.mercadopago.lib:ErrorParameterKey";
NSString *const MPHttpStatusKey = @"com.mercadopago.lib:HttpStatusKey";
NSString *const MPApiErrorResponseKey= @"com.mercadopago.lib:ApiErrorResponseKey";

NSString *const MPInvalidCardNumber = @"com.mercadopago.lib:InvalidCardNumber";
NSString *const MPInvalidExpirationMonth = @"com.mercadopago.lib:InvalidExpirationMonth";
NSString *const MPInvalidExpirationYear = @"com.mercadopago.lib:InvalidExpirationYear";
NSString *const MPInvalidSecurityCode = @"com.mercadopago.lib:InvalidSecurityCode";
NSString *const MPInvalidCardholderName = @"com.mercadopago.lib:InvalidCardholderName";
NSString *const MPInvalidCardholderIDNumber = @"com.mercadopago.lib:InvalidCardholderIDNumber";
NSString *const MPInvalidCardholderIDType = @"com.mercadopago.lib:InvalidCardholderIDType";
NSString *const MPInvalidCardholderIDSubType = @"com.mercadopago.lib:InvalidCardholderIDSubType";
NSString *const MPExpiredCard = @"com.mercadopago.lib:ExpiredCard";