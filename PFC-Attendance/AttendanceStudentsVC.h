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
#import "ResumenVC.h"
#import "StudentVC.h"
#import "StadisticsVC.h"
#import "MessageUI/MFMailComposeViewController.h"

@interface AttendanceStudentsVC : UIViewController <GDocsHelperDelegate, UISearchDisplayDelegate, UISearchBarDelegate, PickerVCDelegate, AddStudentTVCDelegate, StudentVCDelegate, MFMailComposeViewControllerDelegate>
{


    UISearchDisplayController *searchDisplayController;
    UISearchBar *searchBar;
    NSMutableDictionary *searchResults;

}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *azButton;
    
- (IBAction)azButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)sendmail:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *mailbutton;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;

@property (strong, nonatomic) IBOutlet UISegmentedControl *todosPresentesAusentes;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *informesButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *randomButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *resumenButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *calendarButton;
@property (weak, nonatomic) IBOutlet UITableView *miTabla;
@property (strong, nonatomic) NSString *clase;
@property (strong, nonatomic) NSString *nombreClase;
@property (strong, nonatomic) NSString *nombreAsignatura;
@property (strong, nonatomic) NSMutableDictionary *miListaAlumnos;
@property (strong, nonatomic) NSMutableDictionary *searchResults;
@property (nonatomic, strong) NSDate *fecha;
@property (nonatomic, strong) NSDate *today;
@property (nonatomic, assign) NSInteger columna;
@property (strong, nonatomic) NSMutableDictionary *todos;
@property (strong, nonatomic) NSMutableDictionary *presentes;
@property (strong, nonatomic) NSMutableDictionary *ausentes;
@property (strong, nonatomic) NSString *alumno;
@property (strong, nonatomic) NSString *fechaCompleta;
@property (strong, nonatomic) NSMutableDictionary *alumnosConOrden;
@property (strong, nonatomic) NSArray *sortedKeys;
@property (strong, nonatomic) NSArray *sortedKeysSearch;
@property (assign, nonatomic) BOOL hacerEsto;
@property (assign, nonatomic) CGRect tamano;

- (IBAction)changeSegmentedControl:(id)sender;
-(NSMutableDictionary *) filtrarAusentes:(NSMutableDictionary *) alumnos;
-(NSMutableDictionary *) filtrarPresentes:(NSMutableDictionary *) alumnos;
-(NSMutableDictionary *) filtrarRetrasos: (NSMutableDictionary *) asistencias;

- (IBAction)updateSpreadsheet:(id)sender;
- (IBAction)randomStudent:(id)sender;
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;



@end
