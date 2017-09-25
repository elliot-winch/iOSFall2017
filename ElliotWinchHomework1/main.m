//
//  main.m
//  Assignment1
//
//  Created by Elliot Winch on 25/09/2017.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import <Foundation/Foundation.h>

/////////////

@interface Object_Info : NSObject
{
    NSString *_description;
    float _retail_cost;
    float _wholesale_cost;
    int _num_on_hand;
    int _num_sold;
}

-(NSString *) description;
-(void) setDescription: (NSString *) description;
-(float) retailCost;
-(void) setRetailCost: (float) retailCost;
-(float) wholesaleCost;
-(void) setWholesaleCost: (float) wholesaleCost;
-(int) numOnHand;
-(void) setNumOnHand: (int) numOnHand;
-(int) numSold;
-(void) setNumSold: (float) numSold;
-(id) initWithValues: (NSString*) d
          retailCost:(float)rc wholesaleCost:(float)wc;
-(void) printOject;

@end


///////////////


@implementation Object_Info

-(NSString *) description{
    return _description;
}

-(void) setDescription: (NSString *) description{
    _description = description;
}

-(float) retailCost{
    return _retail_cost;
}

-(void) setRetailCost: (float) retailCost{
    _retail_cost = retailCost;
}

-(float) wholesaleCost{
    return _wholesale_cost;
}

-(void) setWholesaleCost: (float) wholesaleCost{
    _wholesale_cost = wholesaleCost;
}
-(int) numOnHand{
    return _num_on_hand;
}

-(void) setNumOnHand: (int) numOnHand{
    _num_on_hand = numOnHand;
}
-(int) numSold{
    return _num_sold;
}

-(void) setNumSold: (float) numSold{
    _num_sold = numSold;
}

-(id) initWithValues: (NSString*) description
          retailCost:(float)rc wholesaleCost:(float)wc{
    if( self = [super init]){
        [self setDescription: description];
        [self setRetailCost: rc];
        [self setWholesaleCost: wc];
        [self setNumOnHand:0];
        [self setNumSold:0];
    }
    
    return self;
}

-(void) printOject{
    NSLog(@"Description: %@\n", _description);
    NSLog(@"Retail Cost: %f\n", _retail_cost);
    NSLog(@"Wholesale Cost: %f\n", _wholesale_cost);
    NSLog(@"Number On Hand: %d\n", _num_on_hand);
    NSLog(@"Number Sold: %d\n", _num_sold);
}

@end

/////////////////////

@interface Stock : NSObject
{
    NSMutableDictionary *_stockList;
}

-(void) printObject: (NSString*) key;
-(void) printAll;
-(BOOL) addItem: (NSString*)key description:(NSString *)d
     retailCost:(float)rc wholesaleCost:(float)wc;
-(void) addStock: (NSString *)key numStock:(int)nS;
-(void) sellItem: (NSString*)key numToSell:(int)nToSell ;
-(void) deleteItem: (NSString*) key;
-(void) profitOfStore;

@end

///////////////////////

@implementation Stock

-(void) printObject: (NSString*) key{
    if(_stockList == nil){
        NSLog(@"Stock not initialized");
        return;
    }
    
    Object_Info *oi = _stockList[key];
    
    if(oi != nil){
        NSLog(@"Name: %@\n", key);
        [oi printOject];
        return;
    }
    
    NSLog(@"Error: Could not find %@ in stock list", key);
}

-(void) printAll{
    NSArray * keys = [_stockList allKeys];
    
    for(int i = 0; i < [keys count]; i++){
        NSLog(@"%@:\n", keys[i]);
        [self printObject: keys[i]];
    }
}


-(BOOL) addItem: (NSString*)key description:(NSString *)d
     retailCost:(float)rc wholesaleCost:(float)wc{
    
    if(_stockList == nil){
        _stockList = [NSMutableDictionary new];
    }
    
    Object_Info *oi = [Object_Info alloc];
    oi = [oi initWithValues: d retailCost:rc wholesaleCost:wc];
    
    if(_stockList[key] != nil){
        return false;
    }
    
    [_stockList setObject:oi forKey:key];
    return true;
}


-(void) addStock: (NSString *)key numStock:(int)nS{
    
    if(_stockList == nil){
        NSLog(@"Stock not initialized");
        return;
    }
    
    Object_Info* readOnlyObjInfo = _stockList[key];
    
    if(readOnlyObjInfo != nil){
        [_stockList[key] setNumOnHand:[readOnlyObjInfo numOnHand] + nS];
        return;
    }
    
    NSLog(@"Error: Could not add stock to %@ since it is not in the stock list", key);
}

