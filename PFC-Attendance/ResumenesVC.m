//
//  ResumenesVC.m
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 13/09/12.
//
//

#import "ResumenesVC.h"

@interface ResumenesVC ()

@end

@implementation ResumenesVC
@synthesize resumenes = _resumenes;
@synthesize fechas = _fechas;
@synthesize nombreAsignatura = _nombreAsignatura;
@synthesize nombreClase = _nombreClase;
@synthesize resumenSeleccionado = _resumenSeleccionado;
@synthesize fecharesumen = _fecharesumen;

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
        return [self.resumenes count] -2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
        UITableViewCell *cell;
        cell = [tableView
                dequeueReusableCellWithIdentifier:@"detalleResumen"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detalleResumen"];
        }
        
       
        UILabel *fecha = (UILabel *)[cell viewWithTag:1];
        UILabel *resumen = (UILabel *)[cell viewWithTag:2];
        
        
        fecha.text = [self.fechas objectAtIndex:indexPath.row];
        resumen.text = [self.resumenes objectAtIndex:indexPath.row+2];

        return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 44;
        
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    self.resumenSeleccionado= [self.resumenes objectAtIndex:indexPath.row+2];
    self.fecharesumen = [self.fechas objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"goToResumenSeleccionado" sender:self];
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (!error) {
        [self dismissModalViewControllerAnimated:YES];
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"goToResumenSeleccionado"])
    {
        
        //cuando el usuario selecciona una clase se le pasa el id de la misma al viewcontroller siguiente
        
        
        ResumenSeleccionadoVC *resumenSeleccionado = [segue destinationViewController];
        resumenSeleccionado.fechaResumen = self.fecharesumen;
        resumenSeleccionado.resumenSeleccionado = self.resumenSeleccionado;
        resumenSeleccionado.nombreClase = self.nombreClase;
        resumenSeleccionado.nombreAsignatura = self.nombreAsignatura;

    }
}
- (IBAction)enviarResumenes:(id)sender {
    
    
    //Crear el texto del mensaje añadiendo la fecha y su  resumen correspondiente. Si para una fecha en concreto no existe resumen almacenado, no se muestra.
    NSMutableString *resumenesConFechas = [NSMutableString stringWithCapacity:[self.fechas count]];
    NSString *resumenDiario = [[NSString alloc] init];
    
    for (int i=0; i<[self.fechas count]; i++) {
        
        if(![[self.resumenes objectAtIndex:i+2]isEqualToString:@""])
        {
        resumenDiario =[NSString stringWithFormat:@"%@\n%@\n\n", [self.fechas objectAtIndex:i],[self.resumenes objectAtIndex:i+2]];
        [resumenesConFechas appendString:resumenDiario];
        }
    }
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    [composer setMailComposeDelegate:self];
    if ([MFMailComposeViewController canSendMail]) {
        [composer setSubject:[NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"RESUME_LIST" value:@"" table:nil],[NSString stringWithFormat:@"%@_%@",self.nombreAsignatura,self.nombreClase]]];
        [composer setMessageBody:resumenesConFechas isHTML:NO];
        [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentModalViewController:composer animated:YES];

}
}
@end
