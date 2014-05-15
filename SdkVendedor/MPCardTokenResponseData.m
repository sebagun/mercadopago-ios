//
//  MPCardInfo.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPCardTokenResponseData.h"

@implementation MPCardTokenResponseData

/*
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
 */

- (NSString *) description
{
    NSMutableArray *desc = [[NSMutableArray alloc]init];
    [desc addObject:@"{ tokenId: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.tokenId]];
    [desc addObject:@", expirationMonth: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.expirationMonth]];
    [desc addObject:@", expirationYear: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.expirationYear]];
    [desc addObject:@", truncatedCardNumber: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.truncatedCardNumber]];
    [desc addObject:@", cardNumberLenght: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.cardNumberLenght]];
    [desc addObject:@", securityCodeLenght: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.securityCodeLenght]];
    [desc addObject:@", luhnValidation: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.luhnValidation?@"true":@"false"]];
    [desc addObject:@", status: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.status]];
    [desc addObject:@", usedDate: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.usedDate]];
    [desc addObject:@", creationDate: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.creationDate]];
    [desc addObject:@", lastModifiedDate: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.lastModifiedDate]];
    [desc addObject:@", dueDate: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.dueDate]];
    [desc addObject:@", cardholderName: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.cardholderName]];
    [desc addObject:@", docType: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.docType]];
    [desc addObject:@", docSubType: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.docSubType]];
    [desc addObject:@", docNumber: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.docNumber]];
    [desc addObject:@" }"];
    
    return [desc componentsJoinedByString:@""];
}

@end
