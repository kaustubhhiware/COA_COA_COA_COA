#include <stdio.h>
#include <stdlib.h>

void populate(int **x,int s,int n,int m)
{
	int i,j;
	int a=7*47+1,c=100,mod=48*48-1;
	for(i=0;i<n;i++)
	{
		for(j=0;j<n;j++)
		{
			x[i][j]=s;
			s=(a*s+c)%mod;
		}
	}
}

void matPrint(int **a,int n,int m)
{
	int i,j;
	for(i=0;i<n;i++)
	{
		for(j=0;j<m;j++)
			printf("%d ",a[i][j]);
	}
}

void matAdd(int **a,int **b,int **c,int n,int m)
{
	int i,j;
	for(i=0;i<n;i++)
	{
		for(j=0;j<m;j++)
		{
			c[i][j] = a[i][j]+b[i][j];
		}
	}
}

int main()
{
	int s,m,n;
	scanf("%d",&s);
	scanf("%d",&m);
	scanf("%d",&n);

	int **a=(int **)malloc(n*sizeof(int *));
	int **b=(int **)malloc(n*sizeof(int *));
	int **c=(int **)malloc(n*sizeof(int *));

	int i;
	for(i=0;i<n;i++)
	{
		a[i]=(int *)malloc(sizeof(int)*m);
		b[i]=(int *)malloc(sizeof(int)*m);
		c[i]=(int *)malloc(sizeof(int)*m);
	}
	populate(a,s,n,m);
	populate(a,s+10,n,m);
	matAdd(a,b,c,n,m);
	matPrint(c,n,m);
	return 0;
}