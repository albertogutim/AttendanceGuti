//
//  ViewController.h
//  PFC-Attendance
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDocsHelper.h"



@interface SubjectsListVC : UIViewController <GDocsHelperDelegate>

@property(nonatomic,strong)IBOutlet UIView *miVistaTunning;
@property (weak, nonatomic) IBOutlet UILabel *infoLbl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UITableView *listaTableView;
@property (strong, nonatomic) NSArray *miListaAsignaturas;
@property (weak, nonatomic) IBOutlet UITableView *miTabla;

@end
