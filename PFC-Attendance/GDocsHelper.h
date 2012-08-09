//
//  GDocsHelper.h
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 03/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Headers/GData.h"

@class GDocsHelper;

@protocol GDocsHelperDelegate <NSObject> 

- (void)respuesta:(NSDictionary *) feed error: (NSError *) error;
@end


@interface GDocsHelper : NSObject

+(GDocsHelper *)sharedInstance;
-(void)createSpreadsheetService;
-(void)credentialsWithUsr:(NSString *)newUsr andPwd:(NSString *)newPwd;
-(void)listadoAsignaturas;
-(void)listadoAsignaturasTicket: (GDataServiceTicket *) ticket
                 finishedWithFeed: (GDataFeedSpreadsheet *) feed
                            error: (NSError *) error;

-(void)listadoClasesAsignatura:(NSString *)asignatura;
-(void)listadoClasesAsignaturaTicket:(GDataServiceTicket *)ticket
                     finishedWithFeed:(GDataFeedWorksheet *)feed
                                error:(NSError *)error;

- (void)listadoAlumnosClase:(NSString *)clase paraFecha:(NSDate *)newFecha paraEstadosPorDefecto:(BOOL) estados;
- (void)listadoAlumnosClaseTicket:(GDataServiceTicket *)ticket
                 finishedWithFeed:(GDataFeedBase *)feed
                            error:(NSError *)error;


@property(nonatomic,strong) GDataServiceGoogleSpreadsheet *miService;
@property (nonatomic, strong) GDataFeedSpreadsheet *mSpreadsheetFeed;
@property (nonatomic, strong) GDataFeedWorksheet *mWorksheetFeed;
@property (nonatomic, strong) GDataFeedBase *mListCells;
@property (nonatomic, strong) GDataFeedBase *mListFechas;
@property (nonatomic, strong) GDataEntryWorksheet *miClaseWs;

@property (nonatomic, weak) id <GDocsHelperDelegate> delegate;

@property (nonatomic, strong) NSDictionary *mListSpreadsheetId;
@property (nonatomic, strong) NSDictionary *mListWorksheetId;

@property (nonatomic, assign) BOOL estados;
@property (nonatomic, strong) NSDate *fecha;



@end
