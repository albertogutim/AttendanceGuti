//
//  AttendanceStudentsVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDocsHelper.h"

@interface AttendanceStudentsVC : UIViewController <GDocsHelperDelegate>

@property (weak, nonatomic) IBOutlet UITableView *miTabla;
@property (strong, nonatomic) NSString *clase;
@property (strong, nonatomic) NSDictionary *miListaAlumnos;

@end
