//
//  AddStudentTVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 27/08/12.
//
//

#import <UIKit/UIKit.h>

@class AddStudentTVC;

@protocol AddStudentTVCDelegate <NSObject>

-(void) devolverDatosAlumno: (AddStudentTVC *) controller conNombre: (NSString *) nombre yEmail: (NSString *) mail;

@end


@interface AddStudentTVC : UITableViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (nonatomic, weak) id <AddStudentTVCDelegate> delegate;

@end
