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
    
    //toolbar.items = [NSArray arrayWithArray:objects];
    
    self.resumenText.inputAccessoryView = toolbar;
    [midh existeResumen:self.clase paraColumna:self.columna];
    
    
    
    
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)changeSegmentedControl:(id)sender {
}

- (IBAction)sendResumen:(id)sender {
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

#pragma mark - TextView Field delegate
-(void) textViewDidBeginEditing:(UITextView *)textView
{
    
    [self.sendButton setEnabled:YES];
    
}





@end
