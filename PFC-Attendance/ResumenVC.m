//
//  ResumenVC.m
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 28/08/12.
//
//

#import "ResumenVC.h"
#import "MBProgressHUD.h"

@interface ResumenVC ()

@end

@implementation ResumenVC
@synthesize resumenText = _resumenText;
@synthesize refreshButton = _refreshButton;
@synthesize todosPresentesAusentes = _todosPresentesAusentes;
@synthesize sendButton = _sendButton;
@synthesize alumnos = _alumnos;
@synthesize columna = _columna;
@synthesize clase = _clase;
@synthesize existe = _existe;
@synthesize fecha = _fecha;
@synthesize ausentes = _ausentes;
@synthesize presentes = _presentes;
@synthesize nombreClase =_nombreClase;

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
    [self setTodosPresentesAusentes:nil];
    [self setSendButton:nil];
    [self setRefreshButton:nil];
    [self setAlumnos:nil];
    [self setClase:nil];
    [self setResumenText:nil];
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate = self;
    [self.sendButton setEnabled:NO];
    
    
    //mirar si existía ya un resumen en la spreadsheet. Porque puede que estemos consultando un día anterior.
    
    UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DONE_BUTTON", nil) style:UIBarButtonItemStyleDone target:self.resumenText action:@selector(resignFirstResponder)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIBarButtonItem *f = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *items = [[NSArray alloc] initWithObjects:f, b, nil];

    
    toolbar.items = items;
    
    self.resumenText.inputAccessoryView = toolbar;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"LOADING", nil);
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [midh existeResumen:self.clase paraColumna:self.columna];
    
    
    
    
    [super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)changeSegmentedControl:(id)sender {
}

- (IBAction)sendResumen:(id)sender {
    
    
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    [midh listadoAlumnos:self.clase];

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

- (IBAction)updateResumen:(id)sender {
    
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"UPLOADING", nil);
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    if(!self.existe)
    
        [midh insertResumen:self.clase paraColumna:self.columna conResumen:self.resumenText.text];
    else
        [midh updateResumen:self.clase paraColumna:self.columna conResumen:self.resumenText.text];
    
}


- (void)respuestaInsertResumen: (NSError *) error
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
    }
}

- (void) respuestaExisteResumen:(BOOL)existe resumen:(NSString *)resumen error:(NSError *)error
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
                NSLog(@"Error desconocido");
                //Error desconocido. Poner el localized description del NSError
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
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
    if(existe) //ya había un resumen en la spreadsheet
    {
        //habrá que mostrarlo
        self.resumenText.text = resumen;
    }
    else //no existe resumen. Hay que mostrar ya el teclado para escribir.
    {
        [self.resumenText becomeFirstResponder];
    }
            
    }

}

-(void) respuesta:(NSDictionary *)feed error:(NSError *)error
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
                
                break;
            }
        }
    }    else
    {
    
    NSMutableArray *mails = [NSMutableArray arrayWithCapacity: [self.alumnos count]];
    if (self.todosPresentesAusentes.selectedSegmentIndex == 0) {
        mails = [NSArray arrayWithArray:feed.allValues];
    }
    else if (self.todosPresentesAusentes.selectedSegmentIndex == 1)
        {
            //tengo que cotejar los alumnos con los presentes
            
            
            for (int j=0; j<[self.alumnos count]; j++) {
                for (int i=0; i<[self.presentes count]; i++) {
                    
                    if([[feed.allKeys objectAtIndex:j] isEqualToString:[self.presentes.allKeys objectAtIndex:i]])
                    {
                        //nos vamos creando el array de mails
                        [mails addObject:[feed.allValues objectAtIndex:i]];
                        break;
                    }
                }
            }
            
            
        }
    else ////tengo que cotejar los alumnos con los ausentes
    {
        
        for (int j=0; j<[self.alumnos count]; j++) {
            for (int i=0; i<[self.ausentes count]; i++) {
                
                if([[feed.allKeys objectAtIndex:j] isEqualToString:[self.ausentes.allKeys objectAtIndex:i]])
                {
                    //nos vamos creando el array de mails
                    [mails addObject:[feed.allValues objectAtIndex:i]];
                    break;
                }
            }
        }
    }
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setTimeStyle:NSDateFormatterNoStyle];
    [df setDateStyle:NSDateFormatterFullStyle];
    //NSLocale *theLocale = [NSLocale currentLocale];
    //[df setLocale:theLocale];
        
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [df setTimeZone:timeZone];
    NSString *dateStr = [df stringFromDate:self.fecha];
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    [composer setMailComposeDelegate:self];
    if ([MFMailComposeViewController canSendMail]) {
        [composer setBccRecipients:mails];
        [composer setSubject:[NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"TODAYS_CLASS" value:@"" table:nil],dateStr]];
        [composer setMessageBody:self.resumenText.text isHTML:NO];
        [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentModalViewController:composer animated:YES];
    }
    }
}

#pragma mark - TextView Field delegate
-(void) textViewDidBeginEditing:(UITextView *)textView
{
    
    [self.sendButton setEnabled:YES];
    
}





@end
