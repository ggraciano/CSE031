#include <stdio.h>

int main()
{
	int i, num1, num2;

	printf("Enter the number of lines for the punishment: ");
	scanf("%d", &num1);

	printf("Enter the line for which we want to make a typo: ");
	scanf("%d", &num2);

	if (num1 > 0 && num2 > 0) {
		for (i = 0; i < num1; i++) {
			if (i != num2) {
				printf("C programming language is the best! ");
			}
			else {
				printf("C programming language is the bet! ");
			}
		}
	}
	if (num1 < 0) {
		printf("You entered an incorrect value for the number of lines!");
	}
	if (num2 < 0) {
		printf("You entered an incorrect value for the line typo!");
	}

	printf("\n");
	return 0;
}

