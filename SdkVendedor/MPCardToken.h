//
//  MPCardInfo.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Card tokens are created with [MercadoPago createTokenWithCard:]
 You should not construct these yourself.
 */
@interface MPCardToken : NSObject

@property (nonatomic, strong) NSString *tokenId;
@property (nonatomic, strong) NSNumber *expirationMonth;
@property (nonatomic, strong) NSNumber *expirationYear;
@property (nonatomic, strong) NSString *cardId;
@property (nonatomic, strong) NSString *truncatedCardNumber;
@property (nonatomic, strong) NSNumber *cardNumberLenght;
@property (nonatomic, strong) NSNumber *securityCodeLenght;

/*
 Tells you if you need to check luhn validation
 */
@property (nonatomic) BOOL luhnValidation;

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *usedDate;
@property (nonatomic, strong) NSString *creationDate;
@property (nonatomic, strong) NSString *lastModifiedDate;
@property (nonatomic, strong) NSString *dueDate;

/*
 Cardholder data
 */
@property (nonatomic, strong) NSString *cardholderName;
@property (nonatomic, strong) NSString *cardholderIDType;
@property (nonatomic, strong) NSString *cardholderIDSubType;
@property (nonatomic, strong) NSString *cardholderIDNumber;

/*
 This method should not be invoked in your code. This is used by MercadoPago to
 create tokens using a MercadoPago API response
 */
- (instancetype) initFromDictionary: (NSDictionary *) dict;

@end
