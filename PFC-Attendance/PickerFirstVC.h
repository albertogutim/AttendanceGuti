//
//  PickerFirstVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 06/10/12.
//
//

#import <UIKit/UIKit.h>
#import "AttendanceStudentsVC.h"
#import "GDocsHelper.h"

@class PickerFirstVC;

@protocol PickerFirstVCDelegate <NSObject>

-(void) devolverFecha: (PickerFirstVC *) controller didSelectDate: (NSDate *) date hoyEs:(NSDate *) today;
-(void) termino: (PickerFirstVC *) controller;

@end

@interface PickerFirstVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, GDocsHelperDelegate>

- (IBAction)cancelarFecha:(id)sender;
- (IBAction)aceptarfecha:(id)sender;

@property (strong, nonatomic) IBOutlet UIPickerView *miPicker;

@property (nonatomic,strong) NSString *clase;
@property (nonatomic,strong) NSArray *fechas;
@property (nonatomic, strong) NSDate *fecha;
@property (nonatomic, strong) NSDate *today;
@property (strong, nonatomic) NSString *nombreClase;
@property (strong, nonatomic) NSString *nombreAsignatura;
@property (assign, nonatomic) int contador;
@property (nonatomic, weak) id <PickerFirstVCDelegate> delegate;
@end
