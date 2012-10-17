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
@synthesize datosAlumno = _datosAlumno;
@synthesize cambios = _cambios;
@synthesize nombreClase = _nombreClase;
@synthesize nombreAsignatura = _nombreAsignatura;
@synthesize fechasRetrasos = _fechasRetrasos;
@synthesize fechasAusencias = _fechasAusencias;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setDatosAlumnoTable:nil];
    [super viewDidUnload];
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate=nil;
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate = self;
    self.cambios = NO;
    
    
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 105, 44.01)];
    
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
    
     
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"LOADING", nil);
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [midh listadoFechasConAsistencia:self.clase paraAlumno:self.alumno conRow: self.row];
    

     
     
     
    [super viewWillAppear:animated];
}

-(void)mailButtonAction
{

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
    if (!error) {
        [self dismissModalViewControllerAnimated:YES];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
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
        UITableViewCell *cell;
        cell = [tableView
                dequeueReusableCellWithIdentifier:@"datos"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"datos"];
        }
        
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
        theCellLbl.text = [self.datosAlumno objectAtIndex:indexPath.row];
        return cell;

    }
    else if(indexPath.section==1)
        
    {
        UITableViewCell *cell;
        cell = [tableView
                dequeueReusableCellWithIdentifier:@"datos"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"datos"];
        }
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
        //theCellLbl.text = [self.pintarAusencias.allKeys objectAtIndex:indexPath.row];
        
        theCellLbl.text =[self.fechasAusencias objectAtIndex:indexPath.row];
        theCellLbl.textAlignment = UITextAlignmentCenter;
        return cell;
        
    }
    else if(indexPath.section==2)
    {

        UITableViewCell *cell;
        cell = [tableView
                dequeueReusableCellWithIdentifier:@"datos"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"datos"];
        }
        UILabel *theCellLbl = (UILabel *)[cell viewWithTag:1];
        //theCellLbl.text = [self.pintarRetrasos.allKeys objectAtIndex:indexPath.row];
        
        theCellLbl.text =[self.fechasRetrasos objectAtIndex:indexPath.row];
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
                
        /*UIButton *sampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sampleButton setFrame:[cell.contentView frame]];
        [sampleButton setFrame:CGRectMake(10, 1, cell.bounds.size.width-20, 44)];
        [sampleButton setBackgroundImage:[UIImage imageNamed:@"redBackground.png"] forState:UIControlStateNormal];
        [cell addSubview:sampleButton];
         */
        
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
    
    
    
    self.mail = [feed objectForKey:@"Email"];
    //esto seria si utilizaramos la celda con la formula
    //self.ausencias = [feed objectForKey:@"Estadistica"];
    
    self.datosAlumno = [NSArray arrayWithObjects:self.alumno,self.mail, nil];
    
    [feed removeObjectForKey:@"Email"];
    //[feed removeObjectForKey:@"Estadistica"];
    
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
    
    
    NSMutableArray *fechasAusencias = [NSMutableArray arrayWithCapacity: [feed count]];
    NSMutableArray *fechasRetrasos = [NSMutableArray arrayWithCapacity: [feed count]];
    for(int i=0;i<[arrayFechas count];i++)
    {
        if([self.pintarAusencias valueForKey:[arrayFechas objectAtIndex:i]]!=nil)
        {
            [fechasAusencias addObject:[arrayFechas objectAtIndex:i]];
        }
    }
    
   
    self.fechasAusencias = fechasAusencias;
    
    NSMutableDictionary *retrasos = [NSMutableDictionary dictionaryWithDictionary:self.pintar];
    retrasos = [self filtrarRetrasos:retrasos];
    self.pintarRetrasos = retrasos;
    
    
    for(int i=0;i<[arrayFechas count];i++)
    {
        if([self.pintarRetrasos valueForKey:[arrayFechas objectAtIndex:i]]!=nil)
        {
            [fechasRetrasos addObject:[arrayFechas objectAtIndex:i]];
        }
    }
    
    self.fechasRetrasos = fechasRetrasos;
    
    [self.datosAlumnoTable reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
}

-(void) respuestaUpdate:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    [self.delegate devolverTabla:self huboCambios:self.cambios];

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
