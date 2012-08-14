//
//  PickerVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 09/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDocsHelper.h"

@class PickerVC;

@protocol PickerVCDelegate <NSObject>

-(void) devolverFecha: (PickerVC *) controller didSelectDate: (NSDate *) date;

@end


@interface PickerVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, GDocsHelperDelegate>

- (IBAction)aceptarFecha:(id)sender;
- (IBAction)cancelarFecha:(id)sender;

@property (strong, nonatomic) IBOutlet UIPickerView *miPicker;

@property (nonatomic,strong) NSString *clase;
@property (nonatomic,strong) NSArray *fechas;
@property (nonatomic, strong) NSDate *fecha;
@property (nonatomic, strong) NSDate *today;

@property (nonatomic, weak) id <PickerVCDelegate> delegate;



@end
