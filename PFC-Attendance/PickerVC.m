//
//  PickerVC.m
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 09/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PickerVC.h"
#import "GDocsHelper.h"

@implementation PickerVC
@synthesize fechas = _fechas;
@synthesize miPicker = _miPicker;
@synthesize clase = _clase;


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
    GDocsHelper *dh = [GDocsHelper sharedInstance];
    [dh fechasValidasPara:self.clase];
    dh.delegate = self;
    
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
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [self.fechas objectAtIndex:row];

}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    
}

#pragma mark My methods
- (void)respuestaFechasValidas:(NSArray *) fechas error: (NSError *) error {
    //TODO: Controlar error
    NSMutableArray *fechaLong = [NSMutableArray arrayWithCapacity:[fechas count]];
   
    for (NSString *fechCad in fechas) {
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterShortStyle];
        NSDate *nuevaFecha = [df dateFromString:fechCad];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterFullStyle];
        NSLocale *theLocale = [NSLocale currentLocale];
        [df setLocale:theLocale];
        NSString *dateStr = [df stringFromDate:nuevaFecha];
        [fechaLong addObject:dateStr];
        
    }
    self.fechas = fechaLong;
    [self.miPicker reloadAllComponents];
}

@end