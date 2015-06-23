//
//  SuggestionatorHelper.m
//  Improv Toolbox
//
//  Created by Sydney Richardson on 11/20/14.
//  Copyright (c) 2014 Gainesville Improv Festival. All rights reserved.
//

#import "SuggestionatorHelper.h"
#include <stdlib.h>

@implementation SuggestionatorHelper

-(void)parseJsonData:(NSData *)data
{
    NSDictionary *jsonDictionay = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:0
                                                                    error:nil];
    self.objects = [jsonDictionay objectForKey:@"object"];
    self.relationships = [jsonDictionay objectForKey:@"relationship"];
    self.adjectives = [jsonDictionay objectForKey:@"adjective"];
    self.locations = [jsonDictionay objectForKey:@"location"];
    self.occupations = [jsonDictionay objectForKey:@"occupation"];
    self.events = [jsonDictionay objectForKey:@"event"];
    self.genres = [jsonDictionay objectForKey:@"genre"];
    self.persons = [jsonDictionay objectForKey:@"person"];
    self.events = [jsonDictionay objectForKey:@"event"];
    self.emotions = [jsonDictionay objectForKey:@"emotion"];

}

-(NSString *)getObject
{
    return [self.objects objectAtIndex:arc4random_uniform((int)[self.objects count])];
}

-(NSString *)getRelationship
{
    //get relationship and two adjectives
    NSArray *relationship = [self.relationships objectAtIndex:arc4random_uniform((int)[self.relationships count])];
    NSString *adjective1 = [self.adjectives objectAtIndex:arc4random_uniform((int)[self.adjectives count])];
    NSString *adjective2 = [self.adjectives objectAtIndex:arc4random_uniform((int)[self.adjectives count])];
    //String result = "A "+ ad1 + " " + relationship[x][0] + " and their " + ad2 + " " + relationship[x][1];
    return [NSString stringWithFormat:@"A %@ %@ and their %@ %@", adjective1, [relationship objectAtIndex:0], adjective2, [relationship objectAtIndex:1]];

}
-(NSString *)getLocation
{
    return [self.locations objectAtIndex:arc4random_uniform((int)[self.locations count])];
}
-(NSString *)getOccupation
{
    return [self.occupations objectAtIndex:arc4random_uniform((int)[self.occupations count])];
}
-(NSString *)getEvent
{
    return [self.events objectAtIndex:arc4random_uniform((int)[self.events count])];
}
-(NSString *)getGenre
{
    return [self.genres objectAtIndex:arc4random_uniform((int)[self.genres count])];
}
-(NSString *)getPerson
{
    return [self.persons objectAtIndex:arc4random_uniform((int)[self.persons count])];
}
-(NSString *)getEmotion
{
    return [self.emotions objectAtIndex:arc4random_uniform((int)[self.emotions count])];
}
-(NSString *)getOddball
{
    long coin = arc4random();
    NSLog(@"coin value: %lu", coin);
    NSString *subject;
    //random person or occupation
    if (coin > .5) {
        //random person
        subject = [self getPerson];
    }
    else {
        //random occupation
        subject = [self getOccupation];
    }
    
    return [NSString stringWithFormat:@"%@ %@", subject, [self getEvent]];
}

@end
