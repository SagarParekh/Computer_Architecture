#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <cstdlib>
#include <iostream>
using namespace std;
#include <chrono>
struct thread_data
{
   int n;//matrix size
   int a;
   int t; // no of threads
   int *A,*B,*C;  //pointers to matrices
   int thread_no;
};

void* multi_matrix(void* arg)

{   
    int i,j,k;
    
    struct thread_data* p =(struct thread_data*)arg; //data from threads[j] is transferred to to struct p
    int a = p->a;
    int t = p->t;
    int n  = p->n;
    int thread_no = p->thread_no;
    int *A = p->A;
    int *B = p->B;
    int *C = p->C;
    auto start_thread= std::chrono::high_resolution_clock::now();  //using the clock provided by chrono header

    for(int m=0; m<((n*n)/t);m++)
    {
       i=(a+m)/n;               //we need to calcuate an intermediate value because the matrix is stored as a sequence rather than a 2-D array
       j=(a+m)%n;
        for(k = 0; k < n; k++)
        {
          C[n*i + j] += A[n*i + k] * B[n*k + j];
        }
    }


    if(thread_no==t-1 && ((n*n)%t) !='0' )          // to take care of the condition when the number of threads != a power of 2
    {
         for(int m=(((n*n)/t)); m<(((n*n)%t)+((n*n)/t));m++)
        {
           i=(a+m)/n;
           j=(a+m)%n;
          for(k = 0; k < n; k++)
          {
              C[n*i + j] += A[n*i + k] * B[n*k + j];
          }
        }
    }

    auto finish_thread= std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed_thread=finish_thread-start_thread ;
    cout<<"Thread no. "<<thread_no+1<<" completed in "<<elapsed_thread.count()<<" s"<<endl;  //converting the ticks to seconds by .count() function

    return 0;

    }

void* Sequential(int *A , int *B , int *C, int n)
{
    for(int i = 0; i < n; i++)
    {
        for(int j = 0; j < n; j++)
        {
            for(int k = 0; k < n; k++)
            {
                C[n*i + j] += A[n*i + k] * B[n*k + j];
            }
        }
    }
 }


int main()                               //main program 
{
    int n;
    int t;
    cout<<"Enter the size of matrix"<<endl;     //take in the value of the size of the matrix and the number of threads
    std::cin>>n;
    cout<<"Enter number of threads"<<endl;
    std::cin>>t;
      
        int *A =(int*)std::calloc(n*n,sizeof(int));   // matrices initialized with all element 0 , using calloc() automatically assigns 0 to every element. 
        int *B = (int*) std::calloc(n*n,sizeof(int));
        int *C = (int*)std::calloc(n*n,sizeof(int)); 
        for (int i = 0; i < n*n; i++)
          {
            A[i] = rand()%10;              //generating A & B with random values.
            B[i] = rand()%10;     
            
          }

  
        auto start_seq= std::chrono::high_resolution_clock::now();
        Sequential(A, B, C, n);
        auto finish_seq= std::chrono::high_resolution_clock::now();
        std::chrono::duration<double> elapsed_seq=finish_seq-start_seq;

        cout<<"The time taken to multiply sequentially is : "<<elapsed_seq.count() << " s" <<endl;

        // declaring  threads
        pthread_t thread[t];            //declaring threads    
        struct thread_data threads[t];  //creating threads array
        
        auto start_all= std::chrono::high_resolution_clock::now();

        for(int j=0; j<t;j++)
        {
             threads[j].n=n;
             threads[j].t=t;
             threads[j].A = A;
             threads[j].B = B;
             threads[j].C = C;
             threads[j].thread_no= j;
             threads[j].a= j*((n*n)/t);
            pthread_create(&thread[j], NULL, multi_matrix,&threads[j]);    //create threas for processing 
        }
        for(int j=0; j<t;j++)
        {
          pthread_join(thread[j], NULL);    //wait for all thread to finish executing
        }
        auto finish_all= std::chrono::high_resolution_clock::now();
        std::chrono::duration<double> elapsed_all=finish_all-start_all;

        
        cout<<"\nTime taken using "<<t<<" threads is :"<<elapsed_all.count()<<" s"<<endl;
        cout<<"\nThe speedup executing using "<<t<<" threads is : " <<(elapsed_seq.count())/(elapsed_all.count())<<endl;
    
        
}