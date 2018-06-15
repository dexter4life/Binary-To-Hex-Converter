
#include <cstdlib>
#include <cstdio>
#include <iostream>
#include <algorithm>
#include <string>
#include <cstring>
using namespace std;

int main( void )
{
	string mynames[] = {
	"Peter", "Nwanosike", "Dexter", "Joe", "Chukwuemeka"};

	for( int i = 0; i < 5; i++ )
	 cout << mynames[ i ] << ' ';

	cout << endl;

	for( int i =5; i > 0; i-- )
	{
		for( int j = 0; j < i-1; j++ )
		if( strcmp( mynames[j].c_str(), mynames[j+1].c_str() ) > 0 )
		swap( mynames[j], mynames[j+1] );
	}
	
	for( int i = 0; i < 5; i++ )
	 cout << mynames[ i ] << ' ';

	cout << endl;
	 
	
	cin.get();
	return 0;
}