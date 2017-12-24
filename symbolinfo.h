#include<stdio.h>
#include <cstdio>
#include <string>
#include <algorithm>
#include<cstdlib>
#include<list>
#include <set>
#include <iostream>

using namespace std;

#define TABLESIZE 100

class SymbolInfo
{
	string symbol,type,code;
public:
	SymbolInfo(string a,string b,string c)
	{
		symbol=a;
		type=b;
		code=c;
	}
	string getSymbol()
	{
		return symbol;
	}
	string getType()
	{
		return type;
	}
	string getCode()
	{
        return code;
	}
	friend class SymbolTable;
};

