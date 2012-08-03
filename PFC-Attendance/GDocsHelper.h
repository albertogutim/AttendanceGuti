//
//  GDocsHelper.h
//  AttendanceGuti
//
//  Created by ANA GUTIÉRREZ ESGUEVILLAS GUTIERREZ ESGUEVILLAS on 03/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Headers/GData.h"

@interface GDocsHelper : NSObject

+(GDocsHelper *)sharedInstance;
- (void) mifetch;

@property(nonatomic,strong) GDataServiceGoogleSpreadsheet *miService;
@property (nonatomic, strong) GDataServiceTicket *mDoclistFetchTicket;
@property (nonatomic, strong) GDataFeedSpreadsheet *mSpreadsheetFeed;
@end
