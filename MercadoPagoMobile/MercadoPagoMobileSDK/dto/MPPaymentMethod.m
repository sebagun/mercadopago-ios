//
//  MPPaymentMethod.m
//  MercadoPagoMobile
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPPaymentMethod.h"
#import "MPUtils.h"

@implementation MPPaymentMethod

- (NSString *) description
{
    NSMutableArray *desc = [[NSMutableArray alloc]init];
    [desc addObject:@"{ paymentMethodId: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.paymentMethodId]];
    [desc addObject:@", name: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.name]];
    [desc addObject:@", paymentTypeId: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.paymentTypeId]];
    [desc addObject:@", siteId: "];
    [desc addObject:[NSString stringWithFormat:@"%@",self.siteId]];
    
    return [desc componentsJoinedByString:@""];
}

- (instancetype) initFromDictionary: (NSDictionary *) dict
{
    if (self = [super init]) {
        self.paymentMethodId = [dict objectForKey:@"id"];
        self.name = [dict objectForKey:@"name"];
        self.paymentTypeId = [dict objectForKey:@"payment_type_id"];
        self.issuer = [[MPCardIssuer alloc] initFromDictionary:[dict objectForKey:@"card_issuer"]];
        self.siteId = [dict objectForKey:@"site_id"];
        self.secureThumbnail = [dict objectForKey:@"secure_thmubnail"];
        self.thumbnail = [dict objectForKey:@"thumbnail"];
        self.labels = [dict objectForKey:@"labels"];
        self.minAccreditationDays = [dict objectForKey:@"min_accreditation_days"];
        self.maxAccreditationDays = [dict objectForKey:@"max_accreditation_days"];
        self.payerCosts = [MPUtils payerCostsFromJson:[dict objectForKey:@"payer_costs"]];
        self.exceptionsByCardIssuer = [MPUtils exceptionsByCardIssuerFromJson:[dict objectForKey:@"exceptions_by_card_issuer"]];
        self.cardConfiguration = [MPUtils cardConfigurationFromJson:[dict objectForKey:@"card_configuration"]];
    }
    return self;
}

@end
