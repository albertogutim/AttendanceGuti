//
//  ResumenVC.m
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 28/08/12.
//
//

#import "ResumenVC.h"

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
    [self setTodosPresentesAusentes:nil];
    [self setSendButton:nil];
    [self setRefreshButton:nil];
    [self setAlumnos:nil];
    [self setClase:nil];
    [self setResumenText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    midh.delegate = self;
    [self.sendButton setEnabled:NO];
    
    
    //mirar si existía ya un resumen en la spreadsheet. Porque puede que estemos consultando un día anterior.

    //UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self.resumenText action:@selector(resignFirstResponder)];
    
    UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DONE_BUTTON", nil) style:UIBarButtonItemStyleDone target:self.resumenText action:@selector(resignFirstResponder)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIBarButtonItem *f = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *items = [[NSArray alloc] initWithObjects:f, b, nil];

    
    toolbar.items = items;
    
    self.resumenText.inputAccessoryView = toolbar;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [midh existeResumen:self.clase paraColumna:self.columna];
    
    
    
    
    [super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)changeSegmentedControl:(id)sender {
}

- (IBAction)sendResumen:(id)sender {
    
    
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    [midh listadoAlumnos:self.clase];

}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (!error) {
        [self dismissModalViewControllerAnimated:YES];
    }

}

- (IBAction)updateResumen:(id)sender {
    
    GDocsHelper *midh = [GDocsHelper sharedInstance];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    if(!self.existe)
    
        [midh insertResumen:self.clase paraColumna:self.columna conResumen:self.resumenText.text];
    else
        [midh updateResumen:self.clase paraColumna:self.columna conResumen:self.resumenText.text];
    
}


- (void)respuestaInsertResumen: (NSError *) error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
}

- (void) respuestaExisteResumen:(BOOL)existe resumen:(NSString *)resumen error:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    if(existe) //ya había un resumen en la spreadsheet
    {
        //habrá que mostrarlo
        self.resumenText.text = resumen;
    }

}

-(void) respuesta:(NSDictionary *)feed error:(NSError *)error
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
    NSLocale *theLocale = [NSLocale currentLocale];
    [df setLocale:theLocale];
    NSString *dateStr = [df stringFromDate:self.fecha];
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    [composer setMailComposeDelegate:self];
    if ([MFMailComposeViewController canSendMail]) {
        [composer setToRecipients:mails];
        [composer setSubject:[NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:@"TODAYS_CLASS" value:@"" table:nil],dateStr]];
        [composer setMessageBody:self.resumenText.text isHTML:NO];
        [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentModalViewController:composer animated:YES];
    }

}

#pragma mark - TextView Field delegate
-(void) textViewDidBeginEditing:(UITextView *)textView
{
    
    [self.sendButton setEnabled:YES];
    
}





@end
