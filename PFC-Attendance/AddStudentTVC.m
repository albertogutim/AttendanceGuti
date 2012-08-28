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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.emailField.keyboardType=UIKeyboardTypeEmailAddress;
}

- (void)viewDidUnload
{
    
    [self setNameField:nil];
    [self setEmailField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*
- (void)viewWillAppear:(BOOL)animated
{
    
    ConfigHelper *configH = [ConfigHelper sharedInstance];
    if(configH.presentesDefecto)
        self.estado = 1;
    else
        self.estado = 2;
    
    
    [super viewWillAppear:animated];
}
*/



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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
