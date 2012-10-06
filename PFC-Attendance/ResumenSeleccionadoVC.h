//
//  ResumenSeleccionadoVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 13/09/12.
//
//

#import <UIKit/UIKit.h>

@interface ResumenSeleccionadoVC : UIViewController


@property (strong, nonatomic) NSString *nombreClase;
@property (strong, nonatomic) NSString *nombreAsignatura;
@property (strong, nonatomic) NSString *fechaResumen;
@property (strong, nonatomic) NSString *resumenSeleccionado;

@property (strong, nonatomic) IBOutlet UILabel *nombreAsignaturaGrupolbl;
@property (strong, nonatomic) IBOutlet UILabel *fechalbl;
@property (strong, nonatomic) IBOutlet UITextView *resumenView;

@end
