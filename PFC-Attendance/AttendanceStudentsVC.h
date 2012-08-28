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
#import "AddStudentTVC.h"

@interface AttendanceStudentsVC : UIViewController <GDocsHelperDelegate, UISearchDisplayDelegate, UISearchBarDelegate, PickerVCDelegate, AddStudentTVCDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *todosPresentesAusentes;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *attendanceButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *informesButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *randomButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *resumenButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *calendarButton;

@property (weak, nonatomic) IBOutlet UITableView *miTabla;
@property (strong, nonatomic) NSString *clase;
@property (strong, nonatomic) NSMutableDictionary *miListaAlumnos;
@property (nonatomic, strong) NSDate *fecha;
@property (nonatomic, strong) NSDate *today;
@property (nonatomic, assign) NSInteger columna;
@property (strong, nonatomic) NSMutableDictionary *todos;
- (IBAction)attendance:(id)sender;
- (IBAction)changeSegmentedControl:(id)sender;
-(NSMutableDictionary *) filtrarAusentes:(NSMutableDictionary *) alumnos;
-(NSMutableDictionary *) filtrarPresentes:(NSMutableDictionary *) alumnos;

- (IBAction)updateSpreadsheet:(id)sender;



@end
