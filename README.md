# data_cleaning_laptops 


### Doublicate values
 -- check duplicate values --    

there are duplicates:

![image](https://github.com/user-attachments/assets/be437edc-8e00-4c69-a067-0805b47bbd98)


-- remove duplicates: --   

![image](https://github.com/user-attachments/assets/b4f03ee0-bb78-47e2-be2b-16f7bdf85f0d)

My sql does not allow to delete row  directly from an CTE table. I had to join the inital table with CTE table to delete the rows from the initial table. Another approach could be to create a new table base on CTe table.  


-- check again for the duplicates --  


### Datatypes of columns

![image](https://github.com/user-attachments/assets/b7b2ce6e-9720-4b54-89ad-111a2802aa5e)