-(void) sellItem: (NSString*)key numToSell:(int)nToSell {
    if(_stockList == nil){
        NSLog(@"Stock not initialized");
        return;
    }
    
    if(nToSell < 0){
        NSLog(@"Failed to sell: argument numToSell cannnot be less than 0.");
    }
    
    Object_Info* readOnlyObjInfo = _stockList[key];
    
    if(readOnlyObjInfo != nil){
        if([readOnlyObjInfo numOnHand] - nToSell < 0){
            NSLog(@"Error: Could not sell stock from %@ since there are not enough!", key);
            return;
        }
        
        [_stockList[key] setNumOnHand:[readOnlyObjInfo numOnHand] - nToSell];
        [_stockList[key] setNumSold: nToSell];
        return;
    }
    
    NSLog(@"Error: Could not sell stock from %@ since it is not in the stock list", key);
    
}

-(void) deleteItem:(NSString *)key{
    if(_stockList == nil){
        NSLog(@"Stock not initialized");
    }
    
    if(key != nil){
        [_stockList removeObjectForKey:key];
    }
}

-(void) profitOfStore{
    if(_stockList == nil){
        NSLog(@"Stock not initialized");
        return;
    }
    
    float totalProfits = 0;
    
    NSArray *values;
    
    values = [_stockList allValues];
    for (int i = 0; i < [_stockList count]; i++){
        totalProfits += ([values[i] retailCost] - [values[i] wholesaleCost]) * [values[i] numSold];
    }
    
    NSLog(@"Total profits are %f.", totalProfits);
}

@end

////////////////////



int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        
        Stock* stock = [Stock new];
        
        [stock addStock:@"iPhone X" numStock:100];
        [stock sellItem:@"iPhone X" numToSell:100];
        [stock profitOfStore];
        
        [stock addItem:@"iPhone X" description:@"Hot of the presses" retailCost:999.99 wholesaleCost:10.00];
        [stock addItem:@"iPhone X" description:@"Hot of the presses" retailCost:999.99 wholesaleCost:10.00];
        
        [stock addItem:@"iPhone 7" description:@"Old news" retailCost:799.99 wholesaleCost:9.00];
        
        [stock addItem:@"iPhone 6" description:@"So 2014" retailCost:599.99 wholesaleCost:8.00];
        
        [stock addItem:@"iPhone 5" description:@"Vintage" retailCost:399.99 wholesaleCost:15.00];
        
        [stock addItem:@"iPhone (Original)" description:@"OG" retailCost:199.99 wholesaleCost:1.00];
        
        [stock printObject:@"iPhone X"];
        [stock printObject:@"iPhone 4"];
        
        [stock printAll];
        
        [stock addStock:@"iPhone X" numStock:100];
        [stock addStock:@"iPhone 7" numStock:200];
        [stock addStock:@"iPhone 6" numStock:300];
        [stock addStock:@"iPhone 4" numStock:100];
        
        [stock printAll];
        
        [stock deleteItem:@"iPhone (Original)"];
        
        [stock printAll];
        
        [stock sellItem:@"iPhone X" numToSell:100];
        [stock sellItem:@"iPhone X" numToSell:50];
        [stock sellItem:@"iPhone 7" numToSell:250];
        [stock sellItem:@"iPhone 4" numToSell:100];
        
        [stock profitOfStore];
        
    }
    return 0;
}

#import "Object_Info.h"

@implementation Object_Info

-(NSString *) description{
    return _description;
}

-(void) setDescription: (NSString *) description{
    _description = description;
}

-(float) retailCost{
    return _retail_cost;
}

-(void) setRetailCost: (float) retailCost{
    _retail_cost = retailCost;
}

-(float) wholesaleCost{
    return _wholesale_cost;
}

-(void) setWholesaleCost: (float) wholesaleCost{
    _wholesale_cost = wholesaleCost;
}
-(int) numOnHand{
    return _num_on_hand;
}

-(void) setNumOnHand: (int) numOnHand{
    _num_on_hand = numOnHand;
}
-(int) numSold{
    return _num_sold;
}

-(void) setNumSold: (float) numSold{
    _num_sold = numSold;
}

-(id) initWithValues: (NSString*) description
          retailCost:(float)rc wholesaleCost:(float)wc{
    if( self = [super init]){
        [self setDescription: description];
        [self setRetailCost: rc];
        [self setWholesaleCost: wc];
        [self setNumOnHand:0];
        [self setNumSold:0];
    }
    
    return self;
}

-(void) printOject{
    NSLog(@"Description: %@\n", _description);
    NSLog(@"Retail Cost: %f\n", _retail_cost);
    NSLog(@"Wholesale Cost: %f\n", _wholesale_cost);
    NSLog(@"Number On Hand: %d\n", _num_on_hand);
    NSLog(@"Number Sold: %d\n", _num_sold);
}

