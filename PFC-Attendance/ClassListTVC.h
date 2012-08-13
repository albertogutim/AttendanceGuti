//
//  ClassListTVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDocsHelper.h"
#import "AttendanceStudentsVC.h"

@interface ClassListTVC : UITableViewController <GDocsHelperDelegate>


- (IBAction)refreshData:(id)sender;
-(void) connectIntent;
@property (weak, nonatomic) IBOutlet UITableView *miTabla;
@property (strong, nonatomic) NSString *asignatura;
@property (strong, nonatomic) NSString *clase;
@property (strong, nonatomic) NSDictionary *miListaClases;

@end
