num fib(num n){
    num a = 1;
    num b = 0;
    num temp;

    while (n >= 0) {
        temp = a;
        a = a + b;
        b = temp;
        n = n - 1;
    }

    return b;
}

print(fib(7));
