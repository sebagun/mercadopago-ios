//
//  MPCardIssuer.m
//  MercadoPagoMobile
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPCardIssuer.h"

@implementation MPCardIssuer

- (instancetype) initFromDictionary: (NSDictionary *) dict
{
    if (self = [super init]) {
        self.issuerId = [[dict objectForKey:@"card_issuer"]objectForKey:@"id"];
        self.name = [[dict objectForKey:@"card_issuer"]objectForKey:@"name"];
    }
    return self;
}

@end
