//
//  ConfigTVC.m
//  PFC-Attendance
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfigTVC.h"
#import "./PFC-Attendance/ConfigHelper.h"

@implementation ConfigTVC
@synthesize passwordField = _passwordField;
@synthesize stepperAusencias = _stepperAusencias;
@synthesize stepperRetrasosLbl = _stepperRetrasosLbl;
@synthesize stepperAusenciaslbl = _stepperAusenciaslbl;
@synthesize presentesSwitch = _presentesSwitch;
@synthesize stepperRetrasos = _stepperRetrasos;
@synthesize guardarSwitch = _guardarSwitch;
@synthesize usrField = _usrField;
@synthesize stringUser = _stringUser;
@synthesize stringPass = _stringPass;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setUsrField:nil];
    [self setPasswordField:nil];
    [self setGuardarSwitch:nil];
    [self setStepperRetrasos:nil];
    [self setStepperAusencias:nil];
    [self setStepperRetrasosLbl:nil];
    [self setStepperAusenciaslbl:nil];
    [self setPresentesSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    //escribir en user/password labels los credenciales guardados en keychain
    //TODO: sacarlos del ConfigHelper
    
    ConfigHelper *ConfigH = [ConfigHelper sharedInstance];


    self.usrField.text = ConfigH.user;
    self.passwordField.text = ConfigH.password;
    
    if (([ConfigH.password length] != 0) && ([ConfigH.user length] != 0))
        [self.guardarSwitch setOn:YES];

    else

        [self.guardarSwitch setOn:NO];
     

    //escribir los limites de ausentes y retrasos guardados en NSUserdefaults
   self.stepperRetrasosLbl.text = [NSString stringWithFormat:@"%.f",  [[NSUserDefaults standardUserDefaults] doubleForKey:@"retrasos"]];
   self.stepperAusenciaslbl.text = [NSString stringWithFormat:@"%.f",  [[NSUserDefaults standardUserDefaults] doubleForKey:@"ausencias"]];
    
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"presentesDefecto"])
        [self.presentesSwitch setOn:YES];
    else
         [self.presentesSwitch setOn:NO];
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)guardarChanged:(id)sender {
    //guardamos usuario/contraseña usando keychain
    
    //guardamos lo que ha escrito el usuario
    self.stringUser = self.usrField.text;
    self.stringPass = self.passwordField.text;

    
    /*if(self.guardarSwitch.isOn)
    {
    
    //[keychainItem setObject:self.stringPass  forKey:(__bridge id)kSecValueData];
    //[keychainItem setObject:self.stringUser  forKey:(__bridge id)kSecAttrAccount];
       }
    else
      //  [keychainItem resetKeychainItem];
     */
           
}
- (IBAction)presentesChanged:(id)sender {
    
    if (self.presentesSwitch.isOn)
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"presentesDefecto"];
    else
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"presentesDefecto"];
}
- (IBAction)masdeXretrasos:(id)sender {
    
    double stepperValue = self.stepperRetrasos.value;
    self.stepperRetrasosLbl.text = [NSString stringWithFormat:@"%.f", stepperValue];
    [[NSUserDefaults standardUserDefaults]setDouble:stepperValue forKey:@"retrasos"];
 
}
- (IBAction)masdeXausencias:(id)sender {
    
    double stepperValue = self.stepperAusencias.value;
    self.stepperAusenciaslbl.text = [NSString stringWithFormat:@"%.f", stepperValue];
    [[NSUserDefaults standardUserDefaults]setDouble:stepperValue forKey:@"ausencias"];

}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	// When the user presses return, take focus away from the text field so that the keyboard is dismissed.
	if (theTextField == self.usrField) {
        //guardamos lo que ha escrito el usuario
        self.stringUser = self.usrField.text;
		[self.usrField resignFirstResponder];
    }
    
    if (theTextField == self.passwordField) {
        self.stringPass = self.passwordField.text;
        self.stringUser = self.usrField.text;
        [self.passwordField resignFirstResponder];
    }
	return YES;
}

@end