@end

/////////////////////

@interface Stock : NSObject
{
    NSMutableDictionary *_stockList;
}

-(void) printObject: (NSString*) key;
-(BOOL) addItem: (NSString*)key description:(NSString *)d
     retailCost:(float)rc wholesaleCost:(float)wc;
-(void) addStock: (NSString *)key numStock:(int)nS;
-(void) sellItem: (NSString*)key numToSell:(int)nToSell ;
-(void) profitOfStore;

@end

///////////////////////

@implementation Stock

-(void) printObject: (NSString*) key{
    if(_stockList == nil){
        NSLog(@"Stock not initialized");
        return;
    }
    
    Object_Info *oi = _stockList[key];
    
    if(oi != nil){
        NSLog(@"Name: %@\n", key);
        [oi printOject];
        return;
    }
    
    NSLog(@"Error: Could not find %@ in stock list", key);
}


-(BOOL) addItem: (NSString*)key description:(NSString *)d
     retailCost:(float)rc wholesaleCost:(float)wc{
    
    if(_stockList == nil){
        _stockList = [NSMutableDictionary new];
    }
    
    Object_Info *oi = [Object_Info alloc];
    oi = [oi initWithValues: d retailCost:rc wholesaleCost:wc];
    
    if(_stockList[key] != nil){
        return false;
    }
    
    [_stockList setObject:oi forKey:key];
    return true;
}


-(void) addStock: (NSString *)key numStock:(int)nS{
    
    if(_stockList == nil){
        NSLog(@"Stock not initialized");
        return;
    }
    
    Object_Info* readOnlyObjInfo = _stockList[key];
    
    if(readOnlyObjInfo != nil){
        [_stockList[key] setNumOnHand:[readOnlyObjInfo numOnHand] + nS];
        return;
    }
    
    NSLog(@"Error: Could not add stock to %@ since it is not in the stock list", key);
}

-(void) sellItem: (NSString*)key numToSell:(int)nToSell {
    if(_stockList == nil){
        NSLog(@"Stock not initialized");
        return;
    }
    
    Object_Info* readOnlyObjInfo = _stockList[key];
    
    if(readOnlyObjInfo != nil){
        if([readOnlyObjInfo numOnHand] - nToSell < 0){
            NSLog(@"Error: Could not sell stock from %@ since there are not enough!", key);
            return;
        }
        
        [_stockList[key] setNumOnHand:[readOnlyObjInfo numOnHand] - nToSell];
        [_stockList[key] setNumSold: nToSell];
        return;
    }
    
    NSLog(@"Error: Could not sell stock from %@ since it is not in the stock list", key);
    
}

-(void) profitOfStore{
    if(_stockList == nil){
        NSLog(@"Stock not initialized");
        return;
    }
    
    float totalProfits = 0;
    
    NSArray *values;
    
    values = [_stockList allValues];
    for (int i = 0; i < [_stockList count]; i++){
        totalProfits += ([values[i] retailCost] - [values[i] wholesaleCost]) * [values[i] numSold];
    }
    
    NSLog(@"Total profits are %f.", totalProfits);
}

@end

////////////////////



int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        
        Stock* stock = [Stock new];
        
        [stock addStock:@"iPhone X" numStock:100];
        [stock sellItem:@"iPhone X" numToSell:100];
        [stock profitOfStore];
        
        [stock addItem:@"iPhone X" description:@"Hot of the presses" retailCost:999.99 wholesaleCost:10.00];
        [stock addItem:@"iPhone X" description:@"Hot of the presses" retailCost:999.99 wholesaleCost:10.00];
        
        [stock addItem:@"iPhone 7" description:@"Old news" retailCost:799.99 wholesaleCost:9.00];
        
        [stock addItem:@"iPhone 6" description:@"So 2014" retailCost:599.99 wholesaleCost:8.00];
        
        [stock addItem:@"iPhone 5" description:@"Vintage" retailCost:399.99 wholesaleCost:15.00];
        
        [stock addItem:@"iPhone (Original)" description:@"OG" retailCost:199.99 wholesaleCost:1.00];
        
        [stock printObject:@"iPhone X"];
        [stock printObject:@"iPhone 4"];

        [stock addStock:@"iPhone X" numStock:100];
        [stock addStock:@"iPhone 7" numStock:200];
        [stock addStock:@"iPhone 6" numStock:300];
        [stock addStock:@"iPhone 4" numStock:100];
        
        [stock sellItem:@"iPhone X" numToSell:100];
        [stock sellItem:@"iPhone X" numToSell:50];
        [stock sellItem:@"iPhone 7" numToSell:250];
        [stock sellItem:@"iPhone 4" numToSell:100];
        
        [stock profitOfStore];

    }
    return 0;
}
