//
//  StudentVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 04/09/12.
//
//

#import <UIKit/UIKit.h>
#import "GDocsHelper.h"
#import "MessageUI/MFMailComposeViewController.h"

@class StudentVC;

@protocol StudentVCDelegate <NSObject>

-(void) devolverTabla: (StudentVC *) controller huboCambios: (int) cambios;

@end

@interface StudentVC : UIViewController <GDocsHelperDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate>


@property (strong, nonatomic) NSString *alumno;
@property (strong, nonatomic) NSString *clase;
@property (strong, nonatomic) NSString *nombreClase;
@property (strong, nonatomic) NSString *nombreAsignatura;
@property (strong, nonatomic) NSString *mail;
@property (strong, nonatomic) NSString *ausencias;
@property (assign, nonatomic) NSInteger cuantasAusencias;
@property (assign, nonatomic) NSInteger cuantosRetrasos;
@property (assign, nonatomic) NSInteger row;
@property (strong, nonatomic) IBOutlet UITableView *datosAlumnoTable;
@property (strong, nonatomic) NSDictionary *pintar;
@property (strong, nonatomic) NSMutableDictionary *pintarAusencias;
@property (strong, nonatomic) NSMutableDictionary *pintarRetrasos;
@property (assign, nonatomic) BOOL cambios;
@property (strong, nonatomic) NSMutableArray *sortedAusencias;
@property (strong, nonatomic) NSMutableArray *sortedRetrasos;
@property (nonatomic, weak) id <StudentVCDelegate> delegate;
//@property (strong, nonatomic) NSMutableArray *fechasAusencias;
//@property (strong, nonatomic) NSMutableArray *fechasRetrasos;
@property (assign, nonatomic) BOOL deTxtField;
- (IBAction)mailButtonAction:(id)sender;

-(NSMutableDictionary *) filtrarAusentes: (NSMutableDictionary *) asistencias;
-(NSMutableDictionary *) filtrarRetrasos: (NSMutableDictionary *) asistencias;

@end
