//
//  ResumenVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 28/08/12.
//
//

#import <UIKit/UIKit.h>
#import "GDocsHelper.h"
#import "MessageUI/MFMailComposeViewController.h"

@interface ResumenVC : UIViewController <GDocsHelperDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *todosPresentesAusentes;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sendButton;

- (IBAction)changeSegmentedControl:(id)sender;

- (IBAction)sendResumen:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) NSMutableDictionary *alumnos;
@property (strong, nonatomic) NSMutableDictionary *ausentes;
@property (strong, nonatomic) NSMutableDictionary *presentes;
@property (assign, nonatomic) NSInteger columna;
@property (strong, nonatomic) NSString *clase;
@property (strong, nonatomic) NSString *nombreClase;
@property (assign, nonatomic) BOOL *existe;
@property (strong, nonatomic) IBOutlet UITextView *resumenText;
@property (nonatomic, strong) NSDate *fecha;
- (IBAction)updateResumen:(id)sender;

@end
