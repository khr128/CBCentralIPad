//
//  BTCViewController.h
//  BTCentralPad
//
//  Created by khr on 4/20/14.
//  Copyright (c) 2014 khr. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreBluetooth;

@interface BTCViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>
- (IBAction)scan:(UIButton *)sender;

@end
