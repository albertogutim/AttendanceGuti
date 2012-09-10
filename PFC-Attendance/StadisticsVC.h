//
//  StadisticsVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 09/09/12.
//
//

#import <UIKit/UIKit.h>
#import "GDocsHelper.h" 

@interface StadisticsVC : UIViewController <GDocsHelperDelegate>

@property (strong, nonatomic) NSString *fecha;
@property (weak, nonatomic) IBOutlet UILabel *lblfecha;
@property (strong, nonatomic) NSMutableDictionary *ausentes;
@property (strong, nonatomic) NSMutableDictionary *retrasos;
@property (strong, nonatomic) NSString *clase;
@property (strong, nonatomic) NSMutableArray *ordenAusentes;
@property (strong, nonatomic) NSMutableArray *ordenRetrasos;
@property (strong, nonatomic) NSMutableArray *contadorAusentes;
@property (strong, nonatomic) NSMutableArray *contadorRetrasos;
@property (strong, nonatomic) IBOutlet UITableView *miTabla;

@end
