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
@required
- (void)respuesta:(GDataFeedSpreadsheet *) feed;

@end

@interface GDocsHelper : NSObject

+(GDocsHelper *)sharedInstance;
- (void) mifetch;
- (void) ticket: (GDataServiceTicket *) ticket
                 finishedWithFeed: (GDataFeedSpreadsheet *) feed
                            error: (NSError *) error;


@property(nonatomic,strong) GDataServiceGoogleSpreadsheet *miService;
@property (nonatomic, strong) GDataFeedSpreadsheet *mSpreadsheetFeed;
@property (nonatomic, weak) id <GDocsHelperDelegate> delegate;
@end
