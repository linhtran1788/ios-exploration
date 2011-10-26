//
//  NTCNavController.h
//  NTC
//
//  Created by Kaijie Yu on 10/24/11.
//  Copyright (c) 2011 thePlant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppInfo.h"

@interface NTCNavController : UINavigationController <AppInfoViewControllerDelegate>

- (IBAction)showInfo:(id)sender;

@end