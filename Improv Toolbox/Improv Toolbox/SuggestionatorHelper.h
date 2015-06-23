//
//  SuggestionatorHelper.h
//  Improv Toolbox
//
//  Created by Sydney Richardson on 11/20/14.
//  Copyright (c) 2014 Gainesville Improv Festival. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuggestionatorHelper : NSObject

@property (strong, nonatomic) NSArray *objects;
@property (strong, nonatomic) NSArray *relationships;
@property (strong, nonatomic) NSArray *adjectives;
@property (strong, nonatomic) NSArray *locations;
@property (strong, nonatomic) NSArray *occupations;
@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) NSArray *genres;
@property (strong, nonatomic) NSArray *persons;
@property (strong, nonatomic) NSArray *emotions;

-(void)parseJsonData:(NSData *)data;

-(NSString *)getObject;
-(NSString *)getRelationship;
-(NSString *)getLocation;
-(NSString *)getOccupation;
-(NSString *)getEvent;
-(NSString *)getGenre;
-(NSString *)getPerson;
-(NSString *)getEmotion;
-(NSString *)getOddball;

@end
