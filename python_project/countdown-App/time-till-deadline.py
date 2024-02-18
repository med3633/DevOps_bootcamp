import datetime

#give us a deadline sperated with :
user_input=input("enter your goal with a deadline seperated by colone\n")
#put in list 
input_list = user_input.split(":")
#the goal
goal = input_list[0]
#the deadline
deadline = input_list[1]

deadline_date = datetime.datetime.strptime(deadline, "%Y.%m.%d")
today_date = datetime.datetime.today()
print(input_list)
# calculaate how many days from now till the deadline
till = deadline_date - today_date
print(f" Dear user! Time remainig for your goal{goal} is : {till.days} days")