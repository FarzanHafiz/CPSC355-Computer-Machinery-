#include<stdio.h>

void mycpy(char *to, char *from);

int main(void){
	char str[80];
	
	mycpy(str, "this is a test. \n");
	printf(str);
	return 0;
}

void mycpy(char *to, char *from){
	while(*from){
		*to++ = *from++;
	}	
		*to = '\0';
	
}
