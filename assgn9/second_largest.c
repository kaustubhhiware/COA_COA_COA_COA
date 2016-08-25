#include <stdio.h>
#include <stdlib.h>
int main()
{
	int n;

	printf("Enter the count of elements to be read");
	scanf("%d",&n);
	int *a=(int *)malloc(n*sizeof(int));
	int i;
	for(i=0;i<n;i++)
	{
		printf("Enter the next element:");
		scanf("%d",&a[i]);
		
	}
	int first=a[0];
	int second=a[0];
	if(a[0]>a[1])
	{
		second = a[1];
	}
	else{first = a[1];}

	for(i=2;i<n;i++)
	{
		if(a[i]>=first)
		{
			second=first;
			first=a[i];
		}
		else if(a[i]>=second)
		{
			second=a[i];
		}
	}
	printf("The second largest number among [%d",a[0]);
	for(i=1;i<n;i++)
		printf(",%d",a[i]);
	printf(" is %d\n",second);
	return 0;
}