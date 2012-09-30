//
//  StadisticsVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 09/09/12.
//
//

#import <UIKit/UIKit.h>
#import "GDocsHelper.h" 
#import "MessageUI/MFMailComposeViewController.h"

@interface StadisticsVC : UIViewController <GDocsHelperDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSString *fecha;
@property (weak, nonatomic) IBOutlet UILabel *lblfecha;
@property (strong, nonatomic) IBOutlet UILabel *lblAsignaturaGrupo;
@property (strong, nonatomic) NSMutableDictionary *ausentes;
@property (strong, nonatomic) NSMutableDictionary *retrasos;
@property (strong, nonatomic) NSString *clase;
@property (strong, nonatomic) NSString *nombreClase;
@property (strong, nonatomic) NSString *nombreAsignatura;
@property (strong, nonatomic) NSMutableArray *ordenAusentes;
@property (strong, nonatomic) NSMutableArray *ordenRetrasos;
@property (strong, nonatomic) NSMutableArray *contadorAusentes;
@property (strong, nonatomic) NSMutableArray *contadorRetrasos;
@property (strong, nonatomic) IBOutlet UITableView *miTabla;
- (IBAction)sendMail:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ambosAusentesImpuntuales;

@end
