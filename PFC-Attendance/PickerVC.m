//
//  PickerVC.m
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 09/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PickerVC.h"
#import "GDocsHelper.h"
#import "ConfigHelper.h"
#import "MBProgressHUD.h"

@implementation PickerVC
@synthesize fechas = _fechas;
@synthesize miPicker = _miPicker;
@synthesize clase = _clase;
@synthesize fecha = _fecha;
@synthesize today = _today;
@synthesize contador = _contador;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}


- (void)viewDidUnload
{
    [self setMiPicker:nil];
    [super viewDidUnload];
    self.fechas = nil;
    GDocsHelper *dh = [GDocsHelper sharedInstance];
    dh.delegate = nil;
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"LOADING", nil);
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    GDocsHelper *dh = [GDocsHelper sharedInstance];
    [dh fechasValidasPara:self.clase];
    dh.delegate = self;
    
    [super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Picker DataSource methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [self.fechas count];
}

#pragma mark Picker Delegate methods
/*-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [self.fechas objectAtIndex:row];
    
}
*/


- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    UILabel *pickerLabel = (UILabel *)view;
    
    int contador = self.contador;
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 280, 32);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:UITextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [pickerLabel setTextColor:[UIColor blackColor]];
        
    }
    
    if(contador>0) //tengo que pintar alguna linea de rojo
    {
        
        if(row==0)
        {
            
            [pickerLabel setText:[self.fechas objectAtIndex:row]];
            [pickerLabel setTextColor:[UIColor blackColor]];
        }
        if((row<=contador)&& (row!=0))
        {
            [pickerLabel setTextColor:[UIColor redColor]];
            [pickerLabel setText:[self.fechas objectAtIndex:row]];
        }
        else
        {
            
            [pickerLabel setText:[self.fechas objectAtIndex:row]];
            [pickerLabel setTextColor:[UIColor blackColor]];
        }
        
        
    }
    
    else
    {
        [pickerLabel setText:[self.fechas objectAtIndex:row]];
        [pickerLabel setTextColor:[UIColor blackColor]];
    }
    
    return pickerLabel;
;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *fechCad = [self.fechas objectAtIndex:row];
    
    if([fechCad isEqualToString:NSLocalizedString(@"TODAY", nil)])
        self.fecha = self.today;
    else
    {
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterFullStyle];
        //[df setDateFormat:@"dd/MM/yy"];
        NSDate *nuevaFecha = [df dateFromString:fechCad];
        
        
        self.fecha = nuevaFecha;
    }
    
    /*UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:@"Picker"
     message:[NSString stringWithFormat:@"fecha: %@", nuevaFecha]
     delegate:self
     cancelButtonTitle:@"Dismiss"
     otherButtonTitles:nil];
     
     [alertView show];
     */
    
    
    
}


