fun fib(string x)
{
  if (x is 0)
  return 0;
  if (x is 1) #is equivalent to ==?
  return 1;
}

num main()
{
  console.read(num x);    //user input
  console.log(fib(x - 1) + fib(x - 2));   //print
}