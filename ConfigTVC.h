//
//  ConfigTVC.h
//  PFC-Attendance
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigTVC : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIStepper *stepperAusencias;
@property (strong, nonatomic) IBOutlet UILabel *stepperAusenciaslbl;

@property (strong, nonatomic) IBOutlet UIStepper *stepperRetrasos;
@property (strong, nonatomic) IBOutlet UILabel *stepperRetrasosLbl;

@property (strong, nonatomic) IBOutlet UISwitch *guardarSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *presentesSwitch;


@property (weak, nonatomic) IBOutlet UITextField *usrField;
@property (nonatomic, copy) NSString * stringUser;

@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic, copy) NSString * stringPass;

- (IBAction)guardarChanged:(id)sender;
- (IBAction)presentesChanged:(id)sender;
- (IBAction)masdeXretrasos:(id)sender;
- (IBAction)masdeXausencias:(id)sender;



@end
