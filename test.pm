Object Math = {
	num add(num a, num b) {
		return a + b;
	}

	num mod(num a, num b) {
		return a % b;
	}

	num pow(num a, num b) {
		num base = a;
		while(b > 1) {
			a = a * base;
			b = b - 1;
		}
		return a;
	}

	num gcd (num x, num y)
	{
	    if(y == 0) {
	        return x;
	    }

	    return gcd(y, (x % y));
	}
};

printf("4 + 1 = %f\n", Math.add(4, 1));
printf("10 % 6 = %f\n", Math.mod(10, 6));
printf("2^5 = %f\n", Math.pow(2, 5));
printf("gcd of 240 and 150 = %f\n", Math.gcd(240, 150));
