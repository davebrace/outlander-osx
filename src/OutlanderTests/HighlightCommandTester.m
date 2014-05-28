//
//  VarCommandHandlerTester.m
//  Outlander
//
//  Created by Joseph McBride on 5/27/14.
//  Copyright (c) 2014 Joe McBride. All rights reserved.
//

#import "Kiwi.h"
#import "HighlightCommandHandler.h"
#import "Highlight.h"
#import "GameContext.h"

SPEC_BEGIN(HighlightCommandHandlerTester)

describe(@"highlight command handler", ^{
   
    __block HighlightCommandHandler *theHandler = nil;
    __block GameContext *theContext = nil;
    
    beforeEach(^{
        theHandler = [[HighlightCommandHandler alloc] init];
        theContext = [[GameContext alloc] init];
    });
    
    context(@"can handle", ^{
        it(@"success", ^{
            BOOL result = [theHandler canHandle:@"#highlight #000fff something"];
            [[theValue(result) should] equal:theValue(YES)];
        });
        
        it(@"failure", ^{
            BOOL result = [theHandler canHandle:@"highlight one two"];
            [[theValue(result) should] equal:theValue(NO)];
        });
    });
    
    context(@"handle", ^{
        it(@"adds highlight to collection", ^{
            [theHandler handle:@"#highlght #000fff something" withContext:theContext];
            
            Highlight *hl = theContext.highlights[0];
            [[hl.color should] equal:@"#000fff"];
            [[hl.pattern should] equal:@"something"];
        });
    });
});

SPEC_END