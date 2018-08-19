#include <stdio.h>

int main()
{
	char str[20];

	printf("Please enter your name: ");
	scanf("%[^\n]", str);

	printf("Welcome to CSE031, %s!\n", str);
	return 0;
}

