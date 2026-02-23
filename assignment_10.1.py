# ==========================================================
# Lab 10 – Code Review and Quality
# Menu Driven Program with Explanatory Comments
# ==========================================================


# ----------------------------------------------------------
# Task 1 – Syntax and Logic Errors (Fixed Version)
# This function calculates the average of marks entered by user.
# Earlier issues fixed:
# - Correct indentation
# - Typo in variable name
# - Missing bracket in print statement
# ----------------------------------------------------------
def calc_average(marks):
    total = 0                 # Variable to store sum of marks

    # Loop through list and add marks
    for m in marks:
        total += m

    # Calculate average
    average = total / len(marks)
    return average


# ----------------------------------------------------------
# Task 2 – PEP 8 Compliance
# Function written using proper naming conventions and spacing.
# ----------------------------------------------------------
def area_of_rect(length, breadth):
    """Return area of rectangle."""
    return length * breadth


# ----------------------------------------------------------
# Task 3 – Readability Enhancement
# Improved variable names and formatting for better clarity.
# ----------------------------------------------------------
def calculate_percentage(value, percent):
    # Multiply value with percent and divide by 100
    return value * percent / 100


# ----------------------------------------------------------
# Task 4 – Refactoring for Maintainability
# Created reusable function to avoid repeated print statements.
# ----------------------------------------------------------
def welcome_student(name):
    print("Welcome", name)


# ----------------------------------------------------------
# Task 5 – Performance Optimization
# Using list comprehension which is faster than normal loops.
# ----------------------------------------------------------
def find_squares(limit):
    # Generate squares efficiently
    squares = [n ** 2 for n in range(1, limit + 1)]
    print("Total Squares:", len(squares))


# ----------------------------------------------------------
# Task 6 – Complexity Reduction
# Replaced deeply nested if statements with elif for clarity.
# ----------------------------------------------------------
def grade(score):
    if score >= 90:
        return "A"
    elif score >= 80:
        return "B"
    elif score >= 70:
        return "C"
    elif score >= 60:
        return "D"
    else:
        return "F"


# ==========================================================
# MAIN MENU SECTION
# Menu allows user to choose which task to execute.
# ==========================================================
while True:

    # Display menu options
    print("\n===== LAB 10 MENU =====")
    print("1. Calculate Average Marks")
    print("2. Area of Rectangle")
    print("3. Calculate Percentage")
    print("4. Welcome Students")
    print("5. Find Squares (Optimized)")
    print("6. Grade Calculator")
    print("7. Exit")

    # Take user choice as input
    choice = input("Enter your choice: ")

    # ------------------------------------------------------
    # Choice 1 – Average Marks
    # ------------------------------------------------------
    if choice == "1":
        n = int(input("Enter number of marks: "))
        marks = []

        # Collect marks from user
        for i in range(n):
            m = float(input("Enter mark: "))
            marks.append(m)

        print("Average Score is", calc_average(marks))

    # ------------------------------------------------------
    # Choice 2 – Area of Rectangle
    # ------------------------------------------------------
    elif choice == "2":
        l = float(input("Enter length: "))
        b = float(input("Enter breadth: "))
        print("Area =", area_of_rect(l, b))

    # ------------------------------------------------------
    # Choice 3 – Percentage Calculation
    # ------------------------------------------------------
    elif choice == "3":
        value = float(input("Enter value: "))
        percent = float(input("Enter percentage: "))
        print("Result =", calculate_percentage(value, percent))

    # ------------------------------------------------------
    # Choice 4 – Welcome Students
    # Demonstrates reusable function
    # ------------------------------------------------------
    elif choice == "4":
        count = int(input("How many students? "))

        for i in range(count):
            name = input("Enter student name: ")
            welcome_student(name)

    # ------------------------------------------------------
    # Choice 5 – Optimized Squares
    # ------------------------------------------------------
    elif choice == "5":
        limit = int(input("Enter limit: "))
        find_squares(limit)

    # ------------------------------------------------------
    # Choice 6 – Grade Calculator
    # ------------------------------------------------------
    elif choice == "6":
        score = int(input("Enter score: "))
        print("Grade =", grade(score))

    # ------------------------------------------------------
    # Exit Program
    # ------------------------------------------------------
    elif choice == "7":
        print("Exiting Program...")
        break

    # ------------------------------------------------------
    # Invalid Choice Handling
    # ------------------------------------------------------
    else:
        print("Invalid Choice! Try again.")