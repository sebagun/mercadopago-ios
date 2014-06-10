//
//  MPResultViewController.m
//  MercadoPagoMobile
//
//  Created by jgyonzo on 5/8/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPResultViewController.h"

@interface MPResultViewController ()

@property (weak, nonatomic) IBOutlet UITextView *resultTextView;

@end

@implementation MPResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) setResultInfo: (NSString *) info
{
    
    self.resultTextView.text = info;
}

@end
