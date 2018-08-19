#include <stdio.h>

int main()
{
	int i, num;

	printf("Enter the number of lines for the punishment: ");
	scanf("%d", &num);

	if (num > 0) {
		for (i = 0; i < num; i++) {
		printf("C programming language is the best! ");
		}
	}
	else {
		printf("You entered an incorrect value for the number of lines!");
	}

	printf("\n");
	return 0;
}
