Which Product is the Most _Least Expensive ?

Ok, so the Key word is (TOPN)
this is the Straight forward Answer, I got an inspiration from this post answer in [StackOverFlow](https://stackoverflow.com/questions/68638273/pbi-dax-query-for-top-n-to-return-text)


        *Most_Expensive_Product = 
        
                TOPN(1,ALLNOBLANKROW('Products'[ProductName]),
                
                        'Products'[Unit Price],desc)



*The challenge's Author Solution:
   
           Most Expensive Alt = 
           
                   CALCULATE(
                   
                           SELECTEDVALUE(Products[ProductName]), 
                                  
                                   TOPN(1, Products, Products[UnitPrice], DESC))

OK, so this part of DAX (in the image attached) is returning a whole row, this viewed when you create a table with this DAX formula alone
![image](https://github.com/user-attachments/assets/8231d22c-90f7-4755-ac34-b091f0894f7f)

What we need is the prduct name only, which is returned by SELECTEDVALUE() Function.
