//
//  ResumenesVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 13/09/12.
//
//

#import <UIKit/UIKit.h>
#import "MessageUI/MFMailComposeViewController.h"
#import "ResumenSeleccionadoVC.h"

@interface ResumenesVC : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *resumenes;
@property (strong, nonatomic) NSArray *fechas;
@property (strong, nonatomic) NSString *nombreClase;
@property (strong, nonatomic) NSString *nombreAsignatura;
@property (strong, nonatomic) NSString *resumenSeleccionado;
@property (strong, nonatomic) NSString *fecharesumen;


- (IBAction)enviarResumenes:(id)sender;

@end
