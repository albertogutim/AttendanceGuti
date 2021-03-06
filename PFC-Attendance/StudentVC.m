//
//  StudentVC.m
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 04/09/12.
//
//

#import "StudentVC.h"
#import "MBProgressHUD.h"

@interface StudentVC ()

@end

@implementation StudentVC

@synthesize alumno =_alumno;
@synthesize deTxtField = _deTxtField;
@synthesize clase = _clase;
@synthesize mail = _mail;
@synthesize datosAlumnoTable = _datosAlumnoTable;
@synthesize ausencias = _ausencias;
@synthesize pintar = _pintar;
@synthesize row = _row;
@synthesize cuantasAusencias =_cuantasAusencias;
@synthesize cuantosRetrasos = _cuantosRetrasos;
@synthesize pintarAusencias = _pintarAusencias;
@synthesize pintarRetrasos =_pintarRetrasos;
@synthesize cambios = _cambios;
@synthesize nombreClase = _nombreClase;
@synthesize nombreAsignatura = _nombreAsignatura;
@synthesize sortedAusencias = _sortedAusencias;
@synthesize sortedRetrasos = _sortedRetrasos;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)viewDidUnload
{
    [self setDatosAlumnoTable:nil];
    [super viewDidUnload];
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate=nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate = self;
    self.cambios = NO;
    self.deTxtField = NO;
    
    
    /*UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 105, 44.01)];
    
    // create the array to hold the buttons, which then gets added to the toolbar
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonAction)];
    editButton.style = UIBarButtonItemStyleBordered;
    [buttons addObject:editButton];
    
    
    
    UIBarButtonItem* mailButton =[[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(mailButtonAction)];
    mailButton.style = UIBarButtonItemStyleBordered;
    
    [buttons addObject:mailButton];
    

    // stick the buttons in the toolbar
    [tools setItems:buttons animated:NO];
    
    
    
    // and put the toolbar in the nav bar
    
    UIBarButtonItem* rightButtonBar = [[UIBarButtonItem alloc] initWithCustomView:tools];
    self.navigationItem.rightBarButtonItem = rightButtonBar;
    */
     
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"LOADING", nil);
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [midh listadoFechasConAsistencia:self.clase paraAlumno:self.alumno conRow: self.row];
    

     
     
     
    [super viewWillAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated
{

    if(!self.cambios)
    {
        if(self.deTxtField)
            [self.delegate devolverTabla:self huboCambios:2];
    }
        
    [super viewWillDisappear:animated];

}
- (IBAction)mailButtonAction:(id)sender {
    
    NSMutableString *ausenciasYretrasos = [NSMutableString stringWithCapacity:[self.pintarAusencias count]+[self.pintarRetrasos count]+2];
    
    
    if([self.pintarAusencias count]>0) //hay ausencias
    {
        [ausenciasYretrasos appendString:@"Ausencias:\n\n"];
        for (int i=0; i<[self.pintarAusencias count]; i++) {
            [ausenciasYretrasos appendString:[NSString stringWithFormat:@"%@\n",[self.pintarAusencias.allKeys objectAtIndex:i]]];
            
            
        }
        
        
    }
    
    if([self.pintarRetrasos count]>0) //hay retrasos
    {
        [ausenciasYretrasos appendString:@"\n\nRetrasos:\n\n"];
        for (int i=0; i<[self.pintarRetrasos count]; i++) {
            [ausenciasYretrasos appendString:[NSString stringWithFormat:@"%@\n",[self.pintarRetrasos.allKeys objectAtIndex:i]]];
            
            
        }
        
    }
    
    NSMutableArray *mail = [[NSMutableArray alloc] init];
    
    [mail addObject: self.mail];
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    [composer setMailComposeDelegate:self];
    if ([MFMailComposeViewController canSendMail]) {
        [composer setBccRecipients:mail];
        [composer setSubject:[NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"STADISTICS_SUBJECT" value:@"" table:nil],[NSString stringWithFormat:@"%@_%@",self.nombreAsignatura,self.nombreClase]]];
        [composer setMessageBody:ausenciasYretrasos isHTML:NO];
        [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentModalViewController:composer animated:YES];
        
    }

}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (!error)
        [self dismissModalViewControllerAnimated:YES];
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[NSString stringWithFormat:@"error %@", [error description]]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,nil];
        [alert show];
        [self dismissModalViewControllerAnimated:YES];
        
    }
    
    
    
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if(section==0)
    {
        return 2;
    }
    else if(section==1)
        
    {
        
        return self.cuantasAusencias;
    }
    else if(section==2)
    {
        
        
        return self.cuantosRetrasos;
    }
    else if(section==3)
    {
        
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.section==0)
    {
        
        if (indexPath.row==0)
        {
            
        
            UITableViewCell *cell;
            cell = [tableView
                    dequeueReusableCellWithIdentifier:@"nombre"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nombre"];
            }
            
            UITextField *text = (UITextField *)[cell viewWithTag:4];
            [text setHidden:YES];
            UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
            theCellLbl.text = self.alumno;
            [theCellLbl setHidden:NO];
            
            
            return cell;
        }
        else if(indexPath.row==1)
        {
            UITableViewCell *cell;
            cell = [tableView
                    dequeueReusableCellWithIdentifier:@"mail"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mail"];
            }
            
            UITextField *text = (UITextField *)[cell viewWithTag:6];
            [text setHidden:YES];
            UILabel *theCellLbl = (UILabel *)[cell viewWithTag:7];
            theCellLbl.text = self.mail;
            [theCellLbl setHidden:NO];
            
            
            return cell;
        
        }

    }
    else if(indexPath.section==1)
        
    {
        UITableViewCell *cell;
        cell = [tableView
                dequeueReusableCellWithIdentifier:@"AussenciasRetrasos"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AussenciasRetrasos"];
        }
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:5];
        
        
        theCellLbl.text =[self.sortedAusencias objectAtIndex:indexPath.row];
        theCellLbl.textAlignment = UITextAlignmentCenter;
        return cell;
        
    }
    else if(indexPath.section==2)
    {

        UITableViewCell *cell;
        cell = [tableView
                dequeueReusableCellWithIdentifier:@"AussenciasRetrasos"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AussenciasRetrasos"];
        }
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:5];
        
        
        theCellLbl.text =[self.sortedRetrasos objectAtIndex:indexPath.row];
        theCellLbl.textAlignment = UITextAlignmentCenter;
        return cell;
        
    }
    else if(indexPath.section==3)
    {
        
        UITableViewCell *cell;
        cell = [tableView
                dequeueReusableCellWithIdentifier:@"eliminarAlumno"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eliminarAlumno"];
        }
        
        
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:3];
        theCellLbl.text = [NSString stringWithFormat:@"Eliminar Alumno"];
        theCellLbl.textAlignment = UITextAlignmentCenter;

        return cell;
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *theCellLbl = (UILabel *)[cell viewWithTag:3];
    if([theCellLbl.text isEqualToString:@"Eliminar Alumno"])
    {
        self.cambios = YES;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"SURE?", nil) delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
    
    
    UILabel *theCellLbl2 = (UILabel *)[cell viewWithTag:1];
    if([cell.reuseIdentifier isEqualToString:@"nombre"])
    {
        
        //Aquí queremos hacer aparecer el TextField para que el usuario pueda modificar el nombre y el mail del alumno.
        
        UITextField *text = (UITextField *)[cell viewWithTag:4];
        [text setHidden:NO];
        [text becomeFirstResponder];
        [theCellLbl2 setHidden:YES];
        
    }
    
    UILabel *theCellLbl3 = (UILabel *)[cell viewWithTag:7];
    if([cell.reuseIdentifier isEqualToString:@"mail"])
    {
        
        //Aquí queremos hacer aparecer el TextField para que el usuario pueda modificar el nombre y el mail del alumno.
        
        UITextField *text = (UITextField *)[cell viewWithTag:6];
        [text setHidden:NO];
        [text becomeFirstResponder];
        [theCellLbl3 setHidden:YES];
        
    }

    
    
}



