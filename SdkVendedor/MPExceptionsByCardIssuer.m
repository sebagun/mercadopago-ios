//
//  MPExceptionsByCardIssuerInfo.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPExceptionsByCardIssuer.h"
#import "MPUtils.h"

@implementation MPExceptionsByCardIssuer

- (instancetype) initFromDictionary: (NSDictionary *) dict
{
    if (self = [super init]){
        MPCardIssuer *issuer = [[MPCardIssuer alloc]initFromDictionary:[dict objectForKey:@"card_issuer"]];
        self.issuerInfo = issuer;
        self.labels = [dict objectForKey:@"label"];
        self.thumbnail = [dict objectForKey:@"thumbnail"];
        self.secureThumbnail = [dict objectForKey:@"secure_thumbnail"];
        self.payerCosts = [MPUtils payerCostsFromJson:[dict objectForKey:@"payer_costs"]];
        self.acceptedBins = [dict objectForKey:@"accepted_bins"];
        self.totalFinantialCost = [dict objectForKey:@"total_financial_cost"];
    }
    return self;
}

@end
