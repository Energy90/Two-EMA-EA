//+------------------------------------------------------------------+
//|                                                   two_ema_ea.mq5 |
//|                                        Copyright 2025, Clarence. |
//|                                              mcmalindi@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Clarence."
#property link      "mcode.co.za"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>

//--- input parameters
input uint stopLoss = 12;              // Stop Loss
input uint takeProfit = 50;            // Take Profit
input uint fastMA = 44;                // Fast MA Period
input uint slowMA = 70;                // Slow MA Period
input ulong eaMagicNumber = 20250512;  // Magic Number
input double lotSize = 0.01;                   // Lot Size
input uint pipMove = 5;                  // Pip Movement
input ENUM_MA_METHOD inputMethod = MODE_EMA;
input ENUM_APPLIED_PRICE inputPrice = PRICE_CLOSE;

//--- other parameters
int fmaHandle;
int smaHandle;
double fmaVal[];
double smaVal[];
uint sLoss, tProfit, pMove;
int fmaPeriod;
int smaPeriod;
uint totalBars;

CTrade trade;

int OnInit()
  {
//---
      totalBars = iBars(_Symbol, PERIOD_CURRENT);
      //---initialize handles
      fmaPeriod = int(fastMA < 1 ? 44 : fastMA);
      smaPeriod = int(slowMA < 1 ? 70 : slowMA);
      
      fmaHandle = iMA(NULL, 0, fmaPeriod, 0, inputMethod, PRICE_CLOSE);
      smaHandle = iMA(NULL, 0, smaPeriod, 0, inputMethod, PRICE_CLOSE);
      
      ResetLastError();
      
      if(fmaHandle == INVALID_HANDLE || smaHandle == INVALID_HANDLE)
      {
         Alert("Error Creating Handle for indicators: %d", GetLastError(), "!!");
         return(INIT_FAILED);
      }
      
      ArraySetAsSeries(fmaVal, true);
      ArraySetAsSeries(smaVal, true);
      
      //--- currency pairs with 5 or 3 digit prices
      sLoss = stopLoss;
      tProfit = takeProfit;
      
      if(_Digits == 5 || _Digits == 3)
      {
         sLoss = stopLoss * 10;
         tProfit = takeProfit * 10;
         pMove = pipMove * 10;
      }
        
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
      // release indicators
      IndicatorRelease(fmaHandle);
      IndicatorRelease(smaHandle);
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      /*
       * The number of bars of a corresponding
       * symbol and period, available in history
       */
      int bars = iBars(NULL, 0);
      if(totalBars != bars)
      {
         totalBars = bars;
         if(CopyBuffer(fmaHandle, 0, 1, 1, fmaVal) < 0 || CopyBuffer(smaHandle, 0, 1, 1, smaVal) < 0)
         {
            Alert("Error copying Moving Average indicators Buffers - errors: ", GetLastError(), "!!");
            return;
         }
         // check for open position
         if(PositionSelect(_Symbol) == false)
         {
            double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
         
         
            if(fmaVal[0] > smaVal[0] && fmaVal[0] < smaVal[0]+pMove*_Point)
            {
               trade.Buy(lotSize, _Symbol, ask, ask-sLoss*_Point, ask+tProfit*_Point);
            }
            else if(fmaVal[0] < smaVal[0] && smaVal[0] < fmaVal[0]+pMove*_Point)
            {
               trade.Sell(lotSize, _Symbol, bid, bid+sLoss*_Point, bid-tProfit*_Point);
            }
         }
      }  
  }
 //+------------------------------------------------------------------+ 