#pragma mark - Text Field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    if(theTextField.tag == 4)
    {
           
        if([theTextField.text length]>0)
        {
            self.deTxtField =YES;
            self.alumno = theTextField.text;
        }
        
 
    }
    else if(theTextField.tag == 6)
    {

        if([theTextField.text length]>0)
        {
            self.deTxtField =YES;
            self.mail = theTextField.text;
        }

    }
     
    if(self.deTxtField)
    {
        //update spreadsheet
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = NSLocalizedString(@"UPDATING", nil);
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        GDocsHelper *midh = [GDocsHelper sharedInstance];
        [midh updateNombreAlumno:self.clase paraRow:self.row paraNombre:self.alumno paraMail:self.mail];
    }
    
    [theTextField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    //Quitamos espacios en blanco por delante y por detrás
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([textField.text length]>0)
    {
        
        self.deTxtField = YES;
        if(textField.tag == 4)
            self.alumno = textField.text;
        else if(textField.tag == 6)
            self.mail = textField.text;
        
    }
    else
    {
        if(textField.tag == 4)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            NSMutableArray *path = [NSMutableArray arrayWithCapacity:1];
            [path addObject:indexPath];
            [self.datosAlumnoTable reloadRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationNone];
        
        }
            
        else if(textField.tag == 6)
        {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            NSMutableArray *path = [NSMutableArray arrayWithCapacity:1];
            [path addObject:indexPath];
            [self.datosAlumnoTable reloadRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationNone];
        }
            
    
    }
        

}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if(buttonIndex ==1)
    {
        //ok
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = NSLocalizedString(@"DELETING", nil);
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        GDocsHelper *midh = [GDocsHelper sharedInstance];
        [midh eliminarAlumno: self.clase paraRow:self.row];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if(section == 0)
    {
        return [NSString stringWithFormat:@"%@_%@",self.nombreAsignatura,self.nombreClase];
    }
    else if(section == 1)
    {
        return [NSString stringWithFormat:@"Ausencias (%d)",self.cuantasAusencias];
    }
    else if(section == 2)
    {
        return [NSString stringWithFormat:@"Retrasos (%d)",self.cuantosRetrasos];
    }
    if(section == 3)
    {
        return @"";
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.section == 3)
        return 36;
    else if ((indexPath.section == 0)|| (indexPath.section == 1) || (indexPath.section == 2))
        return 44;
}

