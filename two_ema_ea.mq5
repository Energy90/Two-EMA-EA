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
   
  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
  {
//---
   
  }
//+------------------------------------------------------------------+
