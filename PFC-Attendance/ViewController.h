//
//  ViewController.h
//  PFC-Attendance
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(nonatomic,strong)IBOutlet UIView *miVistaTunning;
@property (weak, nonatomic) IBOutlet UILabel *infoLbl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
