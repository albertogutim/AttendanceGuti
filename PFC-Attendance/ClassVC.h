//
//  ClassVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 12/09/12.
//
//

#import <UIKit/UIKit.h>
#import "GDocsHelper.h" 
#import "StudentVC.h"
#import "ResumenesVC.h"

@interface ClassVC : UIViewController <GDocsHelperDelegate, StudentVCDelegate>

@property (strong, nonatomic) IBOutlet UILabel *classLbl;
@property (strong, nonatomic) IBOutlet UITableView *miTabla;

@property (strong, nonatomic) NSString *nombreClase;
@property (strong, nonatomic) NSString *nombreAsignatura;
@property (strong, nonatomic) NSString *clase;
@property (strong, nonatomic) NSMutableArray *todos;
@property (assign, nonatomic) NSInteger cuantos;
@property (strong, nonatomic) NSString *alumno;
@property (strong, nonatomic) NSString *mail;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger contadorAusenciasGlobal;
@property (assign, nonatomic) NSInteger contadorPresenciasGlobal;
@property (assign, nonatomic) NSInteger contadorNoMatriculadoGlobal;
@property (strong, nonatomic) NSMutableArray *ausenciasArray;
@property (strong, nonatomic) NSMutableArray *presenciasArray;
@property (strong, nonatomic) NSMutableArray *noMatriculadosArray;
@property (strong, nonatomic) NSArray *fechas;
@property (strong, nonatomic) NSArray *sortedKeys;
@property (strong, nonatomic) NSMutableArray *nombres;




@end
