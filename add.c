#include<stdio.h>

int main(){
	char str[80];
	int i;
	
	printf("Enter your name: ");
	scanf("%s", str);
	printf("Enter your ID: ");
	scanf("%d", &i);
	printf("Name: %s, ID: %d \n", str, i);
}
