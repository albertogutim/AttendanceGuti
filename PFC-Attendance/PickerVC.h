//
//  PickerVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 09/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDocsHelper.h"

@interface PickerVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, GDocsHelperDelegate>
@property (strong, nonatomic) IBOutlet UIPickerView *miPicker;

@property (nonatomic,strong) NSString *clase;
@property (nonatomic,strong) NSArray *fechas;

@end
