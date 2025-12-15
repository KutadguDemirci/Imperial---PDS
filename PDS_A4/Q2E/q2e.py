class Person:

    def __init__(self, name, age):
        self.__name = name  # Private attribute (name mangling)
        self.__age = age    # Private attribute
    
    def greet(self):
        return f"Hello, my name is {self.__name} and I am {self.__age} years old."

    def get_name(self):
        return self.__name
    
    def get_age(self):
        return self.__age
