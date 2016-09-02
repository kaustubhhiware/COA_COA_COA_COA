#include <iostream>
#include <string>

using namespace std;

string fib(int n)
{
	if(n==0)
		return "0";
	if(n==1)
		return "01";
	else
	{
		return fib(n-1)+fib(n-2);
	}
}
int main()
{
	int n;
	cout<<"Enter the value of n: ";
	cin>>n;
	cout<<"The corresponding string is: ";
	cout<<fib(n);
	return 0;
}
