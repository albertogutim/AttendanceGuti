//
//  GDocsHelper.m
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 03/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GDocsHelper.h"
#import "../Headers/GData.h"
#import "../Headers/GDataSpreadsheet.h"

@implementation GDocsHelper
@synthesize miService = _miService;
@synthesize mSpreadsheetFeed =_mSpreadsheetFeed;
@synthesize delegate = _delegate;
@synthesize mWorksheetFeed = _mWorksheetFeed;
@synthesize mListSpreadsheetId = _mListSpreadsheetId;
@synthesize mListWorksheetId = _mListWorksheetId;



+(GDocsHelper *)sharedInstance {
    
    static GDocsHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance= [[GDocsHelper alloc]init];
        [sharedInstance createSpreadsheetService];
        
    });
    return sharedInstance;
}

- (void)createSpreadsheetService {
    
    self.miService = [[GDataServiceGoogleSpreadsheet alloc] init];
    [self.miService setShouldCacheResponseData:YES];
    [self.miService setServiceShouldFollowNextLinks:YES];
    
}

-(void)credentialsWithUsr:(NSString *)newUsr andPwd:(NSString *)newPwd{

    [self.miService setUserCredentialsWithUsername:newUsr
                                          password:newPwd];
    
}

- (void)listadoAsignaturas {
    
    
        
    
    NSURL *feedURL = [NSURL URLWithString: kGDataGoogleSpreadsheetsPrivateFullFeed];
    
    
    [self.miService fetchFeedWithURL:feedURL
                              delegate:self
                     didFinishSelector:@selector(listadoAsignaturasTicket:finishedWithFeed:error:)];
    
    
}



- (void) listadoAsignaturasTicket: (GDataServiceTicket *) ticket
finishedWithFeed: (GDataFeedSpreadsheet *)feed
          error: (NSError *) error {
    
    
    //NSLog(@"%@",[error description]);
    self.mSpreadsheetFeed = feed;
    
    
    /*GDataEntrySpreadsheet *doc = [[self.mSpreadsheetFeed entries] objectAtIndex:0];
    
    NSString *ttitle = [[doc title] stringValue];
    UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:@"primer doc"
                                                         message:[NSString stringWithFormat:@"titulo: %@", ttitle]
                                                        delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
    
    [alertView show];
    */
    
    
    //creamos una lista de feeds conteniendo solo las asignaturas que empiecen por AT_
    NSMutableArray *listaFeeds = [NSMutableArray arrayWithCapacity: [[self.mSpreadsheetFeed entries] count]];
    NSMutableArray *identifiers = [NSMutableArray arrayWithCapacity: [[self.mSpreadsheetFeed entries] count]];
    NSInteger i = 0;
    for (GDataEntrySpreadsheet *ss in [self.mSpreadsheetFeed entries]) {
        
        if ([[[ss title] stringValue] hasPrefix:@"AT_"]) {
            
            NSString *cadCortada = [[[ss title] stringValue] substringFromIndex:3];
            [listaFeeds addObject:cadCortada];
            [identifiers addObject:[[[self.mSpreadsheetFeed entries]objectAtIndex:i] identifier]];
            
        }
        i++;
    }
    
     NSMutableDictionary *listaSsId = [NSMutableDictionary dictionaryWithObjects:listaFeeds forKeys:identifiers];
    
     NSDictionary * listaSsIdDictionary = [NSDictionary dictionaryWithDictionary:listaSsId];
    
     self.mListSpreadsheetId = listaSsIdDictionary;
     [self.delegate respuesta: listaSsIdDictionary error:error];
    
    //[self.delegate respuesta:[NSArray arrayWithArray:listaFeeds] error:error];
    //devolvemos un array.
     
}



- (void)listadoClasesAsignatura:(NSString *)asignatura
{
    

   /* id selectedClass =[self.mListSpreadsheetId objectForKey:asignatura];
    NSInteger i = 0;
    for (GDataEntrySpreadsheet *ss in [self.mSpreadsheetFeed entries] )
    {
        if ([[[ss title] stringValue] isEqualToString:selectedClass]) 
        {
            
            GDataEntrySpreadsheet *spread = [[self.mSpreadsheetFeed entries] objectAtIndex:i];
            NSURL *f = [spread worksheetsFeedURL];
            
            
            [self.miService fetchFeedWithURL:f
                                    delegate:self
                           didFinishSelector:@selector(listadoClasesAsignaturaTicket:finishedWithFeed:error:)];
            break;
        }
        i++;
    
    }*/
    
    GDataEntrySpreadsheet *ss = [self.mSpreadsheetFeed entryForIdentifier:asignatura];
    NSURL *f = [ss worksheetsFeedURL];
    
    
    [self.miService fetchFeedWithURL:f
                            delegate:self
                   didFinishSelector:@selector(listadoClasesAsignaturaTicket:finishedWithFeed:error:)];


}


- (void)listadoClasesAsignaturaTicket:(GDataServiceTicket *)ticket
        finishedWithFeed:(GDataFeedWorksheet *)feed
                   error:(NSError *)error {
    
    
    self.mWorksheetFeed = feed;
    
    
    /*NSArray *Worksheets = [feed entries];
    GDataEntryWorksheet *Worksheet = [Worksheets objectAtIndex:0];
    
    NSString *ttitleworksheet = [[Worksheet title] stringValue];
    UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:@"worksheet"
                                                         message:[NSString stringWithFormat:@"titulo: %@", ttitleworksheet]
                                                        delegate:self
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
    
    [alertView show];*/
     
    
    NSMutableArray *listaWorksheetFeeds = [NSMutableArray arrayWithCapacity: [[self.mWorksheetFeed entries] count]];
    NSMutableArray *identifiers = [NSMutableArray arrayWithCapacity: [[self.mWorksheetFeed entries] count]];
    NSInteger i = 0;
    for (GDataEntryWorksheet *ws in [self.mWorksheetFeed entries]) {
        
            [listaWorksheetFeeds addObject:[[ws title] stringValue]];
            [identifiers addObject:[[[self.mWorksheetFeed entries]objectAtIndex:i] identifier]];
            i++;
            
    }
    
    NSMutableDictionary *listaWsId = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithArray:listaWorksheetFeeds] forKeys:[NSArray arrayWithArray:identifiers]];
    
    NSDictionary * listaWsIdDictionary = [NSDictionary dictionaryWithDictionary:listaWsId];
    self.mListWorksheetId = listaWsIdDictionary;
    [self.delegate respuesta: listaWsIdDictionary error:error];
    
}


@end

