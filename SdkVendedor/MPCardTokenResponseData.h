//
//  MPCardInfo.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPCardTokenResponseData : NSObject

@property (nonatomic, strong) NSString *tokenId;
@property (nonatomic, strong) NSNumber *expirationMonth;
@property (nonatomic, strong) NSNumber *expirationYear;
@property (nonatomic, strong) NSString *cardId;
@property (nonatomic, strong) NSString *truncatedCardNumber;
@property (nonatomic, strong) NSNumber *cardNumberLenght;
@property (nonatomic, strong) NSNumber *securityCodeLenght;
@property (nonatomic) BOOL luhnValidation;
@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *usedDate;
@property (nonatomic, strong) NSString *creationDate;
@property (nonatomic, strong) NSString *lastModifiedDate;
@property (nonatomic, strong) NSString *dueDate;

@property (nonatomic, strong) NSString *cardholderName;
@property (nonatomic, strong) NSString *docType;
@property (nonatomic, strong) NSString *docSubType;
@property (nonatomic, strong) NSString *docNumber;

- (NSString *) description;

@end
