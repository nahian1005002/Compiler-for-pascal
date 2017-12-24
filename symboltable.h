#include<stdio.h>
#include <cstdio>
#include <string>
#include <algorithm>
#include<cstdlib>
#include<list>
#include <set>
#include <iostream>

using namespace std;

//#ifndef symboltable_h_included
//#define symboltable_h_included

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

class SymbolTable
{
	list<SymbolInfo> table[TABLESIZE];
public:
	bool insert(SymbolInfo in);
	void dump();
	SymbolInfo* lookup(string symbol);
	static int calculateHashValue(string symbol, int modVal)
    {
        int hashValue = 5381;

        for (const char *p = symbol.c_str(); *p; p++)
            hashValue = (((hashValue << 5) + hashValue) + *p) % modVal;

        return hashValue;
    }
};

bool SymbolTable::insert(SymbolInfo in)
{
	if (!lookup(in.symbol))
	{
		table[calculateHashValue(in.symbol,TABLESIZE)].push_back(in);
		return true;
	}
	else
        return false;
}

SymbolInfo* SymbolTable::lookup(string symbol)
{
	int hashval=calculateHashValue(symbol,TABLESIZE);
	list<SymbolInfo>::iterator it;
	for(it=table[hashval].begin();it!=table[hashval].end();it++)
		if(it->symbol==symbol)
		{
			return &(*it);
		}
	return NULL;
}

void SymbolTable::dump()
{
	for(int i=0;i<TABLESIZE;i++)
	{
		list<SymbolInfo>::iterator it;
		for(it=table[i].begin();it!=table[i].end();it++)
			cout<<it->symbol<<' '<<it->type<<endl;
	}
}

/*
void insertIntoSymbolTable(SymbolTable &st,string symbol,string type)
{
	//SymbolInfo sym;
	string symbol,type;

    cout << "Insert symbol and data type : ";
	getline(cin,symbol);
	getline(cin,symbol,',');
	cin >>type;

    if (!st.lookup(symbol))
        st.insert(SymbolInfo(symbol,type));
    //else
       // cout << "Symbol already in symbol-table\n";
}
	*/