#pragma mark - My Methods


-(void)respuestaAusencias:(NSMutableDictionary *)feed arrayFechas: (NSMutableArray *) arrayFechas error:(NSError *)error
{
    //responde a listadoFechasConAsistencia
    
    if (error) {
        
        switch (error.code) {
            case 403:
            {
                NSLog(@"Error de login");
                break;
            }
                
            case -1009:
            {
                NSLog(@"Error de conexión");
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:NSLocalizedString(@"CONN_ERR", NIL)
                                                                     message:nil
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                
                [alertView show];
                break;
            }
            default:
            {
                //Error desconocido. Poner el localized description del NSError
                UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"error %@", [error description]]
                                                                     message:nil
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                
                [alertView show];
                break;
            }
        }
    }    else
    {
    
    
    self.mail = [feed objectForKey:@"Email"];
    //esto seria si utilizaramos la celda con la formula
    //self.ausencias = [feed objectForKey:@"Estadistica"];
    
    
    [feed removeObjectForKey:@"Email"];
    
    self.pintar = feed;
    
    
    NSInteger cuantasAusencias = 0;
    //esto seria si utilizaramos la celda con la formula
    //return [self.ausencias intValue] ;
    for (int i=3; i<[self.pintar count]; i++) {
        
        if([[self.pintar.allValues objectAtIndex:i] isEqualToString:@"2"])
        {
            cuantasAusencias++;
        }
    }
    self.cuantasAusencias = cuantasAusencias;
    
    NSInteger cuantosRetrasos = 0;
    //esto seria si utilizaramos la celda con la formula
    //return [self.ausencias intValue] ;
    for (int i=3; i<[self.pintar count]; i++) {
        
        if([[self.pintar.allValues objectAtIndex:i] isEqualToString:@"3"])
        {
            cuantosRetrasos++;
        }
    }
    self.cuantosRetrasos = cuantosRetrasos;
    
    NSMutableDictionary *ausencias = [NSMutableDictionary dictionaryWithDictionary:self.pintar];
    ausencias = [self filtrarAusentes:ausencias];
    self.pintarAusencias = ausencias;
    
    
    NSMutableArray *fechitas = [NSMutableArray arrayWithCapacity: [feed count]];
    for (NSString *fechCad in self.pintarAusencias.allKeys) {
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterShortStyle];
        
        //NSLocale *theLocale = [NSLocale currentLocale];
        //[df setLocale:theLocale];
        
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [df setTimeZone:timeZone];
       
        [df setDateFormat:@"dd/MM/yy"];
        NSDate *nuevaFecha = [df dateFromString:fechCad];
        
        [fechitas addObject:nuevaFecha];
        
    }
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(compare:)];
    NSMutableArray* sortedArray = [NSMutableArray arrayWithArray:[fechitas sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]];
    
    for (int i=0; i<[sortedArray count]; i++) {
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterShortStyle];
        
        //NSLocale *theLocale = [NSLocale currentLocale];
        //[df setLocale:theLocale];
        
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [df setTimeZone:timeZone];
       
        [df setDateFormat:@"dd/MM/yy"];
        
        NSString *dateStr = [df stringFromDate:[sortedArray objectAtIndex:i]];
        
        [sortedArray replaceObjectAtIndex:i withObject:dateStr];
    }
    
    self.sortedAusencias = sortedArray;
    

    NSMutableDictionary *retrasos = [NSMutableDictionary dictionaryWithDictionary:self.pintar];
    retrasos = [self filtrarRetrasos:retrasos];
    self.pintarRetrasos = retrasos;
    
    
    NSMutableArray *fechitas2 = [NSMutableArray arrayWithCapacity: [feed count]];
    for (NSString *fechCad in self.pintarAusencias.allKeys) {
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterShortStyle];
        
        //NSLocale *theLocale = [NSLocale currentLocale];
        //[df setLocale:theLocale];
        
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [df setTimeZone:timeZone];
    
        [df setDateFormat:@"dd/MM/yy"];
        NSDate *nuevaFecha = [df dateFromString:fechCad];
        
        [fechitas2 addObject:nuevaFecha];
        
    }
    
    NSMutableArray* sortedArray2 = [NSMutableArray arrayWithArray:[fechitas2 sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]];
    
    for (int i=0; i<[sortedArray2 count]; i++) {
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterShortStyle];
        
        //NSLocale *theLocale = [NSLocale currentLocale];
        //[df setLocale:theLocale];
        
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [df setTimeZone:timeZone];
    
        [df setDateFormat:@"dd/MM/yy"];
        
        NSString *dateStr = [df stringFromDate:[sortedArray2 objectAtIndex:i]];
        
        [sortedArray2 replaceObjectAtIndex:i withObject:dateStr];
    }

    
    self.sortedRetrasos = sortedArray2;
    
    [self.datosAlumnoTable reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}

