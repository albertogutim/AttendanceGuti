//
//  ConfigTVC.h
//  PFC-Attendance
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigTVC : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *usrField;
- (IBAction)guardarChanged:(id)sender;

@end
