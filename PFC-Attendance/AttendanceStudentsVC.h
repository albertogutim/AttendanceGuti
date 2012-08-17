//
//  AttendanceStudentsVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDocsHelper.h"
#import "PickerVC.h"

@interface AttendanceStudentsVC : UIViewController <GDocsHelperDelegate, UISearchDisplayDelegate, UISearchBarDelegate, PickerVCDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *attendanceButton;

@property (weak, nonatomic) IBOutlet UITableView *miTabla;
@property (strong, nonatomic) NSString *clase;
@property (strong, nonatomic) NSMutableDictionary *miListaAlumnos;
@property (nonatomic, strong) NSDate *fecha;
@property (nonatomic, assign) NSInteger columna;
@property (strong, nonatomic) NSMutableDictionary *todos;
@property (strong, nonatomic) NSMutableDictionary *ausentes;
@property (strong, nonatomic) NSMutableDictionary *presentes;



@end
