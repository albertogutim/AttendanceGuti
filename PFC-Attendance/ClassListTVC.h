//
//  ClassListTVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDocsHelper.h"
#import "ClassVC.h"
#import "PickerFirstVC.h"

@interface ClassListTVC : UITableViewController <GDocsHelperDelegate, PickerFirstVCDelegate>


-(IBAction)refreshData:(id)sender;
-(void) connectIntent;
@property (weak, nonatomic) IBOutlet UITableView *miTabla;
@property (strong, nonatomic) NSString *asignatura;
@property (strong, nonatomic) NSString *clase;
@property (strong, nonatomic) NSString *nombreClase;
@property (strong, nonatomic) NSString *nombreAsignatura;
@property (strong, nonatomic) NSDictionary *miListaClases;
@property (nonatomic, strong) NSDate *fecha;
@property (nonatomic, strong) NSDate *today;

@end
