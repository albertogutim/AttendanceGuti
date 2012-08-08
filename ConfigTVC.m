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
    
    //TODO: cambiar labels dependiendo del idioma

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

    //escribir en user/password labels los credenciales guardados en keychain
    //sacarlos del ConfigHelper
    
       
    ConfigHelper *configH = [ConfigHelper sharedInstance];
    
    
    self.usrField.text = configH.user;
    self.passwordField.text = configH.password;
    
    //poner el siwtch encendido si hay credenciales guardados
    if (configH.hasCredentials)
        [self.guardarSwitch setOn:YES];
    else
        [self.guardarSwitch setOn:NO];
    
    
    //escribir los limites de ausentes y retrasos guardados en NSUserdefaults accediendo a ConfigHelper.
    self.stepperRetrasosLbl.text = [NSString stringWithFormat:@"%.f",  configH.retrasos];
    self.stepperAusenciaslbl.text = [NSString stringWithFormat:@"%.f",  configH.ausencias];
    
    
    //poner el switch a ON si esta guardado que los alumnos se muestran presentes por defecto
    if (configH.presentesDefecto)
        [self.presentesSwitch setOn:YES];
    else
        [self.presentesSwitch setOn:NO];

    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
        
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    ConfigHelper *configH = [ConfigHelper sharedInstance];
    
    //Quitamos espacios en blanco por delante y por detrás
    [self.usrField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([self.usrField.text isEqualToString:@""])
    {
        if (self.usrField == self.usrField)
            configH.user = nil;
        
        if(self.usrField == self.passwordField)
            configH.password = nil;
        
    } else {
        
        if (self.usrField == self.usrField)
            configH.user = self.usrField.text;
        
        if(self.usrField == self.passwordField)
            configH.password = self.passwordField.text;
    }
    
    [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    if ([self.passwordField.text isEqualToString:@""])
    {
        if (self.passwordField == self.usrField)
            configH.user = nil;
        
        if(self.passwordField == self.passwordField)
            configH.password = nil;
        
    } else {
        
        if (self.passwordField == self.usrField)
            configH.user = self.usrField.text;
        
        if(self.passwordField == self.passwordField)
            configH.password = self.passwordField.text;
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
    
    ConfigHelper *configH = [ConfigHelper sharedInstance];
    if(self.guardarSwitch.isOn)
    {
        if(([self.usrField.text length] !=0) && ([self.passwordField.text length] !=0)){
        
        [self.usrField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if ([self.usrField.text isEqualToString:@""])
        {
            if (self.usrField == self.usrField)
                configH.user = nil;
            
            if(self.usrField == self.passwordField)
                configH.password = nil;
            
        } else {
            
            if (self.usrField == self.usrField)
                configH.user = self.usrField.text;
            
            if(self.usrField == self.passwordField)
                configH.password = self.passwordField.text;
        }
        
        [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        
        if ([self.passwordField.text isEqualToString:@""])
        {
            if (self.passwordField == self.usrField)
                configH.user = nil;
            
            if(self.passwordField == self.passwordField)
                configH.password = nil;
            
        } else {
            
            if (self.passwordField == self.usrField)
                configH.user = self.usrField.text;
            
            if(self.passwordField == self.passwordField)
                configH.password = self.passwordField.text;
        }
        
        [configH guardarCredenciales: self.usrField.text pass: self.passwordField.text];
    
        
    }
        else //hay una en blanco
        {
            UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle: NSLocalizedString(@"BLANK_ERROR", nil)
                                                                 message: NSLocalizedString(@"BLANK_MSG", nil)
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"OK",nil];
            
            [alertView show];
            [self.guardarSwitch setOn:NO];

        
        }
        
    } else //si el switch esta OFF
    {
        
        [configH resetearCredenciales];
        self.usrField.text = @"";
        self.passwordField.text = @"";
    }
}

- (IBAction)presentesChanged:(id)sender {
    
    ConfigHelper *configH = [ConfigHelper sharedInstance];
    
    if (self.presentesSwitch.isOn)
        [configH setPresentesDefecto: YES];
    else
        [configH setPresentesDefecto: NO];
     
}
- (IBAction)masdeXretrasos:(id)sender {
    
    ConfigHelper *configH = [ConfigHelper sharedInstance];
    
    //guardamos en NSUserDefaults
    [configH setRetrasos:self.stepperRetrasos.value];
    //escribimos en el label
    self.stepperRetrasosLbl.text = [NSString stringWithFormat:@"%.f",self.stepperRetrasos.value];
 
}
- (IBAction)masdeXausencias:(id)sender {
    
    ConfigHelper *configH = [ConfigHelper sharedInstance];
    
    //guardamos en NSUserDefaults
    [configH setAusencias:self.stepperAusencias.value];
     //escribimos en el label
    self.stepperAusenciaslbl.text = [NSString stringWithFormat:@"%.f",self.stepperAusencias.value];

}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	// When the user presses return, take focus away from the text field so that the keyboard is dismissed.
	if (theTextField == self.usrField) {
		[self.usrField resignFirstResponder];
    }
    
    if (theTextField == self.passwordField) {
        [self.passwordField resignFirstResponder];
    }
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //ConfigHelper *configH = [ConfigHelper sharedInstance];
    
    //Quitamos espacios en blanco por delante y por detrás
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    
    if(self.guardarSwitch.isOn){
        self.guardarSwitch.on=NO;
        [self guardarChanged:self.guardarSwitch];
    }
    
}




@end
