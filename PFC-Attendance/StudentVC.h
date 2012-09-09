//
//  StudentVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 04/09/12.
//
//

#import <UIKit/UIKit.h>
#import "GDocsHelper.h"

@interface StudentVC : UIViewController <GDocsHelperDelegate>

@property (strong, nonatomic) NSString *alumno;
@property (strong, nonatomic) NSString *clase;
@property (strong, nonatomic) NSString *mail;
@property (strong, nonatomic) NSString *ausencias;
@property (assign, nonatomic) NSInteger cuantasAusencias;
@property (assign, nonatomic) NSInteger cuantosRetrasos;
@property (assign, nonatomic) NSInteger row;
@property (strong, nonatomic) IBOutlet UITableView *datosAlumnoTable;
@property (strong, nonatomic) NSDictionary *pintar;
@property (strong, nonatomic) NSMutableDictionary *pintarAusencias;
@property (strong, nonatomic) NSMutableDictionary *pintarRetrasos;
@property (strong, nonatomic) NSArray *datosAlumno;

- (IBAction)eliminarAlumno:(id)sender;

-(NSMutableDictionary *) filtrarAusentes: (NSMutableDictionary *) asistencias;
-(NSMutableDictionary *) filtrarRetrasos: (NSMutableDictionary *) asistencias;

@end
