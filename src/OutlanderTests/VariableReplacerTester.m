//
//  VariableReplacerTester.m
//  Outlander
//
//  Created by Joseph McBride on 5/22/14.
//  Copyright (c) 2014 Joe McBride. All rights reserved.
//

#import "Kiwi.h"
#import "VariableReplacer.h"
#import "Alias.h"
#import "Outlander-Swift.h"

SPEC_BEGIN(VariableReplacerTester)

describe(@"Variable Replacer", ^{
    
    __block VariableReplacer *_replacer;
    __block GameContext *_context;
    
    beforeEach(^{
        _replacer = [[VariableReplacer alloc] init];
        _context = [GameContext newInstance];
    });
    
    context(@"replace", ^{
        
        context(@"alias", ^{
            
            it(@"should replace alias", ^{
                Alias *al = [[Alias alloc] init];
                al.pattern = @"l2";
                al.replace = @"load arrows";
                [_context.aliases addObject:al];
                
                NSString *result = [_replacer replace:@"l2" withContext:_context];
                
                [[result should] equal:@"load arrows"];
            });
            
            it(@"should replace alias variables", ^{
                Alias *al = [[Alias alloc] init];
                al.pattern = @"fire";
                al.replace = @"snipe $0";
                [_context.aliases addObject:al];
                
                NSString *result = [_replacer replace:@"fire one two" withContext:_context];
                
                [[result should] equal:@"snipe one two"];
            });
            
            it(@"should replace alias variables 2", ^{
                Alias *al = [[Alias alloc] init];
                al.pattern = @"fire";
                al.replace = @"aim $1;snipe $2;look $3";
                [_context.aliases addObject:al];
                
                NSString *result = [_replacer replace:@"fire one \"two three\" four" withContext:_context];
                
                [[result should] equal:@"aim one;snipe \"two three\";look four"];
            });
            
            it(@"should replace alias variables 3", ^{
                Alias *al = [[Alias alloc] init];
                al.pattern = @"fire";
                al.replace = @"aim $1;snipe $2";
                [_context.aliases addObject:al];
                
                NSString *result = [_replacer replace:@"fire one two" withContext:_context];
                
                [[result should] equal:@"aim one;snipe two"];
            });
            
            it(@"should not match partial", ^{
                Alias *al = [[Alias alloc] init];
                al.pattern = @"fir";
                al.replace = @"aim $1;snipe $2";
                [_context.aliases addObject:al];
                
                NSString *result = [_replacer replace:@"fire one two" withContext:_context];
                
                [[result should] equal:@"fire one two"];
            });
        });
        
        context(@"global vars", ^{
            
            it(@"should replace global variable", ^{
                
                [_context.globalVars setCacheObject:@"longsword" forKey:@"lefthand"];
                
                NSString *result = [_replacer replace:@"$lefthand" withContext:_context];
                
                [[result should] equal:@"longsword"];
            });
            
            it(@"should replace multiple global variables within text", ^{
                
                [_context.globalVars setCacheObject:@"longsword" forKey:@"lefthand"];
                [_context.globalVars setCacheObject:@"backpack" forKey:@"primary.container"];
                
                NSString *result = [_replacer replace:@"stow my $lefthand in my $primary.container" withContext:_context];
                
                [[result should] equal:@"stow my longsword in my backpack"];
            });
            
            it(@"should handle unfound vars", ^{
                NSString *result = [_replacer replace:@"$does_not_exist" withContext:_context];
                
                [[result should] equal:@"$does_not_exist"];
            });
        });
        
        context(@"local vars", ^{
            
            __block TSMutableDictionary *_localVars;
            
            beforeEach(^{
                _localVars = [[TSMutableDictionary alloc] initWithName:@"localvars"];
            });
            
            
            it(@"should replace local variable", ^{
                
                [_localVars setCacheObject:@"longsword" forKey:@"lefthand"];
                
                NSString *result = [_replacer replaceLocalVars:@"%lefthand" withVars:_localVars];
                
                [[result should] equal:@"longsword"];
            });
            
            it(@"should replace multiple global variables within text", ^{
                
                [_localVars setCacheObject:@"longsword" forKey:@"lefthand"];
                [_localVars setCacheObject:@"backpack" forKey:@"primary.container"];
                
                NSString *result = [_replacer replaceLocalVars:@"stow my %lefthand in my %primary.container" withVars:_localVars];
                
                [[result should] equal:@"stow my longsword in my backpack"];
            });
            
            it(@"should handle unfound vars", ^{
                NSString *result = [_replacer replaceLocalVars:@"$does_not_exist" withVars:_localVars];
                
                [[result should] equal:@"$does_not_exist"];
            });
        });
        
        context(@"local argument vars", ^{
            
            __block TSMutableDictionary *_localVars;
            
            beforeEach(^{
                _localVars = [[TSMutableDictionary alloc] initWithName:@"argumentvars"];
            });
            
            
            it(@"should replace local variable", ^{
                
                [_localVars setCacheObject:@"longsword" forKey:@"0"];
                
                NSString *result = [_replacer replaceLocalArgumentVars:@"$0" withVars:_localVars];
                
                [[result should] equal:@"longsword"];
            });
            
            it(@"should replace multiple global variables within text", ^{
                
                [_localVars setCacheObject:@"longsword" forKey:@"1"];
                [_localVars setCacheObject:@"backpack" forKey:@"2"];
                
                NSString *result = [_replacer replaceLocalArgumentVars:@"stow my $1 in my $2" withVars:_localVars];
                
                [[result should] equal:@"stow my longsword in my backpack"];
            });
            
            it(@"should handle unfound vars", ^{
                NSString *result = [_replacer replaceLocalArgumentVars:@"$0" withVars:_localVars];
                
                [[result should] equal:@"$0"];
            });
        });
    });
});

SPEC_END