#pragma mark My methods
- (void)respuestaFechasValidas:(NSArray *) fechas error: (NSError *) error {
    //TODO: Controlar error
    NSMutableArray *fechaLong = [NSMutableArray arrayWithCapacity:[fechas count]];
    BOOL encontradoHoy=NO;
    
    NSDateFormatter *dff = [NSDateFormatter new];
    [dff setTimeStyle:NSDateFormatterNoStyle];
    [dff setDateStyle:NSDateFormatterShortStyle];
    NSLocale *theLocalee = [NSLocale currentLocale];
    [dff setLocale:theLocalee];
    
    
    NSDate *today =[NSDate date];
    NSString *todayStr = [dff stringFromDate:today];
    [dff setTimeStyle:NSDateFormatterNoStyle];
    [dff setDateStyle:NSDateFormatterShortStyle];
    //[dff setDateFormat:@"dd/MM/yy"];
    NSDate *todayOk = [dff dateFromString:todayStr];
    self.today = todayOk;
    
    for (NSString *fechCad in fechas) {
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterShortStyle];
        
        NSLocale *theLocale = [NSLocale currentLocale];
        [df setLocale:theLocale];
        //TODO: Ojo! Si pones el iPhone en inglés devuelve nil porque 13/08/02 se refiere al mes 13 y no existe obviamente.
        [df setDateFormat:@"dd/MM/yy"];
        NSDate *nuevaFecha = [df dateFromString:fechCad];
        
        //si encuentra la fecha de hoy
        GDocsHelper *dh = [GDocsHelper sharedInstance];
        if([dh compareDay: todayOk withDay:nuevaFecha] == 0)
        //if([todayOk isEqualToDate:nuevaFecha])
            encontradoHoy=YES;
        
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterFullStyle];
        
        [df setLocale:theLocale];
        //TODO: Como nuevaFecha vale nil peta al añadir a fechaLong un nil
        NSString *dateStr = [df stringFromDate:nuevaFecha];
        [fechaLong addObject:dateStr];
        
    }
    
    //Hay que añadir al picker las fechas comprendidas entre la última fecha de la spreadsheet y el día de hoy por si el usuario no pudo pasar asistencia esos dias darle la oportunidad de hacerlo ahora.
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setTimeStyle:NSDateFormatterNoStyle];
    [df setDateStyle:NSDateFormatterShortStyle];
    NSLocale *theLocale = [NSLocale currentLocale];
    [df setLocale:theLocale];
    [df setDateFormat:@"dd/MM/yy"];
    NSDate *ultimaFecha = [df dateFromString:[fechas lastObject]];
    int contador;
    GDocsHelper *dh = [GDocsHelper sharedInstance];
    if([dh compareDay: ultimaFecha withDay:self.today] != 0)
    //if(![ultimaFecha isEqualToDate:self.today])
    {
        contador=0;
        int daysToAdd = 1;
        while ([ultimaFecha earlierDate:self.today]) {
            NSDate *newDate1 = [ultimaFecha dateByAddingTimeInterval:60*60*24*daysToAdd];
            
            
            
            if([dh compareDay: newDate1 withDay:self.today] != 0)
            //if(![newDate1 isEqualToDate:self.today])
            {
                [df setTimeStyle:NSDateFormatterNoStyle];
                [df setDateStyle:NSDateFormatterFullStyle];
                NSLocale *theLocale = [NSLocale currentLocale];
                [df setLocale:theLocale];
                NSString *dateStr = [df stringFromDate:newDate1];
                [fechaLong addObject:dateStr];
                
                ultimaFecha = newDate1;
                contador++;
            }
            else
            {
                self.contador = contador;
                break;
            }
            
        }
    }

    
    //si no encontro la fecha de hoy en el spreadsheet hay que añadirla al picker para que pueda seleccionarla y pasar lista.
    if(!encontradoHoy)
        [fechaLong addObject:NSLocalizedString(@"TODAY", nil)];
    self.fechas = fechaLong;
    
    
    
    //Aqui habrá que darle la vuelta a las fechas para que la primera que salga sea HOY!
    
    NSMutableArray *fechaDelReves = [NSMutableArray arrayWithCapacity:[fechas count]];
    for (int i=[self.fechas count]-1; i>=0; i--) {
        [fechaDelReves addObject:[self.fechas objectAtIndex:i]];
    }
    self.fechas = fechaDelReves;
    
    if ([fechas count] !=0)
    {
        if([[self.fechas objectAtIndex:0] isEqualToString:NSLocalizedString(@"TODAY", nil)])
        {
            self.fecha = todayOk;
        }
        else
        {
            
            NSDateFormatter *df = [NSDateFormatter new];
            [df setTimeStyle:NSDateFormatterNoStyle];
            [df setDateStyle:NSDateFormatterFullStyle];
            NSDate *fechaDefecto = [df dateFromString:[self.fechas objectAtIndex:0]];
            
            self.fecha = fechaDefecto;//Le damos el valor de la primera fecha que sale por defecto que es siempre la primera de self.fechas.
        }
    }
    else
        self.fecha = todayOk;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [self.miPicker reloadAllComponents];
}


//el usuario ha elegido fecha y quiere volver a la pantalla anterior
- (IBAction)aceptarFecha:(id)sender {
    
    [self.delegate devolverFecha:self didSelectDate:self.fecha hoyEs: self.today];
    
    
}

//el usuario no quiere elegir fecha y quiere volver a la pantalla anterior
- (IBAction)cancelarFecha:(id)sender {
    
    [self.delegate devolverFecha:self didSelectDate:nil hoyEs: self.today];
}
@end
