//
//  ResumenVC.h
//  AttendanceGuti
//
//  Created by ANA GUTIERREZ ESGUEVILLAS on 28/08/12.
//
//

#import <UIKit/UIKit.h>
#import "GDocsHelper.h"

@interface ResumenVC : UIViewController <GDocsHelperDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *todosPresentesAusentes;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sendButton;

- (IBAction)changeSegmentedControl:(id)sender;

- (IBAction)sendResumen:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) NSMutableDictionary *alumnos;
@property (assign, nonatomic) NSInteger columna;
@property (strong, nonatomic) NSString *clase;
@property (assign, nonatomic) BOOL *existe;
@property (strong, nonatomic) IBOutlet UITextView *resumenText;
- (IBAction)updateResumen:(id)sender;

@end
