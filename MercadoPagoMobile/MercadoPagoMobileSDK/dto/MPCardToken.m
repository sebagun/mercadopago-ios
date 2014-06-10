//
//  MPCardToken.m
//  MercadoPagoMobile
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPCardToken.h"

@implementation MPCardToken

- (instancetype) initFromDictionary: (NSDictionary *) dict
{
    if (self = [super init]) {
        self.cardId = [dict objectForKey:@"card_id"];
        self.luhnValidation = [(NSNumber *)[dict objectForKey:@"luhn_validation"] boolValue];
        self.status = [dict objectForKey:@"status"];
        self.usedDate = [dict objectForKey:@"used_date"];
        self.cardNumberLenght = [dict objectForKey:@"card_number_length"];
        self.tokenId = [dict objectForKey:@"id"];
        self.creationDate = [dict objectForKey:@"creation_date"];
        self.truncatedCardNumber = [dict objectForKey:@"trunc_card_number"];
        self.securityCodeLenght = [dict objectForKey:@"security_code_lenth"];
        self.expirationMonth = [dict objectForKey:@"expiration_month"];
        self.expirationYear = [dict objectForKey:@"expiration_year"];
        self.lastModifiedDate = [dict objectForKey:@"last_modified_date"];
        self.cardholderName = [(NSDictionary *)[dict objectForKey:@"cardholder"] objectForKey:@"name"];
        self.cardholderIDNumber = [(NSDictionary *)[(NSDictionary *)[dict objectForKey:@"cardholder"] objectForKey:@"identification"] objectForKey:@"number"];
        self.cardholderIDSubType = [(NSDictionary *)[(NSDictionary *)[dict objectForKey:@"cardholder"] objectForKey:@"identification"] objectForKey:@"subtype"];
        self.cardholderIDType = [(NSDictionary *)[(NSDictionary *)[dict objectForKey:@"cardholder"] objectForKey:@"identification"] objectForKey:@"type"];
        self.dueDate = [dict objectForKey:@"due_date"];
    }
    return self;
}

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
    [desc addObject:@", cardholderIDType: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.cardholderIDType]];
    [desc addObject:@", cardholderIDSubType: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.cardholderIDSubType]];
    [desc addObject:@", cardholderIDNumber: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.cardholderIDNumber]];
    [desc addObject:@" }"];
    
    return [desc componentsJoinedByString:@""];
}

@end
