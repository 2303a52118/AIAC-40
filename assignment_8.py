"""Lab 8: Test-Driven Development with AI"""
from typing import Dict

# TASK 1: Password Strength Validator | Req: 8+ chars, uppercase, lowercase, digit, special, no spaces
# assert is_strong_password("Abcd@123")==True; assert is_strong_password("abcd123")==False
def is_strong_password(p:str)->bool:
    return isinstance(p,str) and len(p)>=8 and ' ' not in p and any(c.isupper() for c in p) and any(c.islower() for c in p) and any(c.isdigit() for c in p) and any(c in '!@#$%^&*()_+-=[]{};\'",./<>?\\|`~' for c in p)

# TASK 2: Number Classification | Req: Classify as Positive/Negative/Zero, handle invalid inputs
# assert classify_number(10)=="Positive"; assert classify_number(-5)=="Negative"; assert classify_number(0)=="Zero"
def classify_number(n)->str:
    if n is None or isinstance(n,(str,bool)):return "Invalid"
    try:num=float(n) if not isinstance(n,(int,float)) else n
    except:return "Invalid"
    return "Positive" if num>0 else ("Negative" if num<0 else "Zero")

# TASK 3: Anagram Checker | Req: Ignore case/spaces/punctuation, handle edge cases
# assert is_anagram("listen","silent")==True; assert is_anagram("hello","world")==False
def is_anagram(s1:str,s2:str)->bool:
    if not isinstance(s1,str) or not isinstance(s2,str):return False
    c1=''.join(x.lower() for x in s1 if x.isalnum())
    c2=''.join(x.lower() for x in s2 if x.isalnum())
    return (len(c1)==0 and len(c2)==0) or (len(c1)>0 and len(c2)>0 and sorted(c1)==sorted(c2))

# TASK 4: Inventory Class | Methods: add_item(name, qty), remove_item(name, qty), get_stock(name)
# inv.add_item("Pen",10); assert inv.get_stock("Pen")==10; inv.remove_item("Pen",5); assert inv.get_stock("Pen")==5
class Inventory:
    def __init__(self):self.stock:Dict[str,int]={}
    def add_item(self,n:str,q:int)->None:
        if not isinstance(n,str) or not isinstance(q,int) or isinstance(q,bool):raise TypeError("Invalid type")
        if q<0:raise ValueError("Quantity cannot be negative")
        self.stock[n]=self.stock.get(n,0)+q
    def remove_item(self,n:str,q:int)->None:
        if not isinstance(n,str) or not isinstance(q,int) or isinstance(q,bool):raise TypeError("Invalid type")
        if q<0:raise ValueError("Quantity cannot be negative")
        if n not in self.stock:raise KeyError(f"Item '{n}' not found")
        if self.stock[n]<q:raise ValueError("Insufficient stock")
        self.stock[n]-=q
        if self.stock[n]==0:del self.stock[n]
    def get_stock(self,n:str)->int:return self.stock.get(n,0) if isinstance(n,str) else (_ for _ in ()).throw(TypeError("Invalid type"))

# TASK 5: Date Validation & Formatting | Req: Validate MM/DD/YYYY, convert to YYYY-MM-DD
# assert validate_and_format_date("10/15/2023")=="2023-10-15"; assert validate_and_format_date("02/30/2023")=="Invalid Date"
def validate_and_format_date(d:str)->str:
    try:
        if not isinstance(d,str):return "Invalid Date"
        p=d.split('/')
        if len(p)!=3:return "Invalid Date"
        m,da,y=int(p[0]),int(p[1]),int(p[2])
        if m<1 or m>12 or da<1:return "Invalid Date"
        dm=[31,29 if y%4==0 and (y%100!=0 or y%400==0) else 28,31,30,31,30,31,31,30,31,30,31]
        if da>dm[m-1]:return "Invalid Date"
        return f"{y:04d}-{m:02d}-{da:02d}"
    except:return "Invalid Date"

if __name__=="__main__":
    print("\nLab 8: Test-Driven Development with AI\n")
    print("="*50)
    print("Main Menu")
    print("="*50)
    print("1. Password Validator")
    print("2. Number Classification")
    print("3. Anagram Checker")
    print("4. Inventory Manager")
    print("5. Date Validation & Formatting")
    print("6. Run All Tests")
    print("7. Exit")
    print("="*50)
    
    while True:
        choice = input("\nEnter your choice (1-7): ").strip()
        
        if choice == '1':
            pwd = input("Enter password: ")
            result = is_strong_password(pwd)
            print(f"Password '{pwd}' is {'STRONG' if result else 'WEAK'}") if result else print(f"Password '{pwd}' is WEAK")
        
        elif choice == '2':
            try:
                num = float(input("Enter a number: "))
            except:
                num = input("Enter a number: ")
            result = classify_number(num)
            print(f"Number classification: {result}")
        
        elif choice == '3':
            str1 = input("Enter first string: ")
            str2 = input("Enter second string: ")
            result = is_anagram(str1, str2)
            print(f"'{str1}' and '{str2}' are {'ANAGRAMS' if result else 'NOT ANAGRAMS'}")
        
        elif choice == '4':
            inv = Inventory()
            print("\nInventory Manager | Commands: add, remove, check, quit")
            while True:
                cmd = input("Command: ").strip().lower()
                if cmd == 'quit':
                    break
                elif cmd == 'add':
                    name = input("Item name: ")
                    qty = int(input("Quantity: "))
                    inv.add_item(name, qty)
                    print(f"Added {qty} {name}(s)")
                elif cmd == 'remove':
                    name = input("Item name: ")
                    qty = int(input("Quantity: "))
                    inv.remove_item(name, qty)
                    print(f"Removed {qty} {name}(s)")
                elif cmd == 'check':
                    name = input("Item name: ")
                    stock = inv.get_stock(name)
                    print(f"Stock of '{name}': {stock}")
                else:
                    print("Invalid command")
        
        elif choice == '5':
            date_str = input("Enter date (MM/DD/YYYY): ")
            result = validate_and_format_date(date_str)
            print(f"Result: {result}")
        
        elif choice == '6':
            print("\nRunning all tests...")
            assert is_strong_password("Abcd@123") and not is_strong_password("abcd123")
            print("✓ Task 1: Password Validator - PASSED")
            assert classify_number(10)=="Positive" and classify_number(-5)=="Negative" and classify_number(0)=="Zero"
            print("✓ Task 2: Number Classification - PASSED")
            assert is_anagram("listen","silent") and not is_anagram("hello","world")
            print("✓ Task 3: Anagram Checker - PASSED")
            inv=Inventory()
            inv.add_item("Pen",10)
            assert inv.get_stock("Pen")==10
            inv.remove_item("Pen",5)
            assert inv.get_stock("Pen")==5
            print("✓ Task 4: Inventory Class - PASSED")
            assert validate_and_format_date("10/15/2023")=="2023-10-15" and validate_and_format_date("02/30/2023")=="Invalid Date"
            print("✓ Task 5: Date Validation & Formatting - PASSED")
            print("\n✓ ALL 5 TASKS PASSED!\n")
        
        elif choice == '7':
            print("Exiting... Goodbye!")
            break
        
        else:
            print("Invalid choice. Please try again.")