-(void) respuestaUpdate:(NSError *)error
{
    
    if (error) {
        
        switch (error.code) {
            case 403:
            {
                NSLog(@"Error de login");
                break;
            }
                
            case -1009:
            {
                NSLog(@"Error de conexión");
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:NSLocalizedString(@"CONN_ERR", NIL)
                                                                     message:nil
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                
                [alertView show];
                break;
            }
            default:
            {
                //Error desconocido. Poner el localized description del NSError
                UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"error %@", [error description]]
                                                                     message:nil
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                
                [alertView show];
                break;
            }
        }
    }
    else
    {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    if(!self.deTxtField)
        [self.delegate devolverTabla:self huboCambios:1];
    else
    {
        [self.datosAlumnoTable reloadData];
        self.deTxtField=NO;
    }
    }

}

-(NSMutableDictionary *) filtrarAusentes: (NSMutableDictionary *) asistencias
{
    
    NSMutableDictionary *filtro = [NSMutableDictionary dictionaryWithDictionary:asistencias];
    for (int j=0; j<[asistencias count]; j++)
    {
        if(![[asistencias.allValues objectAtIndex:j] isEqualToString:@"2"])
            [filtro removeObjectForKey:[asistencias.allKeys objectAtIndex:j]];
        
    }
    return filtro;
    
}


-(NSMutableDictionary *) filtrarRetrasos: (NSMutableDictionary *) asistencias
{
    NSMutableDictionary *filtro = [NSMutableDictionary dictionaryWithDictionary:asistencias];
    for (int j=0; j<[asistencias count]; j++)
    {
        if(![[asistencias.allValues objectAtIndex:j] isEqualToString:@"3"])
        {
            [filtro removeObjectForKey:[asistencias.allKeys objectAtIndex:j]];
        }
    }
    return filtro;
    
}


@end
