//
//  AddStudentTVC.m
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 27/08/12.
//
//

#import "AddStudentTVC.h"
#import "ConfigHelper.h"


@interface AddStudentTVC ()

@end

@implementation AddStudentTVC
@synthesize nameField = _nameField;
@synthesize emailField = _emailField;
@synthesize estado = _estado;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.emailField.keyboardType=UIKeyboardTypeEmailAddress;
}

- (void)viewDidUnload
{
    
    [self setNameField:nil];
    [self setEmailField:nil];
    [super viewDidUnload];
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark - Text Field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	// When the user presses return, take focus away from the text field so that the keyboard is dismissed.
	if (theTextField == self.nameField) {
		[self.nameField resignFirstResponder];
    }
    
    if (theTextField == self.emailField) {
        [self.emailField resignFirstResponder];
    }
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    //Quitamos espacios en blanco por delante y por detrás
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
    
}

- (IBAction)done:(id)sender {
    
    [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (([self.nameField.text length] ==0)||([self.emailField.text length] ==0))
    {
        UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle: NSLocalizedString(@"BLANK_ERROR", nil)
                                                             message: NSLocalizedString(@"BLANK_MSG", nil)
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"OK",nil];
        
        [alertView show];
        
    }
    else
    {
        if (([self.nameField.text length] !=0)&&([self.emailField.text length] !=0))
        [self.delegate devolverDatosAlumno:self conNombre:self.nameField.text yEmail:self.emailField.text yEstado: self.estado];

    }

}
@end
