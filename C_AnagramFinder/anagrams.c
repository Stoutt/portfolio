/************************************************************************
 * anagrams.c															*
 *																		*
 * Author(s): Tyler Stout and Steve Miesch								*
 ***********************************************************************/

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define INITIAL_ARRAY_SIZE 10000
#define MAX_WORD_SIZE 35

struct node {
	char *text;
	struct node  *next;
};

typedef struct node Node;

/************************************************************************
 * YOU MUST NOT DEFINE ANY GLOBAL VARIABLES (i.e., OUTSIDE FUNCTIONS).  *
 * COMMUNICATION BETWEEN FUNCTIONS MUST HAPPEN ONLY VIA PARAMETERS.     *
 ************************************************************************/

/************************************************************************
 * Function declarations/prototypes										*
 ************************************************************************/

Node **buildAnagramList(char *infile, int *arySize);

void printAnagramList(char *outfile, Node **list, int arySize);

void freeAnagramList(Node **list, int arySize);

bool areAnagrams(char *word1, char *word2);

Node *createNode(char *word);


/************************************************************************
 * Main driver of the program.											*
 * Use the following command format to run the program:					*
 * 		$ ./progname  infile  outfile									*
 * The input file is assumed to contain one word (of lower case			*
 * letters only) per line.												*
 ************************************************************************/
int main(int argc, char *argv[])
{
	Node **list;
	int arySize;
	if (argc != 3) {
		printf("Wrong number of arguments to program.\n");
		printf("Usage: ./progname infile outfile\n");
		exit(EXIT_FAILURE);
	}
	

	list = buildAnagramList(argv[1],&arySize);
	
	printAnagramList(argv[2],list,arySize);

	freeAnagramList(list,arySize);

	return EXIT_SUCCESS;
}

/************************************************************************
 * Takes a filename that contains one word (of lower case letters) per	*
 * line, reads the file contents, and build an array of pointers to		*
 * Node objects, and returns a pointer to this array. It also sets the	*
 * arySize parameter to the array size.									*
 ************************************************************************/
Node **buildAnagramList(char *infile, int *arySize)
{
	Node **list;

	// TODO: add other variable declarations as needed
	int i;
	int last = 0;
	char text[MAX_WORD_SIZE];
	bool noAnagram = true;
	Node *temp;

	FILE *fp = fopen(infile,"r");
	if (fp == NULL) {
		fprintf(stderr,"Error opening file %s\n", infile);
		exit(EXIT_FAILURE);
	}

	// TODO
	*arySize = INITIAL_ARRAY_SIZE;
	list = (Node **) calloc(*arySize, sizeof(Node *));
	
	while(fgets(text, MAX_WORD_SIZE, fp) != NULL){
		text[strlen(text)-1] = '\0';
		i = 0;
		while(list[i] != NULL){//loop through list,work with calloc?
			if(areAnagrams(list[i]->text,text)){//have anagram
				//add to end of list[i]
				temp = list[i];
				while(temp->next != NULL){//go to end
					temp = temp->next;
				}
				temp->next = createNode(text);

				noAnagram = false;
				break;
			}
			i++;
		}
		if(noAnagram && last <= *arySize){
			list[last] = createNode(text);
			printf("Last%d: %s\n",last,list[last]->text);
			last++;
		}
		else{
			noAnagram = true;
		}
		if (i == *arySize) { // if array is full, increase size
				*arySize *= 2;
				list = (Node **) realloc(list, *arySize * sizeof(Node *)); 
				//reallocate memory
				if (list == NULL) {
					fprintf(stderr,"memory reallocation failed\n");
					exit(EXIT_FAILURE);
				}
			}
	}
	fclose(fp);

	return list;
}

/************************************************************************
 * Takes a filename, an array of pointers to Node, and the size			*
 * of the array, and prints	the list of anagrams (see sample output) 	*
 * to the file specified.												*
 ************************************************************************/
void printAnagramList(char *outfile, Node **list, int arySize)
{
	// TODO
	printf("Printing\n");
	Node *temp;
	int i;
	int c=0;
	
	FILE *fp = fopen(outfile,"w");
		
	for(i=0;list[i] != NULL;i++){
		printf("I: %d\t",i);
		fprintf(fp,"%s ", list[i]->text);
		temp = list[i];
		c=0;
		while(temp->next != NULL){
			c++;
			temp = temp->next;
			fprintf(fp,"%s ", temp->text);
		}
		fprintf(fp,"%c",'\n');
	}
	fclose(fp);
}

/************************************************************************
 * Releases memory allocated for the array of pointers to Node.			*
 * This involves releasing the memory allocated for each Node in each	*
 * linked list and the array itself. Before freeing up memory of a Node *
 * object, make sure to release the memory allocated for the 			*
 * "text" field of that node first.										*
 ************************************************************************/
void freeAnagramList(Node **list, int arySize)
{
	// TODO
	int i;
	Node *temp;
	Node *temp2;
	for(i=0;list[i] != NULL;i++){
		if(list[i]->next != NULL){
			//free the linked nodes
			temp = list[i];
			while(temp != NULL){
				free(temp->text);
				temp2 = temp->next;
				free(temp);
				temp = temp2;
			}
		}
		else{
			free(list[i]->text);
			free(list[i]);
		}
	}
	free(list);
}

/************************************************************************
 * Allocates memory for a Node object and initializes the "text" field	*
 * with the input string/word and the "next" field to NULL. Returns a	*
 * pointer to the Node object.											*
 ************************************************************************/
Node *createNode(char *word)
{
	Node *node ;

	// TODO
	node = (Node*) malloc(sizeof(Node));
	node->text = (char*)malloc (strlen(word)+1);
	strcpy(node->text, word);
	node->next = NULL;

	return node;
}

/************************************************************************
 * Returns true if the input strings are anagrams, false otherwise.		*
 * Assumes the words contain only lower case letters.					*
 ************************************************************************/
bool areAnagrams(char *word1, char *word2)
{
	bool anagram = false;
	char temp1[MAX_WORD_SIZE],temp2[MAX_WORD_SIZE];
	char x,y;
	int i,j,k;

	strcpy(temp1,word1);
	strcpy(temp2,word2);

	if(strlen(temp1) == strlen(temp2)){
		for(j = 0; j < strlen(temp1)-1; j++){
			for(k = 0; k <strlen(temp1)-1; k++){
				if(temp1[k] > temp1[k+1])
				{
					x = temp1[k];
					temp1[k] = temp1[k+1];
					temp1[k+1] = x;
				}
				if(temp2[k] > temp2[k+1])
				{
					y = temp2[k];
					temp2[k] = temp2[k+1];
					temp2[k+1] = y;
				}
			}
		}
		for(i = 0; i < strlen(temp1); i++){
			if(temp1[i] != temp2[i]){
				return false;
			}else{
				anagram = true;
			}
		}
	}

	return anagram;
}
