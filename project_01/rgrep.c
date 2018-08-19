#include <stdio.h>
#define MAXSIZE 4096

size_t strlen(const char* str)
{
	const char* s;
	for (s = str; *s; s++) {}
	return (s - str);
}

int rgrep_matches(char *line, char *pattern);
int pattern_match(char *line, char *pattern);
int q_wildcard_check(char *pattern, size_t plen);
int q_wildcard_resize(char *line, char *pattern, size_t plen);

int main(int argc, char **argv) {
	if (argc != 2) {
		fprintf(stderr, "Usage: %s <PATTERN>\n", argv[0]);
		return 2;
	}
	
	char buf[MAXSIZE];
	
	while (!feof(stdin) && !ferror(stdin)) {
		if (!fgets(buf, sizeof(buf), stdin)) {
			break;
		}
		if (rgrep_matches(buf, argv[1])) {
			fputs(buf, stdout);
			fflush(stdout);
		}
	}
	
	if (ferror(stdin)) {
		perror(argv[0]);
		return 1;
	}
	
	return 0;
}

int rgrep_matches(char *line, char *pattern) {
	int key = 0;
	
	size_t plen = strlen(pattern);
	
	key = q_wildcard_check(pattern, plen);
	
	if (key == 1) {
		return q_wildcard_resize(line, pattern, plen);
	}
	else {
		return pattern_match(line, pattern);
	}
}

int pattern_match(char *line, char *pattern) {
	int i = 0;
	int j = 0;
	
	size_t llen = strlen(line);
	size_t plen = strlen(pattern);
	
	char* lc = line;
	char* pc = pattern;
	
	for (; i < llen; i++) {
		if (j == plen) {
			return 1;
		}
		if ((*lc == *pc || *pc == '.') && plen == 1) {
			lc++;
			j++;
		}
		else if (*lc == *pc || *pc == '.') {
			if (*pc == '.') {
				*pc = *lc;
			}
			lc++;
			pc++;
			i++;
			j++;
			for (; i < llen; i++) {
				if (*lc == *pc || *pc == '.') {
					if (*pc == '.') {
						*pc = *lc;
					}
					lc++;
					pc++;
					j++;
					if (j == plen) {
						break;
					}
				}
				else if (*pc == '+') {
					pc--;
					for (; i < llen; i++) {
						if (*lc == *pc) {
							lc++;
						}
						else {
							pc++;
							i--;
							break;
						}
					}
					pc++;
					j++;
					if (*pc == *(pc - 2)) {
						pc++;
						j++;
						for (; j < plen + 1; j++) {
							if (*pc == *(pc - 1)) {
								pc++;
							}
							else {
								break;
							}
						}
					}
					if (j == plen) {
						break;
					}
				}
				else if (*pc == '\\') {
					pc++;
					j++;
					if (*lc == *pc) {
						lc++;
						pc++;
						j++;
					}
					else {
						break;
					}
					if (j == plen) {
						break;
					}
				}
				else {
					break;
				}
			}
		}
		else {
			lc++;
		}
	}
	
	return 0;
}

int q_wildcard_check(char *pattern, size_t plen) {
	int i = 0;
	
	for (; i < plen; i++) {
		if (*pattern == '?' && *(pattern - 1) != '\\') {
			return 1;
		}
		else {
			pattern++;
		}
	}
	
	return 0;
}

int q_wildcard_resize(char *line, char *pattern, size_t plen) {
	int i = 0;
	int j = 0;
	int k = 0;
	
	int d1 = 0;
	int d2 = 0;
	
	size_t plen1 = strlen(pattern) - 1;
	size_t plen2 = strlen(pattern) - 2;
	
	char pc1[plen1];
	char pc2[plen2];
	
	pc1[plen1] = '\0';
	pc2[plen2] = '\0'; 
	
	for (; i < plen + 1; i++) {
		if (*pattern == '?' && *(pattern - 1) != '\\') {
			k--;
			pattern++;
		}
		else {
			pc1[j] = *pattern;
			pc2[k] = *pattern;
			j++;
			k++;
			pattern++;
		}
	}
	
	d1 = pattern_match(line, pc1);
	d2 = pattern_match(line, pc2);
	
	if (d1 == 1 || d2 == 1) {
		return 1;
	}
	
	return 0;
}
