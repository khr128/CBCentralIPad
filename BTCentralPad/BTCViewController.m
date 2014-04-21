//
//  BTCViewController.m
//  BTCentralPad
//
//  Created by khr on 4/20/14.
//  Copyright (c) 2014 khr. All rights reserved.
//

#import "BTCViewController.h"

@interface BTCViewController ()

@end

@implementation BTCViewController {
  CBCentralManager *_centralManager;
  CBPeripheral *_periferal;
  CBUUID *_serviceUUID, *_characteristicUUID;
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
  _serviceUUID = [CBUUID UUIDWithString:@"53C51B97-B2F4-4EB6-B485-3A3595FBFCD2"];
  _characteristicUUID = [CBUUID UUIDWithString:@"3C57404F-B7CD-45C4-9ECF-707EE0528996"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scan:(UIButton *)sender {
  [_centralManager scanForPeripheralsWithServices:@[_serviceUUID] options:nil];
}

#pragma mark -
#pragma mark CoreBluetooth Central Manager

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  NSLog(@"Central manager state changed");
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
  NSLog(@"Discovered %@", peripheral.name);
  _periferal = peripheral;
  [central connectPeripheral:peripheral options:nil];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
  peripheral.delegate = self;
  [peripheral discoverServices:@[_serviceUUID]];
//  [peripheral discoverServices:nil];
}

#pragma mark -
#pragma mark CBPeriferalDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
  for (CBService *service in peripheral.services) {
    NSLog(@"Discovered service %@", service);
    [peripheral discoverCharacteristics:nil forService:service];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
  for (CBCharacteristic *characteristic in service.characteristics) {
    NSLog(@"Discovered characteristic %@", characteristic);
    [peripheral readValueForCharacteristic:characteristic];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
  NSData *data = characteristic.value;
  NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  NSLog(@"Value: %@", message);
}
@end
