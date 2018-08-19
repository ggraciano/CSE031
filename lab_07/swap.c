#include <stdio.h>

/* Procdure 'proc' generates a new variable on the stack, and thus, when 'temp' pointer is declared, 'temp' will hold 
 * the same position as the variable declared in 'proc'. When 'temp' is dereferenced, 'temp' no longer holds 
 * anything, which guarantees 'swap' to crash as a result of a segmentation fault. 
 */

int proc() {
	int c = 0;
}

void swap(int *px, *py) {
	int *temp;
	*temp = *px;
	*px = *py;
	*py = *temp;
}

int main()
{
	int a = 1, b = 2;
	proc();
	swap(&a, &b);
}

