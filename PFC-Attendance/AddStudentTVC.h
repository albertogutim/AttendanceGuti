//
//  AddStudentTVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 28/08/12.
//
//

#import <UIKit/UIKit.h>

@class AddStudentTVC;

@protocol AddStudentTVCDelegate <NSObject>

-(void) devolverDatosAlumno: (AddStudentTVC *) controller conNombre: (NSString *) nombre yEmail: (NSString *) mail yEstado: (NSInteger) estado;

@end


@interface AddStudentTVC : UITableViewController <UITextFieldDelegate>
- (IBAction)done:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (assign, nonatomic) NSInteger estado;
@property (nonatomic, weak) id <AddStudentTVCDelegate> delegate;
@end